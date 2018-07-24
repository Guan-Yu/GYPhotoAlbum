//
//  GYPhotoBrowserController.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYPhotoBrowserController.h"
#import "GYPhotoBrowserCell.h"

@interface GYPhotoBrowserController ()
<UICollectionViewDelegate, UICollectionViewDataSource>
{
    __weak IBOutlet UIButton *_selectBtn;
    __weak IBOutlet UIButton *_deleteBtn;
    __weak IBOutlet NSLayoutConstraint *_widthConstraintForNextBtn;
    __weak IBOutlet UIButton *_nextBtn;
    __weak IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet UILabel *_titleLabel;
}
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) GYPhotoBrowser *browser;
@property (nonatomic, assign) GYPhotoBrowserType type;
@end

static NSString *const NIB_NAME = @"GYPhotoBrowserController";

@implementation GYPhotoBrowserController

- (id)initWithPhotoBrowser:(GYPhotoBrowser *)browser type:(GYPhotoBrowserType)type index:(NSUInteger)index{
    if (self = [super initWithNibName:NIB_NAME bundle:nil]) {
        self.browser = browser;
        self.type = type;
        self.page = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (_type) {
        case GYPhotoBrowserTypeSelection:
            _nextBtn.hidden = false;
            _selectBtn.hidden = false;
            break;
            
        case GYPhotoBrowserTypeTempPreview: case GYPhotoBrowserTypePreview:
            _deleteBtn.hidden = false;
            break;
            
        default:
            break;
    }
    [self setupCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self performSelector:@selector(gotoCurrentIndex) withObject:nil afterDelay:0];
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait ;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


#pragma mark - Private
- (void)updateButtonState {
    BOOL enable = _browser.tempSelectedAssets.count > 0;
    _nextBtn.enabled = enable;
    NSString *title = @"下一步";
    if (enable) {
        title = [NSString stringWithFormat:@"%@(%lu)",title,_browser.tempSelectedAssets.count];
    }
    [_nextBtn setTitle:title forState:UIControlStateNormal];
    CGFloat nextBtnWidth = enable? 80: 65;
    _widthConstraintForNextBtn.constant = nextBtnWidth;
    [_nextBtn updateConstraints];
}

- (void)gotoCurrentIndex {
    switch (_type) {
        case GYPhotoBrowserTypeSelection:
            if (_browser.currentCollection.index == 0) {
                [self updateIndex];
            } else {
                _collectionView.contentOffset = CGPointMake(_collectionView.frame.size.width*_browser.currentCollection.index, 0);
            }
            [self updateButtonState];
            break;
            
        case GYPhotoBrowserTypeTempPreview: case GYPhotoBrowserTypePreview:
            if (_page == 0) {
                [self updateIndex];
            } else {
                _collectionView.contentOffset = CGPointMake(_collectionView.frame.size.width*_page, 0);
            }
            break;
            
        default:
            break;
    }
}

- (void)updateIndex {
    self.page = floorf((_collectionView.contentOffset.x+_collectionView.frame.size.width/2)/_collectionView.frame.size.width);
    switch (_type) {
        case GYPhotoBrowserTypeSelection:
            _browser.currentCollection.index = _page;
            _titleLabel.text = [NSString stringWithFormat:@"%lu/%lu",_browser.currentCollection.index+1, _browser.currentCollection.assets.count];
            _selectBtn.selected = [_browser getAssetSelected:_browser.currentCollection.currentAsset];
            break;
            
            case GYPhotoBrowserTypeTempPreview: case GYPhotoBrowserTypePreview:
            _titleLabel.text = [NSString stringWithFormat:@"%lu/%lu",_page+1, _browser.tempSelectedAssets.count];
            break;
            
        default:
            break;
    }
}

#pragma mark - Action
- (IBAction)onSelectBtn:(id)sender {
    if (!_selectBtn.selected) {
        [_browser addSelectedAsset:_browser.currentCollection.currentAsset];
    } else {
        [_browser removeSelectedAsset:_browser.currentCollection.currentAsset];
    }
    _selectBtn.selected = [_browser getAssetSelected:_browser.currentCollection.currentAsset];
    [self updateButtonState];
}

- (IBAction)onNextBtn:(id)sender {
    [_browser didFinishedSelection];
    if (_selectedBlock) {
        _selectedBlock(_browser);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDeleteBtn:(id)sender {
    if (_browser.tempSelectedAssets.count == 1) {
        [_browser.tempSelectedAssets removeLastObject];
        [_browser didFinishedSelection];
        [self onBackBtn:nil];
        return;
    }
    
    _deleteBtn.userInteractionEnabled = false;
    __weak GYPhotoBrowserController *weakSelf = self;
    [_collectionView performBatchUpdates:^{
        __strong GYPhotoBrowserController *strongSelf = weakSelf;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:strongSelf->_page inSection:0];
        [strongSelf->_browser.tempSelectedAssets removeObjectAtIndex:strongSelf->_page];
        [strongSelf->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        if (finished) {
            __strong GYPhotoBrowserController *strongSelf = weakSelf;
            strongSelf->_deleteBtn.userInteractionEnabled = true;
           [self updateIndex];
        }
    }];
}

- (IBAction)onBackBtn:(id)sender {
    if (_type == GYPhotoBrowserTypePreview) {//从外部进入因为没有完成按钮，所以返回按钮用作确认
        [_browser didFinishedSelection];
        if (_selectedBlock) {
            _selectedBlock(_browser);
        }
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UICollectionView
- (void)setupCollectionView {
    [_collectionView registerNib:[UINib nibWithNibName:GYPhotoBrowserCell_ID bundle:nil] forCellWithReuseIdentifier:GYPhotoBrowserCell_ID];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    [_collectionView reloadData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GYPhotoBrowserCell_ID forIndexPath:indexPath];
    switch (_type) {
        case GYPhotoBrowserTypeSelection:
            cell.asset = _browser.currentCollection.assets[indexPath.row];
            break;
            
        case GYPhotoBrowserTypeTempPreview: case GYPhotoBrowserTypePreview:
            cell.asset = _browser.tempSelectedAssets[indexPath.row];
            break;
            
        default: break;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (_type) {
        case GYPhotoBrowserTypeSelection:
            return _browser.currentCollection.assets.count;
            
        case GYPhotoBrowserTypeTempPreview: case GYPhotoBrowserTypePreview:
            return _browser.tempSelectedAssets.count;
            
        default: break;
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateIndex];
}

@end

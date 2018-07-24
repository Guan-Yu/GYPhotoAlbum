//
//  GYPhotoAlbumController.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYPhotoAlbumController.h"
#import "GYPhotoAlbumCell.h"
#import <Photos/Photos.h>
#import "GYPhotoBrowser.h"
#import "GYPhotoBrowserController.h"
#import "GYCollectionListView.h"

#import "GYPhotoAlbum.h"

@interface GYPhotoAlbumController ()
<UICollectionViewDataSource, UICollectionViewDelegate, GYPhotoAlbumCellDelegate, GYCollectionListViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *_widthConstraintForNextBtn;
    __weak IBOutlet UIButton *_nextBtn;
    __weak IBOutlet UIButton *_previewBtn;
    __weak IBOutlet UIButton *_titleBtn;
    __weak IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet GYCollectionListView *_collectionListView;
}
@property (nonatomic, strong) GYPhotoBrowser *browser;

@end

@implementation GYPhotoAlbumController

- (instancetype)initWithPhotoBrowser:(GYPhotoBrowser *)browser {
    if (self = [super initWithNibName:@"GYPhotoAlbumController" bundle:nil]) {
        self.browser = browser;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_10_0
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
    [self setupCollectionView];
    [self updateTitleButtonState];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self gotoCurrentIndex];
    [self updateButtonState];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
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
    _previewBtn.enabled = enable;
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

- (void)updateTitleButtonState {
    NSString *title = _browser.currentCollection.title;
    [_titleBtn setTitle:title forState:UIControlStateNormal];
    [_titleBtn setTitle:title forState:UIControlStateSelected];
    CGFloat maxWidth = _titleBtn.frame.size.width - (_titleBtn.titleEdgeInsets.left + _titleBtn.titleEdgeInsets.right);
    NSDictionary *attribute = @{NSFontAttributeName: _titleBtn.titleLabel.font};
    CGRect rect = [title boundingRectWithSize:CGSizeMake(maxWidth, 30) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    CGFloat textWidth = rect.size.width;
    CGFloat imageWidth = 11;
    CGFloat space = 10;
    CGFloat insetLeft = (_titleBtn.frame.size.width - textWidth) / 2 + textWidth + space;
    CGFloat insetRight = _titleBtn.frame.size.width - insetLeft - imageWidth;
    _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(_titleBtn.imageEdgeInsets.top, insetLeft, _titleBtn.imageEdgeInsets.bottom, insetRight);
}

- (void)gotoCurrentIndex {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    NSInteger line = _browser.currentCollection.index%4? _browser.currentCollection.index/4+1: _browser.currentCollection.index/4;
    CGFloat y = line * layout.itemSize.height;
    bool canSee = y >= _collectionView.contentOffset.y && y <= _collectionView.contentOffset.y + _collectionView.frame.size.height - layout.itemSize.height;
    if (!canSee) {
        CGFloat offsetY = y + (layout.itemSize.height/2) - (_collectionView.frame.size.height/2);
        offsetY = MIN(offsetY, _collectionView.contentSize.height - _collectionView.frame.size.height);
        offsetY = MAX(offsetY, 0);
        _collectionView.contentOffset = CGPointMake(0, offsetY);
    }
    [_collectionView reloadData];
}

#pragma mark - Action
- (IBAction)onSelectCollectionBtn:(UIButton *)button {
    _titleBtn.selected = !_titleBtn.selected;
    if (button.selected) {
        _collectionListView.browser = _browser;
        [_collectionListView show];
    } else {
        [_collectionListView hide];
    }
}

- (IBAction)onNextBtn:(id)sender {
    [_browser didFinishedSelection];
    if (_selectedBlock) {
        _selectedBlock(_browser);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCancelBtn:(id)sender {
    [_browser didCancelSelection];
    if (_selectedBlock) {
        _selectedBlock(_browser);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onPreviewBtn:(id)sender {
    GYPhotoBrowserController *controller = [[GYPhotoBrowserController alloc] initWithPhotoBrowser:_browser type:GYPhotoBrowserTypeTempPreview index:0];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UICollectionView
- (void)setupCollectionView {
    [_collectionView registerNib:[UINib nibWithNibName:GYPhotoAlbumCell_ID bundle:nil] forCellWithReuseIdentifier:GYPhotoAlbumCell_ID];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat cellWidth = (screenWidth - 3)/4;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(cellWidth, cellWidth);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYPhotoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GYPhotoAlbumCell_ID forIndexPath:indexPath];
    cell.delegate = self;
    cell.asset = _browser.currentCollection.assets[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _browser.currentCollection.assets.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _browser.currentCollection.index = indexPath.row;
    GYPhotoBrowserController *controller = [[GYPhotoBrowserController alloc] initWithPhotoBrowser:_browser type:GYPhotoBrowserTypeSelection index:_browser.currentCollection.index];
    controller.selectedBlock = _selectedBlock;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - GYPhotoAlbumCellDelegate
- (BOOL)photoAlbumCell:(GYPhotoAlbumCell *)cell selectedAsset:(GYAsset *)asset {
    BOOL added = [_browser addSelectedAsset:asset];
    if (added) {
        [self updateButtonState];
    }
    return added;
}

- (BOOL)photoAlbumCell:(GYPhotoAlbumCell *)cell deselectedAsset:(GYAsset *)asset {
    BOOL removed = [_browser removeSelectedAsset:asset];
    if (removed) {
        [self updateButtonState];
    }
    return removed;
}

- (BOOL)getSelectedWithPhotoAlbumCell:(GYPhotoAlbumCell *)cell {
    return [_browser getAssetSelected:cell.asset];
}

#pragma mark - GYCollectionListViewDelegate
- (void)collectionListView:(GYCollectionListView *)view selectedAssetCollection:(GYAssetCollection *)collection {
    _titleBtn.selected = false;
    [self updateTitleButtonState];
    [_collectionView reloadData];
}

@end


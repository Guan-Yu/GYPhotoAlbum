//
//  GYMultiSelectedPhotoView
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/10.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYMultiSelectedPhotoView.h"
#import "GYSelectedPhotoView.h"
#import "GYAsset.h"
#import "GYPhotoAlbum.h"
#import "GYPhotoBrowserController.h"
#import "GYImageUtil.h"

static NSInteger const ITEM_SPACE = 5;

@interface GYMultiSelectedPhotoView ()
<GYSelectedPhotoViewDelegate>
{
    UIButton *_addBtn;
    NSMutableArray *_photoViews;
}
@end

@implementation GYMultiSelectedPhotoView

- (void)restoreWithSelectedAssets:(NSArray *)assets {
    [GYImageUtil requestAuthorization:^(BOOL isSuccess) {
        if (isSuccess) {
            self.browser = [GYPhotoBrowser browserWithSelectedAssets:assets maxSelection:9];
        } else {
            [GYImageUtil showAuthorizationAlertWithRootController:self->_rootController];
        }
    }];
}

- (void)setBrowser:(GYPhotoBrowser *)browser {
    _browser = browser;
    
    for (NSUInteger i=_photoViews.count; i<browser.selectedAssets.count; i++) {
        UIView *view = [self createPhotoViewWithAsset:browser.selectedAssets[i] index:i];
        [_photoViews addObject:view];
        [self addSubview:view];
    }
    for (NSInteger i=_photoViews.count-1; i>=browser.selectedAssets.count && i>=0; i--) {
        UIView *view = _photoViews[i];
        [view removeFromSuperview];
        [_photoViews removeObjectAtIndex:i];
    }
    for (NSInteger i=0; i<_photoViews.count && i<browser.selectedAssets.count; i++) {
        GYAsset *asset = browser.selectedAssets[i];
        GYSelectedPhotoView *view = _photoViews[i];
        view.asset = asset;
        [self setFrameWithSubView:view index:i];
    }
    
    if ([_delegate respondsToSelector:@selector(multiSelectedPhotoView:didChangeSelectedPhotos:)]) {
        [_delegate multiSelectedPhotoView:self didChangeSelectedPhotos:[_browser.selectedAssets copy]];
    }
    
    [self updateAddBtnState];
    [self updateViewHeight];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.autoresizesSubviews = false;
    _photoViews = [NSMutableArray array];
    _maxSelection = 9;
    _rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [self initAddButton];
    [self updateViewHeight];
}

- (void)initAddButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(onAddButton) forControlEvents:UIControlEventTouchUpInside];
    button.clipsToBounds = true;
    [button setImage:[UIImage imageNamed:@"btn_add_photo.png"] forState:UIControlStateNormal];
    [self addSubview:button];
    _addBtn = button;
    
    [self setFrameWithSubView:_addBtn index:0];
}

- (void)updateAddBtnState {
    if (_browser.selectedAssets.count < _maxSelection) {
        [self addSubview:_addBtn];
        [self setFrameWithSubView:_addBtn index:_photoViews.count];
    } else {
        [_addBtn removeFromSuperview];
    }
}

- (void)updateViewHeight {
    NSInteger itemsCount = _browser.selectedAssets.count;
    if (_addBtn.superview) {
        itemsCount += 1;
    }
    NSInteger row = itemsCount%3? itemsCount/3+1: itemsCount/3;
    CGFloat height = row * _addBtn.frame.size.height + ((row-1) * ITEM_SPACE);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    if ([_delegate respondsToSelector:@selector(multiSelectedPhotoView:didChangeHeight:)]) {
        [_delegate multiSelectedPhotoView:self didChangeHeight:height];
    }
}

- (void)setFrameWithSubView:(UIView *)view index:(NSInteger)index {
    NSInteger row = index/3;
    NSInteger column = index%3;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - (self.frame.origin.x * 2);
    CGFloat size = (width - (ITEM_SPACE*2)) / 3;
    view.layer.cornerRadius = 5;
    CGFloat left = (size + ITEM_SPACE) * column;
    CGFloat top = (size + ITEM_SPACE) * row;
    view.frame = CGRectMake(left, top, size, size);
}

- (void)moveToIndexWithArray:(NSMutableArray *)array object:(NSObject *)object toIndex:(NSInteger)index {
    if (!object) {
        return;
    }
    [array removeObject:object];
    [array insertObject:object atIndex:index];
}

- (void)updateSubviewsCenterWithAddButtonAnimation:(BOOL)animation {
    [UIView animateWithDuration:0.25 animations:^{
        for (NSInteger i=0; i<self->_photoViews.count; i++) {
            GYSelectedPhotoView *view = self->_photoViews[i];
            [self setFrameWithSubView:view index:i];
        }
        if (animation) {
            [self updateAddBtnState];
        }
    }];
    if (!animation) {
        [self updateAddBtnState];
        _addBtn.alpha = 0;
        [UIView animateWithDuration:.25 animations:^{
            self->_addBtn.alpha = 1;
        }];
        
    }
}

- (GYSelectedPhotoView *)createPhotoViewWithAsset:(GYAsset *)asset index:(NSInteger)index{
    GYSelectedPhotoView *view = [[NSBundle mainBundle] loadNibNamed:@"GYSelectedPhotoView" owner:nil options:nil][0];
    view.delegate = self;
    return view;
}

#pragma mark - Action
- (void)onAddButton {
    [GYPhotoAlbum selectImagesWithRootController:_rootController
                                    maxSelection:_maxSelection
                                  currentBrowser:_browser
                                   selectedBlock:^(GYPhotoBrowser *browser) {
        self.browser = browser;
    }];
}

#pragma mark - GYSelectedPhotoViewDelegate
- (void)selectedPhotoViewWithDelete:(GYSelectedPhotoView *)view {
    BOOL doAnimation = _photoViews.count != _maxSelection;
    [_browser removeSelectedAsset:view.asset];
    [_browser didFinishedSelection];
    [view removeFromSuperview];
    [_photoViews removeObject:view];
    [self updateSubviewsCenterWithAddButtonAnimation:doAnimation];
    [self updateViewHeight];
}

- (void)selectedPhotoViewWithPreview:(GYSelectedPhotoView *)view {
    NSInteger index = [_photoViews indexOfObject:view];
    GYPhotoBrowserController *controller = [[GYPhotoBrowserController alloc] initWithPhotoBrowser:_browser type:GYPhotoBrowserTypePreview index:index];
    __weak GYMultiSelectedPhotoView *weakSelf = self;
    controller.selectedBlock = ^(GYPhotoBrowser *browser) {
        __strong GYMultiSelectedPhotoView *strongSelf = weakSelf;
        strongSelf.browser = browser;
    };
    [_rootController presentViewController:controller animated:true completion:nil];
}

- (void)selectedPhotoViewWithMove:(GYSelectedPhotoView *)view state:(GYSelectedPhotoViewMoveState)state location:(CGPoint)location {
    switch (state) {
        case GYSelectedPhotoViewMoveStateStart: {
            view.center = location;
            [UIView animateWithDuration:0.25 animations:^{
                view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                view.alpha = 0.7;
            }];
            [self bringSubviewToFront:view];
        }break;
            
        case GYSelectedPhotoViewMoveStateChange: {
            view.center = location;
            
            NSInteger toIndex = -1;
            for (NSInteger i=0; i<_photoViews.count; i++) {
                GYSelectedPhotoView *aView = _photoViews[i];
                if (aView == view) {
                    continue;
                }
                CGFloat xspace = fabs(location.x - aView.center.x);
                CGFloat yspace = fabs(location.y - aView.center.y);
                if (xspace < view.frame.size.width/2 && yspace < view.frame.size.height/2) {
                    toIndex = i;
                    break;
                }
            }
            if (toIndex >= 0) {
                [self moveToIndexWithArray:_photoViews object:view toIndex:toIndex];
                [self moveToIndexWithArray:_browser.selectedAssets object:view.asset toIndex:toIndex];
                [UIView animateWithDuration:0.25 animations:^{
                    for (NSInteger i=0; i<self->_photoViews.count; i++) {
                        GYSelectedPhotoView *willMoveView = self->_photoViews[i];
                        if (willMoveView == view) {
                            continue;
                        }
                        [self setFrameWithSubView:willMoveView index:i];
                    }
                }];
            }
        }break;
            
        case GYSelectedPhotoViewMoveStateEnd:{
            [UIView animateWithDuration:.25 animations:^{
                view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                view.alpha = 1;
                [self setFrameWithSubView:view index:[self->_photoViews indexOfObject:view]];
            }];
        }break;
            
        default:break;
    }
}

@end



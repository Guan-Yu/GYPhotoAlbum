//
//  GYSelectedPhotoView.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/10.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYSelectedPhotoView.h"

@interface GYSelectedPhotoView ()
<UIGestureRecognizerDelegate>
{
    __weak IBOutlet UIButton *_deleteBtn;
    __weak IBOutlet UIImageView *_imageView;
}
@end

@implementation GYSelectedPhotoView

- (void)setAsset:(GYAsset *)asset {
    _asset = asset;
    
    _imageView.image = [asset getImageThumb];
}

#pragma mark - Private
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelfView)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGestre:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}

#pragma mark - Action
- (IBAction)onDeleteBtn:(id)sender {
    if ([_delegate respondsToSelector:@selector(selectedPhotoViewWithDelete:)]) {
        [_delegate selectedPhotoViewWithDelete:self];
    }
}

- (void)onPanGestre:(UIPanGestureRecognizer *)gesture {
    if (![_delegate respondsToSelector:@selector(selectedPhotoViewWithMove:state:location:)]) {
        return;
    }
    CGPoint location = [gesture locationInView:self.superview];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            [_delegate selectedPhotoViewWithMove:self state:GYSelectedPhotoViewMoveStateStart location:location];
            break;
            
            case UIGestureRecognizerStateChanged:
            [_delegate selectedPhotoViewWithMove:self state:GYSelectedPhotoViewMoveStateChange location:location];
            break;
            
        default:
            [_delegate selectedPhotoViewWithMove:self state:GYSelectedPhotoViewMoveStateEnd location:location];
            break;
    }
}

- (void)onSelfView {
    if ([_delegate respondsToSelector:@selector(selectedPhotoViewWithPreview:)]) {
        [_delegate selectedPhotoViewWithPreview:self];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return gestureRecognizer.view != _deleteBtn;
}

@end

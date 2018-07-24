//
//  GYSelectedPhotoView.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/10.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAsset.h"

typedef enum {
    GYSelectedPhotoViewMoveStateStart,
    GYSelectedPhotoViewMoveStateChange,
    GYSelectedPhotoViewMoveStateEnd
} GYSelectedPhotoViewMoveState;

@class GYSelectedPhotoView;
@protocol GYSelectedPhotoViewDelegate <NSObject>
@optional
- (void)selectedPhotoViewWithDelete:(GYSelectedPhotoView *)view;
- (void)selectedPhotoViewWithPreview:(GYSelectedPhotoView *)view;
- (void)selectedPhotoViewWithMove:(GYSelectedPhotoView *)view state:(GYSelectedPhotoViewMoveState)state location:(CGPoint)location;
@end

@interface GYSelectedPhotoView : UIView
@property (nonatomic, strong) GYAsset *asset;
@property (nonatomic, weak) id<GYSelectedPhotoViewDelegate>delegate;
@end

//
//  GYMultiSelectedPhotoView
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/10.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPhotoBrowser.h"
#import "GYSelectedPhotoView.h"

@class GYMultiSelectedPhotoView;
@protocol GYMultiSelectedPhotoViewDelegate <NSObject>
- (void)multiSelectedPhotoView:(GYMultiSelectedPhotoView *)view didChangeHeight:(CGFloat)height;
- (void)multiSelectedPhotoView:(GYMultiSelectedPhotoView *)view didChangeSelectedPhotos:(NSArray *)photos;
@end

@interface GYMultiSelectedPhotoView : UIView
@property (nonatomic, readonly, strong) GYPhotoBrowser *browser;
@property (nonatomic, weak) IBOutlet id<GYMultiSelectedPhotoViewDelegate>delegate;
@property (nonatomic, weak) UIViewController *rootController; //default window rootController
@property (nonatomic, assign) NSInteger maxSelection; //default 9

- (void)restoreWithSelectedAssets:(NSArray *)assets;
@end

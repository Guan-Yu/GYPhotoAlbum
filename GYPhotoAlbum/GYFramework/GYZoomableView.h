//
//  ZoomableView.h
//  ComicReader
//
//  Created by YanGuanyu on 13-9-25.
//  Copyright (c) 2013年 YanGuanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYZoomableView;
@protocol GYZoomableViewDelegate<NSObject>
- (void)zoomableViewDidTapped:(GYZoomableView *)zoomableView;
@end

@interface GYZoomableView : UIScrollView
@property (nonatomic, strong) UIView *view;
@property (nonatomic, weak) id<GYZoomableViewDelegate>tapDelegate;
@end

@interface GYImageZoomableView : GYZoomableView
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@end


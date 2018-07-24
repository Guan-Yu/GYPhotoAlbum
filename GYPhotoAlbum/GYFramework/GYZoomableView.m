//
//  ZoomableView.m
//  ComicReader
//
//  Created by YanGuanyu on 13-9-25.
//  Copyright (c) 2013年 YanGuanyu. All rights reserved.
//

#import "GYZoomableView.h"

@interface GYZoomableView()
<UIScrollViewDelegate>
{
    
}
@end

@implementation GYZoomableView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initView];
}

- (void)initView{
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    gesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:gesture];
    
    self.contentSize = self.frame.size;
    self.minimumZoomScale = 1;
    self.maximumZoomScale = 3;
    self.delegate = self;
    self.decelerationRate = 0;
    self.bouncesZoom = false;
}

- (void)setTapDelegate:(id<GYZoomableViewDelegate>)tapDelegate {
    _tapDelegate = tapDelegate;
    
    if (tapDelegate && [tapDelegate respondsToSelector:@selector(zoomableViewDidTapped:)]) {
        UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:singleGesture];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {
    [self performSelector:@selector(didSingleTap) withObject:nil afterDelay:.5];
}

- (void)didSingleTap {
    [_tapDelegate zoomableViewDidTapped:self];
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
//    CGPoint location = [gesture locationInView:self];
    if (self.zoomScale>self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }else{
        [self setZoomScale:self.maximumZoomScale animated:YES];

//        self.contentSize = CGSizeMake(_view.frame.size.width, _view.frame.size.height);
//        _view.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
//        
//        float contentX = location.x*self.maximumZoomScale;
//        contentX -= self.frame.size.width/2;
//        contentX = MAX(0, contentX);
//        contentX = MIN(self.contentSize.width-self.frame.size.width, contentX);
//        float contentY = location.y*self.maximumZoomScale;
//        contentY -= self.frame.size.height/2;
//        contentY = MAX(0, contentY);
//        contentY = MIN(self.contentSize.height-self.frame.size.height, contentY);
//        [self setContentOffset:CGPointMake(contentX, contentY) animated:YES];
//        self.contentOffset = CGPointMake(contentX, contentY);
    }
}

- (void)setView:(UIView *)view{
    [_view removeFromSuperview];
    _view = view;
    [self addSubview:view];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _view;
}

//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
//    [scrollView setZoomScale:scale animated:NO];
//}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    scrollView.contentSize = CGSizeMake(MAX(scrollView.contentSize.width, scrollView.frame.size.width), MAX(scrollView.contentSize.height, scrollView.frame.size.height));
    _view.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
}

@end


#pragma mark - GYImageZoomableView
@interface GYImageZoomableView()
{
    UIImageView *_imageView;
    BOOL _firstLayout;
}

@end

@implementation GYImageZoomableView

- (void)awakeFromNib{
    [super awakeFromNib];
    _imageView = [[UIImageView alloc] init];
    [_imageView setBackgroundColor: [UIColor redColor]];
    _firstLayout = true;
    self.view = _imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_firstLayout) { //初始自动布局会引起页面错误，需要自动布局完成以后再刷新界面
        _firstLayout = false;
        if (_image) {
            [self setImage:_image];
        }
    }
}

- (UIImageView *)imageView {
    return _imageView;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    
    _imageView.image = image;
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    if (!image) {
        return;
    }
    if (image.size.width/image.size.height > width/height) {
        height = image.size.height/image.size.width*width;
    } else {
        width = image.size.width/image.size.height*height;
    }
    [self setZoomScale:self.minimumZoomScale animated:false];
    _imageView.frame = CGRectMake(0, 0, width, height);
    self.contentSize = _imageView.frame.size;
    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}
@end


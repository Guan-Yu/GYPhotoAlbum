//
//  GYPhotoBrowserCell.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYPhotoBrowserCell.h"
#import "GYZoomableView.h"
#import "GYAsset.h"

@interface GYPhotoBrowserCell() {
    __weak IBOutlet GYImageZoomableView *_imageZoomableView;
}
@end

@implementation GYPhotoBrowserCell

- (void)setAsset:(GYAsset *)asset {
    _asset = asset;
    
    [asset getImageWithResultBlock:^(UIImage *image) {
        self->_imageZoomableView.image = image;
    }];
}

@end

//
//  GYPhotoAlbumController.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPhotoBrowser.h"
#import "GYPhotoAlbum.h"

@interface GYPhotoAlbumController : UIViewController
@property (nonatomic, copy) GYSelectedBlock selectedBlock;
- (instancetype)initWithPhotoBrowser:(GYPhotoBrowser *)browser;
@end

//
//  GYPhotoBrowserController.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "GYPhotoBrowser.h"
#import "GYPhotoAlbum.h"

typedef enum {
    GYPhotoBrowserTypeDefault = 0,
    GYPhotoBrowserTypeSelection,
    GYPhotoBrowserTypeTempPreview,
    GYPhotoBrowserTypePreview
}GYPhotoBrowserType;

@interface GYPhotoBrowserController : UIViewController
@property (nonatomic, copy) GYSelectedBlock selectedBlock;
- (id)initWithPhotoBrowser:(GYPhotoBrowser *)browser type:(GYPhotoBrowserType)type index:(NSUInteger)index;
@end

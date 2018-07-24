//
//  GYPhotoAlbum.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/7.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>
#import "GYPhotoBrowser.h"

typedef void (^GYSelectedBlock)(GYPhotoBrowser *browser);

@interface GYPhotoAlbum : NSObject
+ (void)selectImagesWithRootController:(UIViewController *)controller
                            maxSelection:(NSInteger)maxSelection
                        currentBrowser:(nullable GYPhotoBrowser *)browser
                         selectedBlock:(GYSelectedBlock)block;
@end

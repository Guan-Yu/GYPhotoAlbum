//
//  GYImageUtil.h
//  GYImageBrowserDemo
//
//  Created by Guanyu Yan on 2018/7/24.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^GYPhotoAlbumAuthorizationBlock)(BOOL isSuccess);
typedef void (^GYSavePhotoFinishedBlock)(NSError *_Nullable error);

@interface GYImageUtil : NSObject
+ (void)saveImageToAlbum:(UIImage *)image albumName:(NSString *)albumName finishedBlock:(GYSavePhotoFinishedBlock)block;
+ (UIAlertController *)showAlertInController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message;
+ (void)requestAuthorization:(GYPhotoAlbumAuthorizationBlock)block;
+ (void)showAuthorizationAlertWithRootController:(nullable UIViewController *)controller;
@end

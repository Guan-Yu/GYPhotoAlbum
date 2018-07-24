//
//  GYPhotoAlbum.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/7.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYPhotoAlbum.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "GYPhotoAlbumController.h"
#import "GYAsset.h"
#import "GYImageUtil.h"
#import "GYPhotoAlbumNavigationController.h"
#import "GYMessageView.h"

@implementation GYPhotoAlbum

+ (void)selectImagesWithRootController:(UIViewController *)controller maxSelection:(NSInteger)maxSelection currentBrowser:(nullable GYPhotoBrowser *)browser selectedBlock:(GYSelectedBlock)block {
    [GYImageUtil requestAuthorization:^(BOOL isSuccess) {
        if (isSuccess) {
            [self gotoPhotoAlbumControllerWithRootController:controller maxSelection:maxSelection photoBrowser:browser selectedBlock:(GYSelectedBlock)block];
        } else {
            [GYImageUtil showAuthorizationAlertWithRootController:controller];
        }
    }];
}

+ (void)gotoPhotoAlbumControllerWithRootController:(UIViewController *)controller maxSelection:(NSInteger)maxSelection photoBrowser:(GYPhotoBrowser *)browser selectedBlock:(GYSelectedBlock)block{
    if (!browser) {
        browser = [GYPhotoBrowser browserWithMaxSelection:maxSelection];
    }
    if (!browser.assetCollections.count) {
        [GYMessageView displayMessage:@"你的相册是空的" style:GYMessageViewStyleErrorBlack];
        return;
    }
    GYPhotoAlbumController *albumController = [[GYPhotoAlbumController alloc] initWithPhotoBrowser:browser];
    albumController.selectedBlock = block;
    GYPhotoAlbumNavigationController *navgationController = [[GYPhotoAlbumNavigationController alloc] initWithRootViewController:albumController];
    [controller presentViewController:navgationController animated:YES completion:nil];
}

@end

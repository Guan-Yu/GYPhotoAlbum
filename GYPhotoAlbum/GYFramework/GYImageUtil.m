//
//  GYImageUtil.m
//  GYImageBrowserDemo
//
//  Created by Guanyu Yan on 2018/7/24.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYImageUtil.h"
#import <Photos/Photos.h>

@implementation GYImageUtil

#pragma mark - Public
+ (void)saveImageToAlbum:(UIImage *)image albumName:(NSString *)albumName finishedBlock:(GYSavePhotoFinishedBlock)block {
    [self requestAuthorization:^(BOOL isSuccess) {
        if (isSuccess) {
            NSString *collectionName = albumName;
            if (!collectionName) {
                NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
                collectionName = bundleInfo[@"CFBundleDisplayName"];
                if (!collectionName) {
                    collectionName = bundleInfo[@"CFBundleName"];
                }
            }
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCollectionChangeRequest *collectionChangeRequest = nil;
                PHAssetCollection *assetCollection = [self getAssetCollectionWithName:collectionName];
                if (assetCollection) {
                    collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                } else {
                    collectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
                }
                PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                PHObjectPlaceholder *placeholder = [assetChangeRequest placeholderForCreatedAsset];
                [collectionChangeRequest addAssets:@[placeholder]];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (block) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(error);
                    });
                }
            }];
        } else {
            [self showAuthorizationAlertWithRootController:nil];
        }
    }];
}

+ (UIAlertController *)showAlertInController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"立即前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_10_0
        [[UIApplication sharedApplication] openURL:url];
#else
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
#endif
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"暂不开启" style:UIAlertActionStyleCancel handler:nil]];
    if (!controller) {
        controller = [[UIApplication sharedApplication].delegate window].rootViewController;
    }
    [controller presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

+ (void)requestAuthorization:(GYPhotoAlbumAuthorizationBlock)block {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            bool isSuccess = status == PHAuthorizationStatusAuthorized;
            block(isSuccess);
        });
    }];
}

+ (void)showAuthorizationAlertWithRootController:(nullable UIViewController *)controller {
    [self showAlertInController:controller title:@"开启相册权限" message:@"需要开启相册权限才能进入，是否立即前往开启"];
}

#pragma mark - Private
+ (PHAssetCollection *)getAssetCollectionWithName:(NSString *)collectionName {
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in result) {
        if ([collection.localizedTitle containsString:collectionName]) {
            return collection;
        }
    }
    return nil;
}

@end

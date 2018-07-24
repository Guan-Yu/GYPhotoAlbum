//
//  GYAsset.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface GYAsset : NSObject
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *uploadableImage;
@property (nonatomic, strong) NSString *identifier;

+ (GYAsset *)assetWithPHAsset:(PHAsset *)asset;
+ (GYAsset *)assetWithUploadableImage:(UIImage *)image identifier:(NSString *)identifier;
- (UIImage *)getImageThumb;
- (void)getImageWithResultBlock:(void (^)(UIImage *image))resultBlock;

+ (NSArray *)getAssets;
+ (NSArray *)getAssetsFromAssetCollection:(PHAssetCollection *)collection;
+ (UIImage *)getImageThumbFromAssetCollection:(PHAssetCollection *)collection;
+ (UIImage *)getImageThumbFromAsset:(PHAsset *)asset;
+ (UIImage *)getImageFromAsset:(PHAsset *)asset maxDataSize:(double)size;
+ (NSArray *)getAssetsByFetchResult:(PHFetchResult *)result;
+ (void)getImageFromAsset:(PHAsset *)asset resultBlock:(void (^)(UIImage *image))resultBlock;
@end

//
//  GYAsset.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYAsset.h"

@implementation GYAsset

+ (GYAsset *)assetWithPHAsset:(PHAsset *)asset {
    GYAsset *gyAsset = [[GYAsset alloc] init];
    gyAsset.identifier = asset.localIdentifier;
    gyAsset.asset = asset;
    return gyAsset;
}

+ (GYAsset *)assetWithUploadableImage:(UIImage *)image identifier:(NSString *)identifier {
    GYAsset *asset = [[GYAsset alloc] init];
    asset.uploadableImage = image;
    asset.identifier = identifier;
    return asset;
}

- (UIImage *)uploadableImage {
    if (!_uploadableImage) {
        _uploadableImage =  [GYAsset getImageFromAsset:_asset maxDataSize:1000000];
    }
    return _uploadableImage;
}

- (UIImage *)getImageThumb {
    if (_asset) {
        return [GYAsset getImageThumbFromAsset:_asset];
    }
    return _uploadableImage;
}

- (void)getImageWithResultBlock:(void (^)(UIImage *))resultBlock {
    if (_asset) {
        return [GYAsset getImageFromAsset:_asset resultBlock:resultBlock];
    }
    resultBlock(_uploadableImage);
}

#pragma mark - Util
+ (PHFetchOptions *)createFetchOptions {
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:true]];
    return options;
}

+ (NSArray *)getAssets {
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:[self createFetchOptions]];
    return [self getAssetsByFetchResult:result];
}

+ (NSArray *)getAssetsFromAssetCollection:(PHAssetCollection *)collection {
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:[self createFetchOptions]];
    return [self getAssetsByFetchResult:result];
}

+ (UIImage *)getImageThumbFromAssetCollection:(PHAssetCollection *)collection {
    __block PHAsset *asset = nil;
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:[self createFetchOptions]];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        asset = obj;
        *stop = true;
    }];
    return [self getImageThumbFromAsset:asset];;
}

+ (UIImage *)getImageThumbFromAsset:(PHAsset *)asset {
    if (!asset) {
        return nil;
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = true;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize size = CGSizeMake(width, width);
    
    __block UIImage *image = nil;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        image = result;
    }];
    
    return image;
}

+ (UIImage *)getImageFromAsset:(PHAsset *)asset maxDataSize:(double)maxSize {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = true;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    CGFloat width = sqrt(maxSize);
    CGSize size = CGSizeMake(width, width);
    __block UIImage *image = nil;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            image = result;
        }
    }];
    return image;
}

+ (void )getImageFromAsset:(PHAsset *)asset resultBlock:(void (^)(UIImage *image))resultBlock {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = false;
    
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(result);
            });
        }
    }];
}

+ (NSArray *)getAssetsByFetchResult:(PHFetchResult *)result {
    NSMutableArray *assets = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = obj;
        [assets insertObject:[GYAsset assetWithPHAsset:asset] atIndex:0];
    }];
    return [assets copy];
}

@end

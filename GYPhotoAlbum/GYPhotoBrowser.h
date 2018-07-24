//
//  GYPhotoBrowser.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYAsset.h"
#import "GYAssetCollection.h"
#import <Photos/Photos.h>

@interface GYPhotoBrowser : NSObject
@property (nonatomic, copy, readonly) NSArray *assetCollections;
@property (nonatomic, copy, readonly) NSMutableArray *selectedAssets;
@property (nonatomic, strong, readonly) NSMutableArray *tempSelectedAssets;
@property (nonatomic, strong) GYAssetCollection *currentCollection;
@property (nonatomic, assign) NSInteger maxSelection;

+ (GYPhotoBrowser *)browser;
+ (GYPhotoBrowser *)browserWithMaxSelection:(NSInteger)max;
+ (GYPhotoBrowser *)browserWithSelectedAssets:(NSArray *)assets maxSelection:(NSInteger)max;

- (void)didFinishedSelection;
- (void)didCancelSelection;

- (BOOL)addSelectedAsset:(GYAsset *)asset;
- (BOOL)removeSelectedAsset:(GYAsset *)asset;
- (BOOL)getAssetSelected:(GYAsset *)asset;
@end

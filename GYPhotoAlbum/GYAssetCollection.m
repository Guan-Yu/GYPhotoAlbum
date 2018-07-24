//
//  GYAssetCollection.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/9.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYAssetCollection.h"

@implementation GYAssetCollection

+ (GYAssetCollection *)collectionWithPHAssetCollection:(PHAssetCollection *)collection {
    GYAssetCollection *gyCollection = [[GYAssetCollection alloc] init];
    gyCollection.collection = collection;
    return gyCollection;
}

- (void)setCollection:(PHAssetCollection *)collection {
    _collection = collection;
    
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:_collection options:nil];
    _assets = [GYAsset getAssetsByFetchResult:result];
    self.index = 0;
    _title = collection.localizedTitle;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    if (_assets.count >= index+1 && index >= 0) {
        _currentAsset = _assets[index];
    }
}

+ (NSArray *)getAssetCollectionsWithCollectionType:(GYAssetCollectionType)collectionType {
    NSMutableArray *collections = [NSMutableArray array];
    PHFetchResult<PHAssetCollection *> *result1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    [collections addObjectsFromArray:[self getAssetCollectionsWithFetchResult:result1 collectionType:collectionType]];
    
    PHFetchResult<PHAssetCollection *> *result2 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    [collections addObjectsFromArray:[self getAssetCollectionsWithFetchResult:result2 collectionType:collectionType]];
    for (NSInteger i=0; i<collections.count; i++) {
        GYAssetCollection *collection = collections[i];
        if (collection.collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary && i!=0) {
            [collections exchangeObjectAtIndex:0 withObjectAtIndex:i];
            break;
        }
    }
    return [collections copy];
}

+ (NSArray *)getAssetCollectionsWithFetchResult:(PHFetchResult *)result collectionType:(GYAssetCollectionType)collectionType {
    NSMutableArray *collections = [NSMutableArray array];
    for (NSInteger i=0; i<result.count; i++) {
        PHAssetCollection *collection = result[i];
        bool isAdd = collectionType & GYAssetCollectionAny;
        isAdd = (collectionType & GYAssetCollectionTypePhoto && collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumVideos) || isAdd;
        isAdd = (collectionType & GYAssetCollectionTypeVideo && collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumVideos) || isAdd;
        if (isAdd) {
            GYAssetCollection *gyCollection = [GYAssetCollection collectionWithPHAssetCollection:collection];
            if (gyCollection.assets.count > 0) {
                [collections addObject:gyCollection];
            }
        }
    }
    return collections;
}
@end

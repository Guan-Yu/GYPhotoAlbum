//
//  GYAssetCollection.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/9.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "GYAsset.h"

typedef NS_OPTIONS(NSUInteger, GYAssetCollectionType){
    GYAssetCollectionAny = 1 << 1,
    
    GYAssetCollectionTypePhoto = 1 << 2,
    GYAssetCollectionTypeVideo = 1 << 3
};

@interface GYAssetCollection : NSObject
@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, strong, readonly) NSArray *assets;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) GYAsset *currentAsset;

+ (GYAssetCollection *)collectionWithPHAssetCollection:(PHAssetCollection *)collection;
+ (NSArray *)getAssetCollectionsWithCollectionType:(GYAssetCollectionType)collectionType;
@end

//
//  GYPhotoBrowser.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYPhotoBrowser.h"
#import "GYMessageView.h"

@implementation GYPhotoBrowser

+ (GYPhotoBrowser *)browser {
    GYPhotoBrowser *browser = [[self alloc] init];
    return browser;
}

+ (GYPhotoBrowser *)browserWithMaxSelection:(NSInteger)max {
    GYPhotoBrowser *browser = [self browser];
    browser.maxSelection = max;
    return browser;
}

+ (GYPhotoBrowser *)browserWithSelectedAssets:(NSArray *)assets maxSelection:(NSInteger)max{
    GYPhotoBrowser *browser = [self browserWithMaxSelection:max];
    [browser.tempSelectedAssets addObjectsFromArray:assets];
    [browser didFinishedSelection];
    return browser;
}

- (instancetype)init {
    if (self = [super init]) {
        _tempSelectedAssets = [NSMutableArray array];
        _selectedAssets = [NSMutableArray array];
        
        _assetCollections = [GYAssetCollection getAssetCollectionsWithCollectionType: GYAssetCollectionTypePhoto];
        
        if (_assetCollections.count > 0) {
            self.currentCollection = _assetCollections[0];
        }
    }
    return self;
}

- (void)didFinishedSelection {
    _selectedAssets = [_tempSelectedAssets mutableCopy];
}

- (void)didCancelSelection {
    _tempSelectedAssets = [_selectedAssets mutableCopy];
}

- (BOOL)getAssetSelected:(GYAsset *)asset {
    for (GYAsset *anAsset in _tempSelectedAssets) {
        if ([anAsset.identifier isEqualToString:asset.identifier]) {
            return true;
        }
    }
    return false;
}

- (BOOL)addSelectedAsset:(GYAsset *)asset {
    if (_tempSelectedAssets.count >= _maxSelection) {
        NSString *msg = [NSString stringWithFormat:@"最多可选择%lu张图片",_maxSelection];
        [GYMessageView displayMessage:msg style:GYMessageViewStyleErrorBlack];
        return false;
    }
    [_tempSelectedAssets addObject:asset];
    return true;
}

- (BOOL)removeSelectedAsset:(GYAsset *)asset {
    for (GYAsset *anAsset in _tempSelectedAssets) {
        if ([anAsset.identifier isEqualToString:asset.identifier]) {
            [_tempSelectedAssets removeObject:anAsset];
            return true;
        }
    }
    return false;
}

@end

//
//  GYCollectionListView.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/9.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPhotoBrowser.h"
#import <Photos/Photos.h>
#import "GYAssetCollection.h"

@class GYCollectionListView;
@protocol GYCollectionListViewDelegate <NSObject>
- (void)collectionListView:(GYCollectionListView *)view selectedAssetCollection:(GYAssetCollection *)collection;
@end

@interface GYCollectionListView : UIView
@property (nonatomic, strong) GYPhotoBrowser *browser;
@property (nonatomic, weak) IBOutlet id<GYCollectionListViewDelegate>delegate;
- (void)show;
- (void)hide;
@end

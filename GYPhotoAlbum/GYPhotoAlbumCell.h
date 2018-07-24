//
//  GYPhotoAlbumCell.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAsset.h"

static NSString *const GYPhotoAlbumCell_ID = @"GYPhotoAlbumCell";

@class GYPhotoAlbumCell;
@protocol GYPhotoAlbumCellDelegate <NSObject>
- (BOOL)photoAlbumCell:(GYPhotoAlbumCell *)cell selectedAsset:(GYAsset *)asset;
- (BOOL)photoAlbumCell:(GYPhotoAlbumCell *)cell deselectedAsset:(GYAsset *)asset;
- (BOOL)getSelectedWithPhotoAlbumCell:(GYPhotoAlbumCell *)cell;
@end

@interface GYPhotoAlbumCell : UICollectionViewCell
@property (nonatomic, strong) GYAsset *asset;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, weak) id<GYPhotoAlbumCellDelegate> delegate;
@end

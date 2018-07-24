//
//  GYPhotoBrowserCell.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAsset.h"

static NSString *const GYPhotoBrowserCell_ID = @"GYPhotoBrowserCell";

@interface GYPhotoBrowserCell : UICollectionViewCell
@property (nonatomic, strong) GYAsset *asset;
@end

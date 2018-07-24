//
//  GYCollectionCell.h
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/9.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAssetCollection.h"

static NSString *const GYCollectionCell_ID = @"GYCollectionCell";

@interface GYCollectionCell : UITableViewCell
@property (nonatomic, strong) GYAssetCollection *collection;
@end

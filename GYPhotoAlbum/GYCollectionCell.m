//
//  GYCollectionCell.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/9.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYCollectionCell.h"
#import "GYAsset.h"

@interface GYCollectionCell() {
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIImageView *_imageView;
}
@end

@implementation GYCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.layer.cornerRadius = 5;
}

- (void)setCollection:(GYAssetCollection *)collection {
    _collection = collection;
    
    _imageView.image = [GYAsset getImageThumbFromAssetCollection:collection.collection];
    
    NSString *count = [NSString stringWithFormat:@"(%lu)",collection.assets.count];
    NSString *string = [NSString stringWithFormat:@"%@%@",collection.title, count];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor grayColor];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:string];
    [title setAttributes:attributes range:NSMakeRange(collection.title.length, count.length)];
    _titleLabel.attributedText = title;
}

@end

//
//  GYPhotoAlbumCell.m
//  GYPhotoAlbum
//
//  Created by Guanyu Yan on 2018/5/8.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "GYPhotoAlbumCell.h"
#import "GYAsset.h"

@interface GYPhotoAlbumCell() {
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UIButton *_selectBtn;
    NSBlockOperation *_operation;
    UIImage *_placeholder;
}
@end
static NSOperationQueue *_queue;
@implementation GYPhotoAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 10;
    });
    _placeholder = [UIImage imageNamed:@"image_place_holder"];
}

- (void)dealloc {
    [_operation cancel];
}

- (void)setAsset:(GYAsset *)asset {
    _asset = asset;
    
    _imageView.image = _placeholder;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_operation cancel];
    __weak GYPhotoAlbumCell *weakSelf = self;
    _operation = [NSBlockOperation blockOperationWithBlock:^{
        GYAsset *loadAsset = asset;
        UIImage *image = [loadAsset getImageThumb];
        __strong GYPhotoAlbumCell *strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf setImageWithAsset:loadAsset image:image];
        });
    }];
    [_queue addOperation:_operation];
    
    if ([_delegate respondsToSelector:@selector(getSelectedWithPhotoAlbumCell:)]) {
        _selectBtn.selected = [_delegate getSelectedWithPhotoAlbumCell:self];
    }
}

- (void)setImageWithAsset:(GYAsset *)asset image:(UIImage *)image{
    if (asset == _asset) {
        _imageView.image = image;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (IBAction)onSelectBtn:(id)sender {
    if (!_selectBtn.selected && [_delegate respondsToSelector:@selector(photoAlbumCell:selectedAsset:)]) {
        [_delegate photoAlbumCell:self selectedAsset:_asset];
    } else if (_selectBtn.selected && [_delegate respondsToSelector:@selector(photoAlbumCell:deselectedAsset:)]) {
        [_delegate photoAlbumCell:self deselectedAsset:_asset];
    }
    if ([_delegate respondsToSelector:@selector(getSelectedWithPhotoAlbumCell:)]) {
        _selectBtn.selected = [_delegate getSelectedWithPhotoAlbumCell:self];
    }
}

- (UIImage *)image {
    return _imageView.image;
}

@end


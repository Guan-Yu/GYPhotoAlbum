//
//  ViewController.m
//  GYPhotoAlbumDemo
//
//  Created by Guanyu Yan on 2018/7/23.
//  Copyright © 2018年 Guanyu Yan. All rights reserved.
//

#import "ViewController.h"
#import "GYPhotoAlbum.h"
#import "GYMultiSelectedPhotoView.h"

@interface ViewController () {
    __weak IBOutlet GYMultiSelectedPhotoView *_multiSelectPhotoView;
    
    __weak IBOutlet UIImageView *_imgView;
    __weak IBOutlet UIImageView *_imgView2;
}
@property (nonatomic, strong) GYPhotoBrowser *browser;
@end

@implementation ViewController

//布局在main.storyboard

- (IBAction)onSelect:(id)sender {
    [GYPhotoAlbum selectImagesWithRootController:self maxSelection:2 currentBrowser:_browser selectedBlock:^(GYPhotoBrowser *browser) {
        self.browser = browser;
        
        if (browser.selectedAssets.count) {
            GYAsset *asset = browser.selectedAssets[0];
            self->_imgView.image = asset.uploadableImage;//asset中有获取各种尺寸图片的方式，这个压缩后可以上传的图片
        } else {
            self->_imgView.image = nil;
        }
        
        if (browser.selectedAssets.count > 1) {
            GYAsset *asset = browser.selectedAssets[1];
            self->_imgView2.image = asset.uploadableImage;
        } else {
            self->_imgView2.image = nil;
        }
    }];
}

@end

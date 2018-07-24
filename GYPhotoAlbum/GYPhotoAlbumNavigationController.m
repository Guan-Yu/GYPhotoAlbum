//
//  GYPhotoAlbumNavigationController.m
//  GHCLishi
//
//  Created by Guanyu Yan on 2018/5/25.
//  Copyright © 2018年 lis99. All rights reserved.
//

#import "GYPhotoAlbumNavigationController.h"

@interface GYPhotoAlbumNavigationController ()

@end

@implementation GYPhotoAlbumNavigationController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.enabled = false;
    self.navigationBar.hidden = true;
}
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.visibleViewController;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end

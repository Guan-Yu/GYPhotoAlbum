//
//  MessageView.h
//  ComicPhoto
//
//  Created by 闫冠宇 on 14-4-18.
//  Copyright (c) 2014年 YanGuanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GYMessageViewStyleErrorWidth,
    GYMessageViewStyleErrorBlack,
    GYMessageViewStyleCorrectWidth,
    GYMessageViewStyleCorrectBlack
}GYMessageViewStyle;

@interface GYMessageView : UIView
+ (void)init;
+ (void)displayMessage:(NSString *)message style:(GYMessageViewStyle)style;
@end

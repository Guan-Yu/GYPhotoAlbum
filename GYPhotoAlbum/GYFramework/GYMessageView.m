//
//  MessageView.m
//  ComicPhoto
//
//  Created by 闫冠宇 on 14-4-18.
//  Copyright (c) 2014年 YanGuanyu. All rights reserved.
//

#import "GYMessageView.h"

@interface GYMessageView()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

static GYMessageView *_messageView = nil;

@implementation GYMessageView

+ (void)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIWindow *mainWindow = [[UIApplication sharedApplication].delegate window];
        _messageView = [[[NSBundle mainBundle] loadNibNamed:@"GYMessageView" owner:nil options:nil] objectAtIndex:0];
        _messageView.center = CGPointMake(mainWindow.frame.size.width/2, mainWindow.frame.size.height/2);
        _messageView.layer.cornerRadius = 10;
        _messageView.clipsToBounds = true;
        _messageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        _messageView.alpha = 0;
        _messageView.hidden = YES;
        [mainWindow addSubview:_messageView];
    });
}

+ (void)displayMessage:(NSString *)message style:(GYMessageViewStyle)style {
    [GYMessageView init];
    
    [_messageView.superview bringSubviewToFront:_messageView];
    _messageView.label.text = message;
    [_messageView setStyle:style];
    
    if (_messageView.hidden) {
        _messageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        _messageView.alpha = 0;
        _messageView.hidden = NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            _messageView.alpha = 1;
            _messageView.transform = CGAffineTransformIdentity;
        }];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [(NSObject *)self performSelector:@selector(hide) withObject:nil afterDelay:2];
}

+ (void)hide{
    [UIView animateWithDuration:0.2 animations:^{
        _messageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        _messageView.alpha = 0;
    }completion:^(BOOL finished) {
        if (finished) {
            _messageView.hidden = YES;
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setStyle:(GYMessageViewStyle)style {
    switch (style) {
        case GYMessageViewStyleErrorBlack:
            self.backgroundColor = [UIColor blackColor];
            self.alpha = .8;
            _label.textColor = [UIColor whiteColor];
            _imgView.highlighted = YES;
            break;
            
        case GYMessageViewStyleErrorWidth:
            self.backgroundColor = [UIColor whiteColor];
            self.alpha = .9;
            _label.textColor = [UIColor darkGrayColor];
            _imgView.highlighted = YES;
            break;
            
            case GYMessageViewStyleCorrectWidth:
            self.backgroundColor = [UIColor whiteColor];
            self.alpha = .9;
            _label.textColor = [UIColor darkGrayColor];
            _imgView.highlighted = NO;
            break;
            
        case GYMessageViewStyleCorrectBlack:
            self.backgroundColor = [UIColor blackColor];
            self.alpha = .8;
            _label.textColor = [UIColor whiteColor];
            _imgView.highlighted = NO;
            break;
            
            
        default:
            break;
    }
    
}

#pragma mark - keyboard
- (CGRect)getKeyboardRectFromNotification:(NSNotification *)notication {
    NSValue *aValue = [notication.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    return keyboardRect;
}

- (NSTimeInterval)getKeyboardAnimationDurationFromNotification:(NSNotification *)notication {
    NSValue *animationDurationValue = [notication.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    return animationDuration;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardRect = [self getKeyboardRectFromNotification:notification];
    NSTimeInterval duration = [self getKeyboardAnimationDurationFromNotification:notification];
    
    CGSize supreSize = [UIScreen mainScreen].bounds.size;
    supreSize = CGSizeMake(supreSize.width, supreSize.height - keyboardRect.size.height);
    [UIView animateWithDuration:duration animations:^{
        _messageView.center = CGPointMake(supreSize.width/2, supreSize.height/2);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSTimeInterval duration = [self getKeyboardAnimationDurationFromNotification:notification];
    
    CGSize supreSize = [UIScreen mainScreen].bounds.size;
    [UIView animateWithDuration:duration animations:^{
        _messageView.center = CGPointMake(supreSize.width/2, supreSize.height/2);
    }];
}

@end

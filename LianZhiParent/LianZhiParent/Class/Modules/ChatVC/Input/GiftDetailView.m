//
//  GiftDetailView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "GiftDetailView.h"

@implementation GiftDetailView

+ (void)showWithImage:(NSString *)imageUrl title:(NSString *)title {
    GiftDetailView *giftView = [[GiftDetailView alloc] initWithFrame:CGRectZero withCompletion:nil valid:NO];
    [giftView.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [giftView.label setText:title];
    [giftView show];
}
+ (void)showWithImage:(NSString *)imageUrl title:(NSString *)title receiveCompletion:(void (^)())completion valid:(BOOL)valid
{
    GiftDetailView *giftView = [[GiftDetailView alloc] initWithFrame:CGRectZero withCompletion:completion valid:valid];
    [giftView.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [giftView.label setText:title];
    [giftView show];
}

- (instancetype)initWithFrame:(CGRect)frame withCompletion:(void (^)())completion valid:(BOOL)valid;
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        self.completion = completion;
        NSInteger actionHeight = completion ? 50 : 0;
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        [_bgView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [self addSubview:_bgView];
        
        NSInteger contentWidth = self.width - 20 * 2;
        NSInteger contentHeight = contentWidth + actionHeight;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(20, (self.height - contentHeight) / 2, contentWidth, contentHeight)];
        [_contentView.layer setBorderWidth:4];
        [_contentView.layer setCornerRadius:15];
        [_contentView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [_contentView.layer setMasksToBounds:YES];
        [_contentView setBackgroundColor:[UIColor colorWithRed:249 / 255.f green:198 / 255.f blue:49 / 255.f alpha:1.f]];
        [self addSubview:_contentView];
        
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, _contentView.width - 30 * 2, _contentView.height - 30 - 60 - actionHeight)];
        [_borderView.layer setBorderColor:[UIColor orangeColor].CGColor];
        [_borderView.layer setBorderWidth:3];
        [_borderView.layer setCornerRadius:10];
        [_borderView.layer setMasksToBounds:YES];
        [_contentView addSubview:_borderView];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectInset(_borderView.bounds, 20, 20)];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_borderView addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _borderView.bottom, _contentView.width, 60)];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setNumberOfLines:0];
        [_label setFont:[UIFont boldSystemFontOfSize:18]];
        [_label setTextColor:[UIColor whiteColor]];
        [_contentView addSubview:_label];
        
        if(completion) {
            _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_actionButton setFrame:CGRectMake((_contentView.width - 120) / 2, _label.bottom, 120, 30)];
            [_actionButton addTarget:self action:@selector(onActionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [_actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor] size:_actionButton.size cornerRadius:15] forState:UIControlStateNormal];
            [_actionButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:_actionButton.size cornerRadius:15] forState:UIControlStateDisabled];
            [_actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_actionButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [_actionButton setTitle:@"爱心领取" forState:UIControlStateNormal];
            [_contentView addSubview:_actionButton];
            
            [_actionButton setEnabled:valid];
        }
    }
    return self;
}

- (void)onActionButtonClicked {
    if(self.completion) {
        self.completion();
    }
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if(!CGRectContainsPoint(_contentView.frame, location)) {
        [self dismiss];
    }
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self setAlpha:0.f];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

@end

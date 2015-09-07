//
//  TNAlertView.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNAlertView.h"

#define kAlertViewWidth             240
#define kAlertViewHeight            120
#define kButtonHeight               35

@interface TNAlertView()

@end

@implementation TNAlertView

- (instancetype)initWithTitle:(NSString *)title buttonItems:(NSArray *)items
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake((self.width - kAlertViewWidth) / 2, (self.height - kAlertViewHeight) / 2, kAlertViewWidth, kAlertViewHeight)];
        [_bgView setBackgroundColor:kCommonParentTintColor];
        [_bgView.layer setCornerRadius:15];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_titleLabel setText:title];
        [_bgView addSubview:_titleLabel];
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(kAlertViewWidth - 30 * 2, 0) andFont:_titleLabel.font];
        [_titleLabel setFrame:CGRectMake((_bgView.width - size.width) / 2, (kAlertViewHeight - kButtonHeight - size.height) / 2, size.width, size.height)];
        
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, kAlertViewHeight - kButtonHeight, kAlertViewWidth, kButtonHeight)];
        [_buttonView setBackgroundColor:[UIColor whiteColor]];
        [_bgView addSubview:_buttonView];
        
        CGFloat buttonWidth = kAlertViewWidth / items.count;
        for (NSInteger i = 0; i < items.count; i++)
        {
            TNButtonItem *item = [items objectAtIndex:i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(buttonWidth * i, 0, buttonWidth, kButtonHeight)];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(10, 10)] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:CGSizeMake(10, 10)] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:item.title forState:UIControlStateNormal];
            [button setActionItem:item];
            [_buttonView addSubview:button];
            
            if(i >= 1)
            {
                UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth * i, 0, 0.5, kButtonHeight)];
                [sepLine setBackgroundColor:kCommonParentTintColor];
                [_buttonView addSubview:sepLine];
            }
        }
        
        _bgView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    }
    return self;
}

- (void)onButtonClicked:(id)sender
{
    [self close];
    UIButton *button = (UIButton *)sender;
    TNButtonItem *item = [button actionItem];
    if(item.action)
    {
        item.action();
    }
}

- (void)show
{
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    _bgView.layer.opacity = 0.f;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        _bgView.layer.opacity = 1.0f;
        _bgView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)close
{
    CATransform3D currentTransform = _bgView.layer.transform;
    
    CGFloat startRotation = [[_bgView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
    
    _bgView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    _bgView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         _bgView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         _bgView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}


@end

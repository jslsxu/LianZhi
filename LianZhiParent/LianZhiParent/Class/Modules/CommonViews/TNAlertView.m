//
//  TNAlertView.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNAlertView.h"

#define kAlertViewWidth             ([UIScreen mainScreen].bounds.size.width) * 3 / 4
#define kButtonHeight               35
#define kButtonHMargin              15
#define kAlertViewVMargin           15

@interface TNAlertView()

@end

@implementation TNAlertView

- (instancetype)initWithTitle:(NSString *)title buttonItems:(NSArray *)items
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"WhiteBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setUserInteractionEnabled:YES];
        [self addSubview:_bgImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_titleLabel setTextColor:kWarningTextColor];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_titleLabel setText:title];
        [_bgImageView addSubview:_titleLabel];
        
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(kAlertViewWidth - kButtonHMargin * 2, 0) andFont:_titleLabel.font];
        CGFloat height = kAlertViewVMargin * 3 + size.height + kButtonHeight;
        [_bgImageView setFrame:CGRectMake((self.width - kAlertViewWidth) / 2, (self.height - height) / 2, kAlertViewWidth, height)];
        [_titleLabel setFrame:CGRectMake((_bgImageView.width - size.width) / 2, kAlertViewVMargin, size.width, size.height)];
        
        CGFloat buttonWidth = (kAlertViewWidth - kButtonHMargin * (1 + items.count)) / items.count;
        CGFloat spaceXStart = kButtonHMargin;
        for (NSInteger i = 0; i < items.count; i++) {
            TNButtonItem *item = [items objectAtIndex:i];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[[UIImage imageNamed:@"GreenBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [button setTitle:item.title forState:UIControlStateNormal];
            [button setActionItem:item];
            [button setFrame:CGRectMake(spaceXStart, _titleLabel.bottom + kAlertViewVMargin, buttonWidth, kButtonHeight)];
            [_bgImageView addSubview:button];
            spaceXStart += buttonWidth + kButtonHMargin;
        }
        
        _bgImageView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
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
    _bgImageView.layer.opacity = 0.f;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        _bgImageView.layer.opacity = 1.0f;
        _bgImageView.layer.transform = CATransform3DMakeScale(1, 1, 1);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)close
{
    CATransform3D currentTransform = _bgImageView.layer.transform;
    
    CGFloat startRotation = [[_bgImageView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
    
    _bgImageView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    _bgImageView.layer.opacity = 1.0f;
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         _bgImageView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         _bgImageView.layer.opacity = 0.0f;
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

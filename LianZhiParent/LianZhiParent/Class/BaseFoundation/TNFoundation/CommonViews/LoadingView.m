//
//  LoaingView.m
//  app
//
//  Created by jslsxu on 14/12/7.
//  Copyright (c) 2014年 Related Code. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        [self.layer setCornerRadius:self.width / 2];
        [self setBackgroundColor:[UIColor colorWithRed:143 / 255.0 green:143 / 255.0 blue:143 / 255.0 alpha:1.f]];
        [self.layer setMasksToBounds:YES];
        
        _animationLayer = [CALayer layer];
        [_animationLayer setContents:(id)[UIImage imageNamed:@"LoadingArrow.png"].CGImage];
        [_animationLayer setFrame:CGRectMake((self.width - 32) / 2, (self.height - 32) / 2 - 10, 32, 32)];
        
        [self.layer addSublayer:_animationLayer];
        
        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.height - 30, self.width - 10 * 2, 20)];
        [_loadingLabel setText:@"加载中..."];
        [_loadingLabel setTextColor:[UIColor whiteColor]];
        [_loadingLabel setFont:[UIFont systemFontOfSize:12]];
        [_loadingLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_loadingLabel];
    }
    return self;
}

- (void)startAnimating
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSIntegerMax;
    [_animationLayer addAnimation:rotationAnimation forKey:@"rotation"];
    [self setHidden:NO];
}

- (void)stopAnimating
{
    [_animationLayer removeAllAnimations];
    [self setHidden:YES];
}

@end

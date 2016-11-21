//
//  LZGradientProcessView.m
//  LZGradientProcessView
//
//  Created by chen qi on 16/10/10.
//  Copyright © 2016年 SJWY. All rights reserved.
//

#import "LZGradientProcessView.h"
#import "UIView+Extensions.h"
#import "ResourceDefine.h"

static const CGFloat kProcessHeight = 10.f;


@interface LZGradientProcessView ()

@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, assign) CGFloat numberPercent;

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSArray *colorLocationArray;

@end

@implementation LZGradientProcessView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //初始化数据
        self.backgroundColor = [UIColor clearColor];
        self.colorArray = @[(id)[JXColor(0x7E,0xAD,0xF7,1) CGColor],
                            (id)[JXColor(0x61,0xCD,0xEC,1) CGColor]];
        self.colorLocationArray = @[@0.1, @0.3, @0.5, @0.7, @1];

        self.numberPercent = 0;
        
        // 添加视图层
        [self getGradientLayer];
        
    }
    return self;
}



- (void)getGradientLayer { // 进度条设置渐变色
    
    // 灰色进度条背景
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = CGRectMake(0, 0, self.width, kProcessHeight);
    bgLayer.backgroundColor = JXColor(0xE3,0xE4,0xE8,1).CGColor;
    bgLayer.masksToBounds = YES;
    bgLayer.cornerRadius = kProcessHeight / 2;
    [self.layer addSublayer:bgLayer];
    
    self.maskLayer = [CALayer layer];
    self.maskLayer.frame = CGRectMake(0, 0, self.width, kProcessHeight);
    self.maskLayer.borderWidth = self.height / 2;
    
    // 添加渐变层
    self.gradientLayer =  [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, 0, self.width, kProcessHeight);
    self.gradientLayer.masksToBounds = YES;
    self.gradientLayer.cornerRadius = kProcessHeight / 2;
    [self.gradientLayer setColors:self.colorArray];
    [self.gradientLayer setLocations:self.colorLocationArray];
    [self.gradientLayer setStartPoint:CGPointMake(0, 0)];
    [self.gradientLayer setEndPoint:CGPointMake(1, 0)];
    [self.gradientLayer setMask:self.maskLayer];
    [self.layer addSublayer:self.gradientLayer];
}

// 设置数值
- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    
    [self setAnimation];
}


// 进度条动画
- (void)setAnimation {
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [CATransaction setAnimationDuration:1.0f];
    self.maskLayer.frame = CGRectMake(0, 0, self.width  * _percent / 100.f , kProcessHeight);
    [CATransaction commit];
}

@end

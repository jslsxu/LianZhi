//
//  WWBadgeLabel.m
//  WengWeng5
//
//  Created by HanFeng on 19/05/14.
//  Copyright (c) 2014 mafengwo. All rights reserved.
//

#import "LZBadgeLabel.h"
#import <objc/runtime.h>

@interface BadgeLabel ()

@property (nonatomic, strong) NSLayoutConstraint *top_margin;
@property (nonatomic, strong) NSLayoutConstraint *right_margin;

@end

@implementation BadgeLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:13];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithHexValue:0xff3d29 alpha:1];
    }
    return self;
}

- (CGSize) intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    return CGSizeMake(MAX(s.width + 10, 18), 18);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.height/2;
    self.layer.masksToBounds = YES;
}

@end

@interface RedDot ()

@property (nonatomic, strong) NSLayoutConstraint *top_margin;
@property (nonatomic, strong) NSLayoutConstraint *right_margin;

@end

@implementation RedDot

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexValue:0xff3d29 alpha:1];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.height/2;
    self.layer.masksToBounds = YES;
}

@end


@implementation UIView (BadgeLabel)

static void *__badgeLabel__ = nil;

- (BadgeLabel *)badgeLabel
{
    BadgeLabel *badge = objc_getAssociatedObject(self, &__badgeLabel__);
    if (badge == nil) {
        badge = [[BadgeLabel alloc] initWithFrame:(CGRect){0,0,40,20}];
        objc_setAssociatedObject(self, &__badgeLabel__, badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:badge];
        badge.autoresizingMask = 0;
        badge.translatesAutoresizingMaskIntoConstraints = NO;
        
        badge.top_margin = [NSLayoutConstraint constraintWithItem:badge attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        badge.right_margin = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:badge attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self addConstraints:@[badge.top_margin, badge.right_margin]];
    }
    return badge;
}

static void *__new_dot__ = nil;

- (RedDot *)newDotTip
{
    return [self newDotTipWithWidth:8];
}

- (RedDot *)newDotTipWithWidth:(CGFloat)width
{
    RedDot *dot = objc_getAssociatedObject(self, &__new_dot__);
    if (dot == nil) {
        dot = [[RedDot alloc] initWithFrame:(CGRect){0,0,6,6}];
        objc_setAssociatedObject(self, &__new_dot__, dot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:dot];
        dot.autoresizingMask = 0;
        dot.translatesAutoresizingMaskIntoConstraints = NO;
        
        dot.top_margin = [NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        dot.right_margin = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:dot attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self addConstraints:@[dot.top_margin, dot.right_margin]];
        
        NSLayoutConstraint *widthCons = [NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
        NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:dot attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
        [dot addConstraints:@[widthCons, heightCons]];
    }
    return dot;
}

@end
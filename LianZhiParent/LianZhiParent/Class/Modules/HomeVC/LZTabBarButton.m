//
//  LZTabBarButton.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "LZTabBarButton.h"

@implementation LZTabBarButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.titleLabel.text.length > 0)
    {
        self.imageView.contentMode = UIViewContentModeCenter;
        
        
        // lower the text and push it left so it appears centered
        //  below the image
        CGSize imageSize = self.imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + self.spacing), 0.0);
        
        // raise the image and push it right so it appears centered
        //  above the text
        CGSize titleSize = self.titleLabel.frame.size;
        self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + self.spacing), 0.0, 0.0, - titleSize.width);
    } else {
        self.titleEdgeInsets = UIEdgeInsetsZero;
        self.imageEdgeInsets = UIEdgeInsetsZero;
    }
    
    if(_numIndicator == nil)
    {
        _numIndicator = [[NumIndicator alloc] init];
        [self addSubview:_numIndicator];
    }
    [self setBadgeValue:self.badgeValue];
}

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    if(_badgeValue)
        [_numIndicator setHidden:NO];
    else
        [_numIndicator setHidden:YES];
    [_numIndicator setIndicator:_badgeValue];
    [_numIndicator setCenter:CGPointMake(self.width / 2 + 15, _numIndicator.height / 2 + 5)];
}

- (void)setSpacing:(CGFloat)spacing
{
    _spacing = spacing;
    [self setNeedsLayout];
}
@end

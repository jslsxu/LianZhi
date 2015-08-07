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
    
    if (self.titleLabel.text.length > 0) {
        self.titleLabel.font = [UIFont systemFontOfSize:self.presenting ? 13 : 11];
        self.imageView.contentMode = UIViewContentModeCenter;
        
        CGFloat spacing = self.presenting ? 6.0 : 4.0;
        
        // lower the text and push it left so it appears centered
        //  below the image
        CGSize imageSize = self.imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
        
        // raise the image and push it right so it appears centered
        //  above the text
        CGSize titleSize = self.titleLabel.frame.size;
        self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    } else {
        self.titleEdgeInsets = UIEdgeInsetsZero;
        self.imageEdgeInsets = UIEdgeInsetsZero;
    }
    
    if(_redDot == nil)
    {
        _redDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"RedDot.png")]];
        [self addSubview:_redDot];
         [_redDot setHidden:YES];
    }
    [_redDot setCenter:CGPointMake(self.width - 20, 5)];
}

- (void)setHasNew:(BOOL)hasNew
{
    _hasNew = hasNew;
    [_redDot setHidden:!_hasNew];
}
@end

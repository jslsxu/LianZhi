//
//  CircleProgressView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "CircleProgressView.h"

@implementation CircleProgressView

- (instancetype)initWithRadius:(CGFloat)radius{
    self = [super initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    if(self){
        [self.layer setCornerRadius:radius];
        [self.layer setBorderWidth:1];
        [self.layer setBorderColor:[UIColor colorWithHexString:@"FBBD33"].CGColor];
        [self.layer setMasksToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setFProgress:(CGFloat)fProgress{
    _fProgress = fProgress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGPoint center = CGPointMake(self.width / 2, self.height / 2);
    CGFloat radius = self.width / 2 - 1;
    CGFloat startAngle = - (M_PI / 2);
    CGFloat endAngle = M_PI * 2 * self.fProgress + startAngle;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor colorWithHexString:@"FBBD33"] set];
    
    CGContextSetLineWidth(ctx, 3);
    CGContextAddArc(ctx, center.x, center.y, radius, startAngle, endAngle, NO);
    CGContextStrokePath(ctx);
    
}

@end

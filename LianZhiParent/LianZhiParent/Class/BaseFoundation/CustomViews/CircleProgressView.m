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
        [self.layer setBorderWidth:2];
        [self.layer setBorderColor:[UIColor blueColor].CGColor];
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
    CGFloat radius = self.width / 2 - 2;
    CGFloat startAngle = - (M_PI / 2);
    CGFloat endAngle = M_PI * 2 * 0.4 + startAngle;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blueColor] set];
    
    CGContextSetLineWidth(ctx, 4);
    CGContextAddArc(ctx, center.x, center.y, radius, startAngle, endAngle, NO);
    CGContextStrokePath(ctx);
    
}

@end

//
//  CameraMaskView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/13.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "CameraMaskView.h"
#import <QuartzCore/QuartzCore.h>
@implementation CameraMaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self addMaskLayer];
    CGContextRef currentContext =
    UIGraphicsGetCurrentContext();
    //创建路径并获取句柄
    CGMutablePathRef path = CGPathCreateMutable();
    //指定矩形
    CGRect rectangle = _noMaskRect;
    //将矩形添加到路径中
    CGPathAddRect(path,NULL,
                  rectangle);
    //获取上下文
    //将路径添加到上下文
    CGContextAddPath(currentContext, path);
    //设置矩形填充色
    [[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.0f]
     setFill];
    //矩形边框颜色
    [[UIColor whiteColor] setStroke];
    CGFloat width = 0.5;
    if ([UIScreen mainScreen].scale == 1)
    {
        width = 1;
    }
    //边框宽度
    CGContextSetLineWidth(currentContext,width);
    //绘制
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGPathRelease(path);
    
    
}


-(void)addMaskLayer
{
    // Create a mask layer and the frame to determine what will be visible in the view.
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGRect noMaskmaskRect = _noMaskRect;
    
    CGRect maskLeft = CGRectMake(0, 0, CGRectGetMinX(noMaskmaskRect), CGRectGetHeight(self.frame));
    CGFloat maskRightwidth = CGRectGetWidth(self.bounds) - CGRectGetMaxX(noMaskmaskRect);
    CGRect maskRight = CGRectMake(CGRectGetMaxX(noMaskmaskRect), 0, maskRightwidth, CGRectGetHeight(self.frame));
    CGRect maskTop = CGRectMake(CGRectGetWidth(maskLeft), 0, CGRectGetWidth(noMaskmaskRect), CGRectGetMinY(noMaskmaskRect));
    CGRect maskBottom = CGRectMake(CGRectGetWidth(maskLeft), CGRectGetMaxY(noMaskmaskRect), CGRectGetWidth(noMaskmaskRect), CGRectGetHeight(self.bounds)-CGRectGetMaxY(noMaskmaskRect));
    // Create a path and add the rectangle in it.
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rects[] ={maskLeft,maskTop,maskBottom,maskRight};
    CGPathAddRects(path, nil, rects, sizeof(rects)/sizeof(rects[0]));
    // Set the path to the mask layer.
    [maskLayer setPath:path];
    // Release the path since it's not covered by ARC.
    CGPathRelease(path);
    // Set the mask of the view.
    self.layer.mask = maskLayer;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
    
}

@end

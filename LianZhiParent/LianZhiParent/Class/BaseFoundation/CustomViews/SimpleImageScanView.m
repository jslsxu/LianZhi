//
//  SimpleImageScanView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/4.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "SimpleImageScanView.h"

@interface SimpleImageScanView()
@property (nonatomic, assign)CGRect targetFrame;
@property (nonatomic, strong)UIImage *sourceImage;

@end

@implementation SimpleImageScanView

- (instancetype)initWithSourceImage:(UIImage *)sourceImage
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.sourceImage = sourceImage;
        _sourceImageView = [[UIImageView alloc] initWithImage:self.sourceImage];
        [_sourceImageView setClipsToBounds:YES];
        [self addSubview:_sourceImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)showFromTargetFrame:(CGRect)targetFrame
{
    self.targetFrame = targetFrame;
    CGRect imageFrame = [self imageFrame];
    UIView *viewParent = [UIApplication sharedApplication].keyWindow;
    [_sourceImageView setFrame:self.targetFrame];
    [_sourceImageView setAlpha:0.f];
    [viewParent addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
        [_sourceImageView setFrame:imageFrame];
        [_sourceImageView setAlpha:1.f];
    }];
}

- (CGRect)imageFrame
{
    if(self.sourceImage == nil)
        return self.bounds;
    CGRect targetRect;
    CGSize imageSize = self.sourceImage.size;
    CGFloat width, height;
    if(imageSize.width / imageSize.height < self.width / self.height)
    {
        height = self.height;
        width = imageSize.width * self.height / imageSize.height;
    }
    else
    {
        width = self.width;
        height = imageSize.height * self.width / imageSize.width;
    }
    targetRect = CGRectMake((self.width - width) / 2, (self.height - height) / 2, width, height);
    return targetRect;
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        [_sourceImageView setFrame:self.targetFrame];
        [_sourceImageView setAlpha:0.f];
        [self setBackgroundColor:[UIColor clearColor]];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)onTap
{
    [self dismiss];
}

@end

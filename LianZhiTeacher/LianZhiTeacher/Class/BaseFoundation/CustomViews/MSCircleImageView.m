//
//  MSCircleImageView.m
//  menswear
//
//  Created by jslsxu on 14-9-14.
//  Copyright (c) 2014年 menswear. All rights reserved.
//

#import "MSCircleImageView.h"

@implementation MSCircleImageView

- (instancetype)initWithRadius:(CGFloat)radius
{
    self = [self initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    if(self)
    {
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, MIN(frame.size.width, frame.size.height), MIN(frame.size.width, frame.size.height))];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder
{
    
//#warning TODO 头像需要修改
    self.image = placeHolder;
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(error == nil && finished &&image)
            self.image = image;
    }];
}

- (void)setImageWithUrl:(NSURL *)url
{
    [self setImage:nil];
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(error == nil && finished &&image)
            self.image = image;
    }];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat lineWidth = self.borderWidth;
    UIColor *lineColor = self.borderColor;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, lineWidth, lineWidth)
                                                      cornerRadius:self.height/2 - lineWidth];
    
    CGContextSaveGState(context);
    
    if (!self.disableClip) {
        [circle addClip];
    }
    
    if (self.image) {
        CGRect f = self.bounds;
        CGSize imageSize = self.image.size;
        if (imageSize.width > imageSize.height) {
            CGFloat iw = f.size.height * imageSize.width/imageSize.height;
            [self.image drawInRect:(CGRect){floorf((f.size.width-iw)/2), 0, iw, f.size.height}];
        } else {
            CGFloat ih = f.size.width * imageSize.height/imageSize.width;
            [self.image drawInRect:(CGRect){0, floorf((f.size.height-ih)/2), f.size.width, ih}];
        }
    }
    
    CGContextRestoreGState(context);
    
    if (!self.disableClip && lineWidth > 0 && lineColor != [UIColor clearColor]) {
        CGContextSetShouldAntialias(context, YES);
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetInterpolationQuality(context, kCGInterpolationMedium);
        
        
        circle = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, lineWidth/2, lineWidth/2)
                                            cornerRadius:self.height/2 - lineWidth/2];
        circle.lineWidth = lineWidth;
        [lineColor set];
        [circle stroke];
    }
}


@end



@implementation AvatarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setContentMode:UIViewContentModeScaleAspectFill];
        [self setImage:[UIImage imageNamed:(@"NoAvatarDefault")]];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 13, self.width, 13)];
        [_statusLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [_statusLabel setTextColor:[UIColor whiteColor]];
        [_statusLabel setFont:[UIFont systemFontOfSize:8]];
        [_statusLabel setTextAlignment:NSTextAlignmentCenter];
        [_statusLabel setHidden:YES];
        [self addSubview:_statusLabel];
    }
    return self;
}

- (void)setStatus:(NSString *)status
{
    _status = status;
    if(_status.length == 0)
    {
        [_statusLabel setHidden:YES];
        
    }
    else
    {
        [self.layer setCornerRadius:self.width / 2];
        [self.layer setMasksToBounds:YES];
        [_statusLabel setText:_status];
        [_statusLabel setHidden:NO];
    }
}

- (void)setImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder
{
    
    //#warning TODO 头像需要修改
    self.image = placeHolder;
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(error == nil && finished &&image)
            self.image = image;
    }];
}

- (void)setImageWithUrl:(NSURL *)url
{
    [self setImage:[UIImage imageNamed:(@"NoAvatarDefault.png")]];
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(error == nil && finished &&image)
            self.image = image;
    }];
}
@end


@implementation LogoView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setImage:[UIImage imageNamed:(@"NoLogoDefault.png")]];
    }
    return self;
}

- (void)setImageWithUrl:(NSURL *)url placeHolder:(UIImage *)placeHolder
{
    
    //#warning TODO 头像需要修改
    self.image = placeHolder;
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(error == nil && finished &&image)
            self.image = image;
    }];
}

- (void)setImageWithUrl:(NSURL *)url
{
    [self setImage:[UIImage imageNamed:(@"NoLogoDefault.png")]];
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(error == nil && finished &&image)
            self.image = image;
    }];
}
@end

//
//  MSCircleImageView.m
//  menswear
//
//  Created by jslsxu on 14-9-14.
//  Copyright (c) 2014年 menswear. All rights reserved.
//

#import "MSCircleImageView.h"

@implementation AvatarView
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
        [self setUserInteractionEnabled:YES];
        CGFloat radius = MIN(frame.size.width, frame.size.height) / 2;
        [self.layer setCornerRadius:radius];
        [self.layer setMasksToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
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

- (void)sd_setImageWithURL:(NSURL *)url{
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:(@"NoAvatarDefault")]];
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

- (void)sd_setImageWithURL:(NSURL *)url{
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:(@"NoLogoDefault.png")]];
}

@end

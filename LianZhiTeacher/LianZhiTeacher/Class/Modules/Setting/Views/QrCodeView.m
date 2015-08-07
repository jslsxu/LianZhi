//
//  QrCodeView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/4/28.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "QrCodeView.h"

#define kContentViewWith        240
#define kContentViewHeight      360

@implementation QrCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_coverButton setFrame:self.bounds];
        [_coverButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
        [_coverButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_coverButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 240) / 2, (self.height - 360) / 2, kContentViewWith, kContentViewHeight)];
        [_contentView.layer setBorderColor:[UIColor colorWithHexString:@"D8D8D8"].CGColor];
        [_contentView.layer setBorderWidth:0.5];
        [_contentView.layer setCornerRadius:2];
        [_contentView.layer setMasksToBounds:YES];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentView];
        
        UserInfo *userInfo = [UserCenter sharedInstance].userInfo;
        
        AvatarView *avatar = [[AvatarView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
        [avatar setImageWithUrl:[NSURL URLWithString:userInfo.avatar]];
        [_contentView addSubview:avatar];
        
        UILabel*    nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatar.right + 5, avatar.top + 5, 0, 0)];
        [nickLabel setTextColor:[UIColor darkGrayColor]];
        [nickLabel setFont:[UIFont systemFontOfSize:14]];
        [nickLabel setText:userInfo.name];
        [nickLabel sizeToFit];
        [nickLabel setY:avatar.centerY - nickLabel.height];
        [_contentView addSubview:nickLabel];
        
        UILabel*    idLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatar.right + 5, avatar.centerY + 2, 0, 0)];
        [idLabel setTextColor:[UIColor lightGrayColor]];
        [idLabel setFont:[UIFont systemFontOfSize:14]];
        [idLabel setText:userInfo.uid];
        [idLabel sizeToFit];
        [_contentView addSubview:idLabel];
        
        CGFloat width = _contentView.width - 30 * 2;
        UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(30, avatar.bottom + 15, width, width)];
        [borderView.layer setBorderColor:[UIColor colorWithHexString:@"D8D8D8"].CGColor];
        [borderView.layer setBorderWidth:2];
        [_contentView addSubview:borderView];
        
        NSString *url = [NSString stringWithFormat:@"https://www.baidu.com"];
        UIImage *avatarImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:userInfo.avatar];
        UIImageView *qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        [qrImageView setImage:[QRCodeGenerator qrImageForString:url imageSize:width Topimg:avatarImage]];
        [borderView addSubview:qrImageView];
        
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(borderView.x, borderView.bottom + 10, borderView.width, 20)];
        [commentLabel setTextColor:[UIColor grayColor]];
        [commentLabel setFont:[UIFont systemFontOfSize:13]];
        [commentLabel setTextAlignment:NSTextAlignmentCenter];
        [commentLabel setText:@"扫一扫二维码，添加我为好友"];
        [_contentView addSubview:commentLabel];
        
    }
    return self;
}


- (void)showInView:(UIView *)viewParent
{
    [viewParent addSubview:self];
    self.alpha = 0.f;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

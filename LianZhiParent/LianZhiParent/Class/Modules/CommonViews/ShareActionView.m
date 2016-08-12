//
//  ShareActionView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ShareActionView.h"
#define kShareViewWidth             270
#define kShareViewHeight            240
@interface ShareActionView ()
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, copy)NSString *imageUrl;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *url;
@end

@implementation ShareActionView

+ (void)shareWithTitle:(NSString *)title
               content:(NSString *)content
                 image:(UIImage *)image
              imageUrl:(NSString *)imageUrl
                   url:(NSString *)url
{
    ShareActionView *shareView = [[ShareActionView alloc] init];
    shareView.title = title;
    shareView.content = content;
    shareView.image = image;
    shareView.imageUrl = imageUrl;
    shareView.url = url;
    [shareView show];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self)
    {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgButton setFrame:self.bounds];
        [_bgButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        [self addSubview:_bgButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, kScreenWidth, kShareViewHeight)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentView];
        
        NSInteger innerMargin = 10;
        NSInteger vMargin = 20;
        NSInteger hMargin = 20;
        NSInteger itemWith = (_contentView.width - hMargin * 2 - innerMargin * 3) / 4;
        NSInteger itemHeight = 80;
        
        _shareArray = [NSMutableArray array];
        NSArray *titleArray = @[@"微信",@"朋友圈",@"QQ空间",@"QQ",@"微博",@"复制链接"];
        NSArray *imageArray = @[@"ShareSession",@"ShareTimeline",@"ShareQQSpace",@"ShareQQ",@"ShareSina",@"ShareCopy"];
        
        for (NSInteger i = 0; i < 6; i++)
        {
            NSInteger column = i % 4;
            NSInteger row = i / 4;
            LZTabBarButton *tabButton = [[LZTabBarButton alloc] initWithFrame:CGRectMake(hMargin + (itemWith + innerMargin) * column, vMargin + (itemHeight) * row, itemWith, itemHeight)];
            [tabButton addTarget:self action:@selector(onActionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [tabButton setTitleColor:[UIColor colorWithHexString:@"2c2c2c"] forState:UIControlStateNormal];
            [tabButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [tabButton setTitle:titleArray[i] forState:UIControlStateNormal];
            [tabButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [tabButton setSpacing:4];
            [_contentView addSubview:tabButton];
            
            [_shareArray addObject:tabButton];
        }
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setFrame:CGRectMake(hMargin, _contentView.height - 15 - 36, _contentView.width - hMargin * 2, 36)];
        [cancelButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:cancelButton.size cornerRadius:4] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"转身离去" forState:UIControlStateNormal];
        [_contentView addSubview:cancelButton];
    }
    return self;
}

- (void)onActionButtonClicked:(LZTabBarButton *)button
{
    NSInteger index = [_shareArray indexOfObject:button];
    NSArray *typeArray = @[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeCopy)];
    SSDKPlatformType shareType = (SSDKPlatformType)[typeArray[index] integerValue];
    if(shareType != SSDKPlatformTypeCopy)
    {
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageUrl];
        if(!image)
            image = self.image;
        [[SVShareManager sharedInstance] shareWithType:shareType image:image imageUrl:self.imageUrl title:self.title content:self.content url:self.url result:^(SSDKPlatformType type, SSDKResponseState state, NSString *errorMsg) {
            if(SSDKResponseStateSuccess == state)
            {
                [ProgressHUD showSuccess:@"分享成功"];
                [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/share" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                    
                } fail:^(NSString *errMsg) {
                    
                }];
            }
            else if(errorMsg.length > 0)
                [ProgressHUD showHintText:errorMsg];
        }];
    }
    else
    {
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = self.url;
        [ProgressHUD showHintText:@"已复制到剪切板"];
    }
    [self dismiss];
}

- (void)show
{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    [_contentView setY:keywindow.height];
    _bgButton.alpha = 0.f;
    [keywindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.y = keywindow.height - _contentView.height;
        _bgButton.alpha = 1.f;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.y = kScreenHeight;
        _bgButton.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

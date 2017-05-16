//
//  ShareActionView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ShareActionView.h"
#import "OpenShareHeader.h"
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
        [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
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
        [cancelButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:cancelButton.size cornerRadius:4] forState:UIControlStateNormal];
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
    if(index == 5){
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = self.url;
        [ProgressHUD showHintText:@"已复制到剪切板"];
    }
    else{
        void (^success)() = ^(){
            [ProgressHUD showSuccess:@"分享成功"];
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/share" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                
            } fail:^(NSString *errMsg) {
                
            }];
        };
        void (^fail)() = ^(){
            [ProgressHUD showHintText:@"分享失败"];
        };
        OSMessage *message = [OSMessage new];
        message.title = self.title;
        message.desc = self.content;
        if([message.desc length] == 0){
            message.desc = message.title;
        }
        message.link = self.url;
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.imageUrl];
        if(image){
            image = [image resize:CGSizeMake(160, 160)];
        }
        else{
            image = [UIImage imageNamed:@"AppLogo"];
        }
        message.image = image;
        message.multimediaType = OSMultimediaTypeNews;
        if(index == 0){
            [OpenShare shareToWeixinSession:message Success:^(OSMessage *message) {
                success();
            } Fail:^(OSMessage *message, NSError *error) {
                fail();
            }];
        }
        else if(index == 1){
            [OpenShare shareToWeixinTimeline:message Success:^(OSMessage *message) {
                success();
            } Fail:^(OSMessage *message, NSError *error) {
                fail();
            }];
        }
        else if(index == 2){
            [OpenShare shareToQQZone:message Success:^(OSMessage *message) {
                success();
            } Fail:^(OSMessage *message, NSError *error) {
                fail();
            }];
        }
        else if(index == 3){
            [OpenShare shareToQQFriends:message Success:^(OSMessage *message) {
                success();
            } Fail:^(OSMessage *message, NSError *error) {
                fail();
            }];
        }
        else if(index == 4){
            [OpenShare shareToWeibo:message Success:^(OSMessage *message) {
                success();
            } Fail:^(OSMessage *message, NSError *error) {
                fail();
            }];
        }
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

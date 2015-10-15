//
//  ShareActionView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ShareActionView.h"

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
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(25, (self.height - 220) / 2, self.width - 25 * 2, 220)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:10];
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
        
        NSInteger innerMargin = 10;
        NSInteger vMargin = 20;
        NSInteger hMargin = 20;
        NSInteger itemWith = (_contentView.width - hMargin * 2 - innerMargin * 3) / 4;
        NSInteger itemHeight = 70;
        
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
            [tabButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [tabButton setTitle:titleArray[i] forState:UIControlStateNormal];
            [tabButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [tabButton setSpacing:4];
            [_contentView addSubview:tabButton];
            
            [_shareArray addObject:tabButton];
        }
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setFrame:CGRectMake(hMargin, _contentView.height - vMargin - 36, _contentView.width - hMargin * 2, 36)];
        [cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"E82557"] size:cancelButton.size cornerRadius:18] forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_contentView addSubview:cancelButton];
    }
    return self;
}

- (void)onActionButtonClicked:(LZTabBarButton *)button
{
    NSInteger index = [_shareArray indexOfObject:button];
    NSArray *typeArray = @[@(ShareTypeWeixiSession),@(ShareTypeWeixiTimeline),@(ShareTypeQQSpace),@(ShareTypeQQ),@(ShareTypeSinaWeibo), @(ShareTypeCopy)];
    ShareType shareType = (ShareType)[typeArray[index] integerValue];
    if(shareType != ShareTypeCopy)
    {
        [[SVShare sharedInstance] shareWithType:shareType text:self.content image:self.image imageUrl:self.imageUrl url:self.url title:self.title result:^(ShareType type, SVShareResultState state, NSString *errorMsg) {
            if(SVShareResultStateSuccess == state)
            {
                [ProgressHUD showHintText:@"分享成功"];
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
    self.alpha = 0.f;
    [keywindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.f;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

//
//  ContactView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/8/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ContactView.h"

@interface ContactView ()
@property (nonatomic, strong)UserInfo *userInfo;
@end

@implementation ContactView

- (instancetype)initWithUserInfo:(UserInfo *)userInfo{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    if(self){
        [self setBackgroundColor:[UIColor whiteColor]];
        self.userInfo = userInfo;
        UIImage *bgImage  = [[UIImage imageWithColor:kCommonTeacherTintColor size:CGSizeMake(10, 10) cornerRadius:5] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        NSMutableArray *buttonArray = [NSMutableArray array];
        if(userInfo.mobile.length > 0){
            UIButton *mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [mobileButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [mobileButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [mobileButton setTitle:@"打电话" forState:UIControlStateNormal];
            [mobileButton addTarget:self action:@selector(callMobile) forControlEvents:UIControlEventTouchUpInside];
            [mobileButton setBackgroundImage:bgImage forState:UIControlStateNormal];
            [self addSubview:mobileButton];
            [buttonArray addObject:mobileButton];
        }
        
//        if(userInfo.actived){
            UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [chatButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [chatButton setTitle:@"发消息" forState:UIControlStateNormal];
            [chatButton addTarget:self action:@selector(chat) forControlEvents:UIControlEventTouchUpInside];
            [chatButton setBackgroundImage:bgImage forState:UIControlStateNormal];
            [self addSubview:chatButton];
            [buttonArray addObject:chatButton];
//        }
        NSInteger hMargin = 10;
        NSInteger vMargin = 15;
        NSInteger itemWidth = (self.width - hMargin * (buttonArray.count + 1)) / buttonArray.count;
        for (NSInteger i = 0; i < buttonArray.count; i++) {
            UIButton *button = buttonArray[i];
            [button setFrame:CGRectMake(hMargin + (hMargin + itemWidth) * i, vMargin, itemWidth, (self.height - vMargin * 2))];
        }
        
    }
    return self;
}

- (void)callMobile{
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定拨打电话%@吗",self.userInfo.mobile] style:LGAlertViewStyleAlert buttonTitles:@[@"取消", @"拨打电话"] cancelButtonTitle:nil destructiveButtonTitle:nil];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        if(index == 1){
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",self.userInfo.mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)chat{
    if(self.chatCallback){
        self.chatCallback();
    }
}

@end

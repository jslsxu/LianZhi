//
//  NotificationSendTargetView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/6/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetItemView : UIView
{
    UIButton*   _cancelButton;
    UILabel*    _nameLabel;
}
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, copy)void (^removeBlk)();
- (instancetype)initWithUserInfo:(UserInfo *)userInfo;
@end

@interface NotificationSendTargetView : UIView
{
    UIScrollView*   _scrollView;
    NSMutableArray* _memberArray;
}
@property (nonatomic, strong)NSArray *sendArray;
@end

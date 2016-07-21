//
//  NotificationSendSmsView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/19.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationSendChoiceView : UIView
{
    UIButton*       _stateButton;
    UILabel*        _titleLabel;
    UILabel*        _infoLabel;
}
@property (nonatomic, assign)BOOL isOn;
@property (nonatomic, copy)NSString *infoStr;
@property (nonatomic, copy)void (^infoAction)();
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
@end

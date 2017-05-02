//
//  NotificationScopeVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/29.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface NotificationScopeCell : TNTableViewCell
@property (nonatomic, strong)UILabel* titleLabel;
@property (nonatomic, strong)UILabel* detailLabel;
- (void)setTitle:(NSString *)title detail:(NSString *)detail;
@end

@interface NotificationScopeVC : TNBaseViewController

@end

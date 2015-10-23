//
//  NotificationClassStudentsVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface NotificationStudentCell : TNTableViewCell
{
    AvatarView* _avatarView;
    UILabel*    _nameLabel;
    UILabel*    _infoLabel;
    UIButton*   _checkButton;
}
@property (nonatomic, assign)BOOL checked;
@end

@interface NotificationClassStudentsVC : TNBaseViewController
{
    UITableView*    _tableView;
}
@property (nonatomic, strong)NSArray *originalArray;
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, copy)void (^selectedCompletion)(NSArray *studentArray);
@end

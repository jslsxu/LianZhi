//
//  NotificationClassStudentsVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/11.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "NotificationToAllVC.h"
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
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSData *audioData;
@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, strong)ClassInfo *classInfo;
@end

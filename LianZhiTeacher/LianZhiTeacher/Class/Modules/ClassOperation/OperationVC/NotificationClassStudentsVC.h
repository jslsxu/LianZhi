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

@interface StudentsModel : TNListModel

@end

@interface NotificationClassStudentsVC : TNBaseTableViewController
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, copy)void (^selectedCompletion)(NSArray *studentArray);
@end

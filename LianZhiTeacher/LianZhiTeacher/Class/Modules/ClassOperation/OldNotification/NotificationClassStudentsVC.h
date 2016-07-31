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

@interface NotificationClassStudentsVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*    _tableView;
}
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSData *audioData;
@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, strong)ClassInfo *classInfo;

@property (nonatomic, strong)NSMutableArray *seletedArray;
@property (nonatomic, strong)NSMutableArray *students;
@end

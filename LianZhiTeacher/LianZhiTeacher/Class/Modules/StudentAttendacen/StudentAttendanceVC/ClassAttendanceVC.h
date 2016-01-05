//
//  ClassAttendanceVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ClassAttendanceCell : UITableViewCell
{
    LogoView*    _logoView;
    UILabel*        _nameLabel;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@end

@interface ClassAttendanceVC : TNBaseViewController
{
    UITableView*    _tableView;
}
@property (nonatomic, copy)NSString *classID;
@end

//
//  ClassAttendanceVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ClassAttendanceCell : TNTableViewCell
{
    LogoView*    _logoView;
    UILabel*        _nameLabel;
    UIView*     _sepLine;
}
@end

@interface ClassLeftItem : TNModelItem
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, copy)NSString *className;
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, assign)NSInteger leftNum;

@end

@interface ClassLeftModel : TNListModel

@end

@interface ClassAttendanceVC : TNBaseTableViewController
{
    
}
@property (nonatomic, copy)NSString *classID;
@end

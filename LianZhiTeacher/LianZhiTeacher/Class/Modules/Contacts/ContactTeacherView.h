//
//  ContactTeacherView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/3.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
@interface ContactListHeaderView : UITableViewHeaderFooterView
{
    UILabel*    _titleLabel;
}
@property (nonatomic, copy)NSString *title;
@end
@interface ContactTeacherView : UIView
{
    UITableView*        _tableView;
}
@property (nonatomic, strong)NSArray*   teachers;
@end

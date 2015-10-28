//
//  StudentParentsVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "ContactModel.h"
@interface StudentParentCell : TNTableViewCell
{
    AvatarView* _avatar;
    UILabel*    _nameLabel;
//    UIButton*   _chatButton;
    UIView*     _sepLine;
}
@property (nonatomic, strong)FamilyInfo *familyInfo;
@end

@interface StudentParentsVC : TNBaseViewController
{
    UITableView*    _tableView;
}
@property (nonatomic, strong)StudentInfo *studentInfo;
@end

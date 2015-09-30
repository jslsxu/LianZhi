//
//  StudentParentsVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ContactGroup : NSObject
@property (nonatomic, copy)NSString *key;
@property (nonatomic, strong)NSMutableArray *contacts;

@end

@interface StudentParentCell : TNTableViewCell
{
    UIButton*   _chatButton;
    UIView*     _sepLine;
}

@end

@interface StudentParentsVC : TNBaseViewController
{
    UITableView*    _tableView;
}
@property (nonatomic, strong)ChildInfo *childInfo;
@end

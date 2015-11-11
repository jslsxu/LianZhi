//
//  ClassSelectionVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ClassSelectionVC : TNBaseViewController
{
    UITableView*    _tableView;
}
@property (nonatomic, assign)BOOL showNew;
@property (nonatomic, copy)NSString *originalClassID;
@property (nonatomic, copy)void (^selection)(ClassInfo *classInfo);
@end

//
//  ClassSelectionVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ClassSelectionCell : TNTableViewCell
{
    LogoView*   _logoView;
    UILabel*    _nameLabel;
    UIView*     _sepLine;
    NumIndicator*   _indicator;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, copy)NSString *badge;
@end

@interface ClassSelectionVC : TNBaseViewController
{
    UITableView*    _tableView;
}
@property (nonatomic, assign)BOOL showNew;
@property (nonatomic, strong)NSDictionary *classInfoDic;
@property (nonatomic, copy)NSString *originalClassID;
@property (nonatomic, copy)void (^selection)(ClassInfo *classInfo);
@end

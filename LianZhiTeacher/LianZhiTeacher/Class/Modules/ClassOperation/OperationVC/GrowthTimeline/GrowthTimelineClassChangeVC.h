//
//  GrowthTimelineClassChangeVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface GrowthClassCell : UITableViewCell
{
    LogoView*   _logoView;
    UILabel*    _nameLabel;
    
}
@property (nonatomic, strong)ClassInfo *classInfo;
@end

@interface GrowthTimelineClassChangeVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView*    _tableView;
}
@property (nonatomic, copy)void (^completion)(ClassInfo *classInfo);
@end

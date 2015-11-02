//
//  DiscoveryVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
@interface DiscoveryCell : TNTableViewCell
{
    UIView*    _redDot;
}
@property (nonatomic, readonly)UIView *redDot;
@end

@interface DiscoveryVC : TNBaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*    _tableView;
}
- (BOOL)hasNew;
@end
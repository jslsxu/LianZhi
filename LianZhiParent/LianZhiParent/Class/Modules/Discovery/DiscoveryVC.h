//
//  DiscoveryVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "InterestVC.h"

@interface DiscoveryCell : UITableViewCell
{
    UIImageView*    _redDot;
}
@property (nonatomic, readonly)UIImageView *redDot;
@end

@interface DiscoveryVC : TNBaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*    _tableView;
}

@end

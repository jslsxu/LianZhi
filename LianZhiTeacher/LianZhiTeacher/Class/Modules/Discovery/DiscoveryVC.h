//
//  DiscoveryVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface DiscoveryItem : TNModelItem
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *icon;
@property (nonatomic, copy)NSString *url;
@end

@interface DiscoveryCell : UITableViewCell
{
    UIImageView*    _icon;
    UILabel*        _titleLabel;
    UIView*         _redDot;
}
@property (nonatomic, readonly)UIView *redDot;
@property (nonatomic, strong)DiscoveryItem *discoveryItem;
@end

@interface DiscoveryVC : TNBaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView*    _tableView;
}
- (BOOL)hasNew;
@end
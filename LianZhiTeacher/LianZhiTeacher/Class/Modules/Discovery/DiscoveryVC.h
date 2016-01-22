//
//  DiscoveryVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

typedef NS_ENUM(NSInteger, DicoveryType)
{
    DicoveryTypeH5 = 0,
    DicoveryTypeLianZhi = 1,            //连枝剧场
    DicoveryTypepersonalSettings = 2,   //个人设置
    DicoveryTypeInterest = 3,           //兴趣
    DicoveryTypeFAQ = 4,                //常见问题
    DicoveryTypeAround = 5,             //身边事
};

@interface DiscoveryItem : TNModelItem
@property (nonatomic, assign)DicoveryType type;
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
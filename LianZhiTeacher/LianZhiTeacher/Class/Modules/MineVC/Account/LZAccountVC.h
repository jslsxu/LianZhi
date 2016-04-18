//
//  LZAccountVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface AccounInfoCell : TNTableViewCell
{
    UILabel*    _titleLabel;
    UILabel*    _timeLabel;
    UILabel*    _numLabel;
    UIView*     _sepLine;
}
@end

@interface AccountInfoItem : TNModelItem
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *ctime;
@property (nonatomic, assign)NSInteger num;
@end

@interface AccountInfoListModel : TNListModel
@property (nonatomic, assign)BOOL more;
@property (nonatomic, copy)NSString *maxID;
@property (nonatomic, assign)NSInteger coinTotal;
@property (nonatomic, copy)NSString *earnUrl;
@property (nonatomic, copy)NSString *exchangeUrl;
@end

@interface LZAccountVC : TNBaseTableViewController
{
    UILabel*    _numLabel;
    UIView*     _headerView;
}
@end

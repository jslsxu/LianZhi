//
//  ExchangeSchoolVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "MessageGroupListModel.h"
#import "PreviewMessageVC.h"
@interface SchoolInfoCell : TNTableViewCell
{
    LogoView*       _logoView;
    UILabel*        _nameLabel;
    UIView*         _redDot;
    UILabel*        _statusLabel;
    UIImageView*    _arrowImage;
    UIView*         _sepLine;
}
@property (nonatomic, strong)SchoolInfo *schoolInfo;
@property (nonatomic, assign)BOOL isCurSchool;
@property (nonatomic, assign)BOOL hasNew;
@end

@interface ExchangeSchoolVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* _messages;
    NSMutableDictionary*    _indicatorDic;
    UITableView*    _tableView;
}
@end

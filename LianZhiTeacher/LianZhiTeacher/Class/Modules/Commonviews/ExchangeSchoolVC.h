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
@interface SchoolInfoCell : UITableViewCell
{
    UIImageView*    _bgImageView;
    LogoView*       _logoView;
    UILabel*        _nameLabel;
    UIImageView*    _arrowImage;
}
@property (nonatomic, strong)SchoolInfo *schoolInfo;
@end

@interface SchoolMessageCell : UITableViewCell
{
    UIImageView*    _bgImageView;
    LogoView*       _logoView;
    UILabel*        _nameLabel;
    UILabel*        _messageLabel;
    UILabel*        _timeLabel;
}
@property (nonatomic, strong)MessageGroupItem *messageGroup;
@end

@interface ExchangeSchoolVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* _messages;
    NSMutableArray* _schools;
    UITableView*    _tableView;
    UIView*         _curSchoolView;
}
@end

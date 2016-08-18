//
//  MessageVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "MessageGroupItemCell.h"
#import "ClassZoneVC.h"
#import "MessageSegView.h"
@interface SwitchSchoolButton : UIButton
{
    NumIndicator*   _redDot;
}
@property (nonatomic, assign)BOOL hasNew;

@end

@interface MessageVC : UITableViewController
{
    SwitchSchoolButton *        _switchButton;
    MessageSegView*             _segView;
    UILabel*                    _emptyLabel;
    UIButton*                   _noticeButton;
    BOOL                        _isLoading;
}
@property (nonatomic, strong)MessageGroupListModel *messageModel;
- (void)refreshData;
- (void)invalidate;
@end

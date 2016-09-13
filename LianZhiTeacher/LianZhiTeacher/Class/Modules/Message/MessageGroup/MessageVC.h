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
#import "SwitchSchoolButton.h"
#import "EmptyHintView.h"
@interface MessageVC : UITableViewController
{
    EmptyHintView*              _notificationHintView;
    EmptyHintView*              _chatMessageHintView;
    MessageSegView*             _segView;
    UIButton*                   _noticeButton;
    BOOL                        _isLoading;
}
@property (nonatomic, strong)MessageGroupListModel *messageModel;
- (void)refreshData;
- (void)invalidate;
- (void)showIMVC;
@end

//
//  MessageVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "MessageGroupItemCell.h"
#import "TreeHouseVC.h"
#import "MessageSegView.h"
@interface MessageVC : DAContextMenuTableViewController
{
    EmptyHintView*              _notificationHintView;
    EmptyHintView*              _chatMessageHintView;
    BOOL                        _isLoading;
}
@property (nonatomic, strong)MessageGroupListModel *messageModel;
- (NSInteger)newMessageNum;
- (void)refreshData;
- (void)invalidate;
- (void)showIMVC;
@end

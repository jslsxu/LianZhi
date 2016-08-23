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
@interface MessageVC : UITableViewController
{
    MessageSegView*             _segView;
    UIButton*                   _noticeButton;
    BOOL                        _isLoading;
}
@property (nonatomic, strong)MessageGroupListModel *messageModel;
- (void)refreshData;
- (void)invalidate;
@end

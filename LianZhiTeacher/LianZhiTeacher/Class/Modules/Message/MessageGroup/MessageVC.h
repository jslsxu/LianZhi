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
@interface MessageVC : DAContextMenuTableViewController<EGORefreshTableHeaderDelegate>
{
    UILabel*                    _emptyLabel;
    UIButton*                   _noticeButton;
    BOOL                        _isLoading;
    EGORefreshTableHeaderView*  _refreshHeaderView;
    TNGetMoreCell*              _getMoreCell;
}
@property (nonatomic, strong)MessageGroupListModel *messageModel;
- (void)refreshData;
@end

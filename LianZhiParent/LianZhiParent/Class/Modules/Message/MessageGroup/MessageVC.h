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
@interface MessageVC : DAContextMenuTableViewController<EGORefreshTableHeaderDelegate>
{
    UILabel*                    _emptyLabel;
    BOOL                        _isLoading;
    EGORefreshTableHeaderView*  _refreshHeaderView;
    TNGetMoreCell*              _getMoreCell;
}
@property (nonatomic, strong)MessageGroupListModel *messageModel;
- (NSInteger)newMessageNum;
- (void)refreshData;
@end

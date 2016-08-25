//
//  TNBaseTableViewController.h
//  TNFoundation
//
//  Created by jslsxu on 14-9-6.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"
#import "TNGetMoreCell.h"
#import "TNTableViewCell.h"
#import "TNListModel.h"
#import "TNBaseViewController.h"

@interface TNBaseTableViewController : TNBaseViewController<EGORefreshTableHeaderDelegate,UITableViewDelegate,UITableViewDataSource,TNBaseTableViewData>
{
    UITableView*                _tableView;
    EGORefreshTableHeaderView*  _refreshHeaderView;
    BOOL                        _isLoading;
    TNListModel*                _tableViewModel;
}
@property (nonatomic, readonly)UITableView* tableView;
@property (nonatomic, readonly)TNListModel *tableViewModel;
@property (nonatomic, readonly)EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign)BOOL supportPullDown;
@property (nonatomic, assign)BOOL supportPullUp;
- (UITableViewStyle)tableViewStyle;
- (void)bindTableCell:(NSString *)cellName tableModel:(NSString *)modelName;
- (void)loadCache;
- (void)requestData:(REQUEST_TYPE)requestType;
- (void)cancelRequest;
- (BOOL)hideErrorAlert;
- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType;
@end

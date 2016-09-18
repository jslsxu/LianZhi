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

@interface TNBaseTableViewController : TNBaseViewController<UITableViewDelegate,UITableViewDataSource,TNBaseTableViewData>
{
    UITableView*                _tableView;
    TNListModel*                _tableViewModel;
}
@property (nonatomic, assign)BOOL isLoading;
@property (nonatomic, readonly)UITableView* tableView;
@property (nonatomic, readonly)TNListModel *tableViewModel;
@property (nonatomic, assign)BOOL supportPullDown;
@property (nonatomic, assign)BOOL supportPullUp;
- (UITableViewStyle)tableViewStyle;
- (void)bindTableCell:(NSString *)cellName tableModel:(NSString *)modelName;
- (void)loadCache;
- (void)saveCache;
- (void)requestData:(REQUEST_TYPE)requestType;
- (void)cancelRequest;
- (BOOL)hideErrorAlert;
- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType;
@end

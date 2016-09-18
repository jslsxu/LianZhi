//
//  TNBaseTableViewController.m
//  TNFoundation
//
//  Created by jslsxu on 14-9-6.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "NHFileManager.h"
#import <objc/message.h>

#define CELL_HEIGHT_SEL     @"cellHeight:cellWidth:"
#define FOOTERVIEW_HEIGHT   50.0
#define FOOT_MORE_OFFSET    5

@interface TNBaseTableViewController ()
@property (nonatomic, copy)NSString *cellName;
@property (nonatomic, copy)NSString *modelName;
@end

@implementation TNBaseTableViewController

- (id)init
{
    self = [super init];
    if(self)
    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:[self tableViewStyle]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;;
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
}

- (UITableViewStyle)tableViewStyle
{
    return UITableViewStylePlain;
}

- (void)bindTableCell:(NSString *)cellName tableModel:(NSString *)modelName
{
    self.cellName = cellName;
    self.modelName = modelName;
    _tableViewModel = [[NSClassFromString(modelName) alloc] init];
    if(![_tableViewModel isKindOfClass:[TNListModel class]])
        return;
    [self loadCache];
}


- (void)loadCache
{
    if([self supportCache])//支持缓存，先出缓存中读取数据
    {
        NSData *data = [NSData dataWithContentsOfFile:[self cacheFilePath]];
        if(data.length > 0){
            _tableViewModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self.tableView reloadData];
            if([self respondsToSelector:@selector(TNBaseTableViewControllerRequestSuccess)])
                [self TNBaseTableViewControllerRequestSuccess];
        }
    }
}

- (void)saveCache{
    if([self supportCache])
    {
        NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:_tableViewModel];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [modelData writeToFile:[self cacheFilePath] atomically:YES];
            if(success)
                NSLog(@"save success");
        });
    }
}

- (void)setSupportPullDown:(BOOL)supportPullDown
{
    _supportPullDown = supportPullDown;
    if(_supportPullDown)
    {
        @weakify(self)
        [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if(!self.isLoading){
                [self requestData:REQUEST_REFRESH];
            }
            else{
                [self.tableView.mj_header endRefreshing];
            }
        }]];
    }
    else
    {
        [self.tableView setMj_header:nil];
    }
}

- (void)setSupportPullUp:(BOOL)supportPullUp{
    _supportPullUp = supportPullUp;
    if(_supportPullUp){
        @weakify(self)
        [self.tableView setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            if(!self.isLoading){
                [self requestData:REQUEST_GETMORE];
            }
            else{
                [self.tableView.mj_footer endRefreshing];
            }
        }]];
    }
    else{
        [self.tableView setMj_footer:nil];
    }
}


- (void)showEmptyLabel:(BOOL)show
{
    if(_emptyLabel == nil)
    {
        _emptyLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
        [_emptyLabel setBackgroundColor:[UIColor clearColor]];
        [_emptyLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_emptyLabel setFont:[UIFont systemFontOfSize:14]];
        [_emptyLabel setText:@"还没有任何内容哦"];
        [_emptyLabel sizeToFit];
        [self.tableView addSubview:_emptyLabel];
    }
    [self.tableView bringSubviewToFront:_emptyLabel];
    [_emptyLabel setHidden:!show];
    [_emptyLabel setCenter:CGPointMake(self.tableView.width / 2, self.tableView.height / 2 + 30)];
}

- (void)reloadData{
    if(self.supportPullUp){
        if(![_tableViewModel hasMoreData]){
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [self.tableView.mj_footer endRefreshing];
        }
    }
    [_tableView reloadData];
}

- (void)requestData:(REQUEST_TYPE)requestType
{
    if(!self.isLoading)
    {
        HttpRequestTask *task = [self makeRequestTaskWithType:requestType];
        if(task)
        {
            self.isLoading = YES;
            __weak typeof(self) wself = self;
            AFHTTPRequestOperation *operation = [[HttpRequestEngine sharedInstance] makeRequestFromUrl:task.requestUrl method:task.requestMethod type:requestType withParams:task.params observer:task.observer completion:^(AFHTTPRequestOperation *operation, TNDataWrapper * responseObject) {
                [wself onRequestSuccess:operation responseData:responseObject];
            } fail:^(NSString *errMsg) {
                [wself onRequestFail:errMsg];
            }];
            if(operation)
            {
                if([self respondsToSelector:@selector(TNBaseTableViewControllerRequestStart)])
                    [self TNBaseTableViewControllerRequestStart];
            }

        }
        else
        {
            self.isLoading = NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    }
}

- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation responseData:(TNDataWrapper *)responseData
{
    self.isLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [_tableViewModel parseData:responseData type:operation.requestType];
    if(self.shouldShowEmptyHint)
        [self showEmptyLabel:_tableViewModel.modelItemArray.count == 0];
    [self saveCache];
    [self reloadData];
    if([self respondsToSelector:@selector(TNBaseTableViewControllerRequestSuccess)])
        [self TNBaseTableViewControllerRequestSuccess];
}

- (void)onRequestFail:(NSString *)errMsg
{
    if(![self hideErrorAlert])
        [ProgressHUD showHintText:errMsg];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.isLoading = NO;
    if([self respondsToSelector:@selector(TNBaseTableViewControllerRequestFailedWithError:)])
        [self TNBaseTableViewControllerRequestFailedWithError:errMsg];
}

- (void)cancelRequest
{
    [[HttpRequestEngine sharedInstance] cancelTaskByObserver:self];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    return nil;//子类覆盖
}

- (BOOL)hideErrorAlert
{
    return NO;
}


#pragma mark - 
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [_tableViewModel numOfSections];
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableViewModel numOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TNModelItem *item = [_tableViewModel itemForIndexPath:indexPath];
    NSNumber* (*action)(id, SEL, id,NSInteger) = (NSNumber* (*)(id, SEL,id, NSInteger)) objc_msgSend;
    NSNumber* height = action([NSClassFromString(self.cellName) class], NSSelectorFromString(CELL_HEIGHT_SEL), item, (int) _tableView.frame.size.width);
    return [height floatValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TNTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellName];
    if (!cell) {
        cell = [[NSClassFromString(self.cellName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellName];
        [cell setWidth:tableView.frame.size.width];
    }
    TNModelItem *item = [_tableViewModel itemForIndexPath:indexPath];
    [cell setData:item];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self respondsToSelector:@selector(TNBaseTableViewControllerItemSelected:atIndex:)])
        [self TNBaseTableViewControllerItemSelected:[_tableViewModel itemForIndexPath:indexPath] atIndex:indexPath];
}


//#pragma mark -
//#pragma mark EGORefreshTableHeaderDelegate Methods
//
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
//    
//    [self requestData:REQUEST_REFRESH];
//    
//}
//
//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
//    
//    return _isLoading; // should return if data source model is reloading
//    
//}
//
//- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
//    
//    return [NSDate date]; // should return date data source was last changed
//    
//}
//

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self cancelRequest];
}
@end

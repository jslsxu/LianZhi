//
//  TNBaseCollectionViewController.m
//  TNFoundation
//
//  Created by jslsxu on 14/10/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseCollectionViewController.h"
#import "NHFileManager.h"
#import <objc/message.h>

#define CELL_HEIGHT_SEL     @"cellHeight:cellWidth:"
#define FOOTERVIEW_HEIGHT   50.0
#define FOOT_MORE_OFFSET    5

@interface TNBaseCollectionViewController ()
@end

@implementation TNBaseCollectionViewController

- (id)init
{
    self = [super init];
    if(self)
    {
        if(IS_IOS7_LATER)
            self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewLayout *)layout
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _layout = [[UICollectionViewFlowLayout alloc] init];
    [self TNBaseCollectionViewControllerModifyLayout:_layout];
    
    [self loadCache];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_layout];
    if([self.cellName length] > 0)
        [_collectionView registerClass:NSClassFromString(self.cellName) forCellWithReuseIdentifier:self.cellName];
    [_collectionView setAlwaysBounceVertical:YES];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [self.view addSubview:_collectionView];
}


- (void)setModelName:(NSString *)modelName
{
    _modelName = modelName;
    _collectionViewModel = [[NSClassFromString(modelName) alloc] init];
    if(![_collectionViewModel isKindOfClass:[TNListModel class]])
        return;
}

- (void)setSupportPullDown:(BOOL)supportPullDown
{
    _supportPullDown = supportPullDown;
    if(_supportPullDown)
    {
        @weakify(self)
        [self.collectionView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            if(!_isLoading){
                [self requestData:REQUEST_REFRESH];
            }
            else{
                [self.collectionView.mj_header endRefreshing];
            }
        }]];
    }
    else
    {
        [self.collectionView setMj_header:nil];
    }
}


- (void)setSupportPullUp:(BOOL)supportPullUp{
    _supportPullUp = supportPullUp;
    if(_supportPullUp){
        __weak typeof(self) wself = self;
        [_collectionView setMj_footer:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [wself requestData:REQUEST_GETMORE];
        }]];
    }
    else{
        [_collectionView setMj_footer:nil];
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
        [self.collectionView addSubview:_emptyLabel];
    }
    [self.collectionView bringSubviewToFront:_emptyLabel];
    [_emptyLabel setHidden:!show];
    [_emptyLabel setCenter:CGPointMake(self.collectionView.width / 2, self.collectionView.height / 2 + 30)];
}

- (void)loadCache{
    if([self supportCache])//支持缓存，先出缓存中读取数据
    {
        NSData *data = [NSData dataWithContentsOfFile:[self cacheFilePath]];
        if(data.length > 0){
            _collectionViewModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self.collectionView reloadData];
            if([self respondsToSelector:@selector(TNBaseTableViewControllerRequestSuccess)])
                [self TNBaseTableViewControllerRequestSuccess];
        }
    }
    
}

- (void)reloadData
{
    if(self.supportPullUp){
        if(![_collectionViewModel hasMoreData]){
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        else{
            [self.collectionView.mj_footer endRefreshing];
        }
    }

    [_collectionView reloadData];
}

- (void)requestData:(REQUEST_TYPE)requestType
{
    if(!_isLoading)
    {
        HttpRequestTask *task = [self makeRequestTaskWithType:requestType];
        if(task)
        {
            _isLoading = YES;
            __weak typeof(self) wself = self;
            AFHTTPRequestOperation *operation = [[HttpRequestEngine sharedInstance] makeRequestFromUrl:task.requestUrl method:task.requestMethod type:requestType withParams:task.params observer:task.observer completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                [self endRefresh:requestType];
                [wself onRequestSuccess:operation responseData:responseObject];
            } fail:^(NSString *errMsg) {
                [self endRefresh:requestType];
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
            _isLoading = NO;
            [self endRefresh:requestType];
        }
    }
}

- (void)endRefresh:(REQUEST_TYPE)requestType{
    if(requestType == REQUEST_GETMORE){
        [_collectionView.mj_footer endRefreshing];
    }
    else{
        [_collectionView.mj_header endRefreshing];
    }
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    return nil;
}

- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation responseData:(TNDataWrapper *)responseData
{
    [self.collectionView.mj_header endRefreshing];
    [_collectionViewModel parseData:responseData type:operation.requestType];
    if(self.shouldShowEmptyHint)
        [self showEmptyLabel:_collectionViewModel.modelItemArray.count == 0];
    if([self respondsToSelector:@selector(TNBaseTableViewControllerRequestSuccess)])
        [self TNBaseTableViewControllerRequestSuccess];
    if([self supportCache])
    {
        NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:_collectionViewModel];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL success = [modelData writeToFile:[self cacheFilePath] atomically:YES];
            if(success)
                DLOG(@"save success");
        });
    }
    [self reloadData];
    _isLoading = NO;
}

- (void)onRequestFail:(NSString *)errMsg
{
    [self.collectionView.mj_header endRefreshing];
    [ProgressHUD showHintText:errMsg];
    _isLoading = NO;
    if([self respondsToSelector:@selector(TNBaseTableViewControllerRequestFailedWithError:)])
        [self TNBaseTableViewControllerRequestFailedWithError:errMsg];
}

- (void)cancelRequest
{
    [[HttpRequestEngine sharedInstance] cancelTaskByObserver:self];
}

#pragma mark -
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_collectionViewModel numOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_collectionViewModel numOfRowsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TNCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellName forIndexPath:indexPath];
    [cell setModelItem:[_collectionViewModel itemForIndexPath:indexPath]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self respondsToSelector:@selector(TNBaseTableViewControllerItemSelected:atIndex:)])
        [self TNBaseTableViewControllerItemSelected:[_collectionViewModel itemForIndexPath:indexPath] atIndex:indexPath];
}

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

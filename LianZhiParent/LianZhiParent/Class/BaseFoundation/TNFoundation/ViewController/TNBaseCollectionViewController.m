//
//  TNBaseCollectionViewController.m
//  TNFoundation
//
//  Created by jslsxu on 14/10/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseCollectionViewController.h"

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
        if(!_refreshHeaderView)
        {
            _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.collectionView.height, self.collectionView.width, self.collectionView.height)];
            _refreshHeaderView.delegate = self;
            [self.collectionView addSubview:_refreshHeaderView];
        }
    }
    else
    {
        [_refreshHeaderView removeFromSuperview];
        _refreshHeaderView = nil;
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

- (void)reloadData
{
    __weak typeof(self) wself = self;
    if(self.supportPullUp && [_collectionViewModel hasMoreData])
        [_collectionView addFooterWithCallback:^{
            [wself requestData:REQUEST_GETMORE];
        }];
    else
        [_collectionView removeFooter];
    [_collectionView reloadData];
}

- (void)requestData:(REQUEST_TYPE)requestType
{
    if(self.collectionViewModel.modelItemArray.count == 0)
    {
        if([self supportCache])//支持缓存，先出缓存中读取数据
        {
            id responseObject = [NSDictionary dictionaryWithContentsOfFile:[self cacheFilePath]];
            if(responseObject)
            {
                [_collectionViewModel parseData:[TNDataWrapper dataWrapperWithObject:responseObject] type:REQUEST_REFRESH];
                [self reloadData];
            }
        }

    }
    if(!_isLoading)
    {
        HttpRequestTask *task = [self makeRequestTaskWithType:requestType];
        if(task)
        {
            _isLoading = YES;
            __weak typeof(self) wself = self;
            AFHTTPRequestOperation *operation = [[HttpRequestEngine sharedInstance] makeRequestFromUrl:task.requestUrl method:task.requestMethod type:requestType withParams:task.params observer:task.observer completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
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
            _isLoading = NO;
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
            [_collectionView footerEndRefreshing];
        }
    }
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    return nil;
}

- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation responseData:(TNDataWrapper *)responseData
{
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
    [_collectionView footerEndRefreshing];
    [_collectionViewModel parseData:responseData type:operation.requestType];
    if(self.shouldShowEmptyHint)
        [self showEmptyLabel:_collectionViewModel.modelItemArray.count == 0];
    if([self respondsToSelector:@selector(TNBaseTableViewControllerRequestSuccess)])
        [self TNBaseTableViewControllerRequestSuccess];
    if([self supportCache] && operation.requestType == REQUEST_REFRESH)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [responseData.data writeToFile:[self cacheFilePath] atomically:YES];
        });
    }
    [self reloadData];
    _isLoading = NO;
}

- (void)onRequestFail:(NSString *)errMsg
{
    [ProgressHUD showHintText:errMsg];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
    [_collectionView footerEndRefreshing];
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

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self requestData:REQUEST_REFRESH];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _isLoading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma - cache

- (BOOL)supportCache
{
    return NO;
}

- (NSString *)cacheFilePath
{
    NSString *cacheName = [self cacheFileName];
    if(cacheName)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *commonCacheRoot = [HttpRequestEngine sharedInstance].commonCacheRoot;
        NSString *filePath = docDir;
        filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",commonCacheRoot,cacheName]];
        return filePath;
    }
    return nil;
}


- (NSString *)cacheFileName
{
    return nil;
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

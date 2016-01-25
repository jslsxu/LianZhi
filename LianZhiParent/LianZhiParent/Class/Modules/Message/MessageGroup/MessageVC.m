//
//  MessageVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageVC.h"
#import "MessageDetailVC.h"
#import "HomeWorkVC.h"
@interface MessageVC ()
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation MessageVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
    }
    return self;
}

- (void)invalidate
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.tableView setFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.height, self.tableView.width, self.tableView.height)];
    _refreshHeaderView.delegate = self;
    [self.tableView addSubview:_refreshHeaderView];
    
    _getMoreCell = [[TNGetMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RefreshFooter"];

    self.messageModel = [[MessageGroupListModel alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurChildChanged) name:kUserCenterChangedCurChildNotification object:nil];
    
    if([self supportCache])//支持缓存，先出缓存中读取数据
    {
        id responseObject = [NSDictionary dictionaryWithContentsOfFile:[self cacheFileName]];
        if(responseObject)
        {
            [self.messageModel parseData:[TNDataWrapper dataWrapperWithObject:responseObject] type:REQUEST_REFRESH];
            [self.tableView reloadData];
        }
    }
//    [self requestData:REQUEST_REFRESH];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPublishPhotoFinished:) name:kPublishPhotoItemFinishedNotification object:nil];
}

- (void)onPublishPhotoFinished:(NSNotification *)notification
{
    [self requestData:REQUEST_REFRESH];
//    MessageGroupItem *groupItem = [[MessageGroupItem alloc] init];
//    [groupItem setMsgNum:1];
//    MessageFromInfo *fromInfo = [[MessageFromInfo alloc] init];
//    [fromInfo setName:@"发图片"];
//    [fromInfo setLogoImage:[UIImage imageNamed:@"PostPhoto.png")]];
//    [groupItem setFromInfo:fromInfo];
//    [groupItem setContent:@"照片发送成功"];
//    [groupItem setSoundOn:YES];
//    [self.messageModel.modelItemArray insertObject:groupItem atIndex:0];
//    [self.tableView reloadData];
//    
//    if([UserCenter sharedInstance].personalSetting.soundOn)
//        [ApplicationDelegate playSound];
//    if([UserCenter sharedInstance].personalSetting.shakeOn)
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)onCurChildChanged
{
    [self requestData:REQUEST_REFRESH];
}

- (void)refreshData
{
    if(ApplicationDelegate.logouted)
    {
        [_timer invalidate];
        _timer = nil;
    }
    else
        [self requestData:REQUEST_REFRESH];
}

- (void)requestData:(REQUEST_TYPE)requestType
{
    if(!_isLoading)
    {
        __weak typeof(self) wself = self;
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/index" method:REQUEST_GET type:requestType withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [wself onRequestSuccess:operation responseData:responseObject];
        } fail:^(NSString *errMsg) {
            [wself onRequestFail:errMsg];
        }];
        if(requestType == REQUEST_GETMORE)
            [_getMoreCell startLoading];
    }
}

- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation responseData:(TNDataWrapper *)responseData
{
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [_getMoreCell stopLoading];
    [self.messageModel parseData:responseData type:operation.requestType];
    [[UserCenter sharedInstance].statusManager setMsgNum:[self newMessageNum]];
    [self setShowEmptyLabel:(self.messageModel.modelItemArray.count == 0)];
    if([self supportCache])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [responseData.data writeToFile:[self cacheFileName] atomically:YES];
        });
    }
    [self.tableView reloadData];
    _isLoading = NO;
}

- (void)onRequestFail:(NSString *)errMsg
{
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    [_getMoreCell stopLoading];
    _isLoading = NO;
//    [ProgressHUD showHintText:errMsg];
}

- (NSInteger)newMessageNum
{
    NSInteger msgNum = 0;
    for (MessageGroupItem *item in self.messageModel.modelItemArray) {
        msgNum += item.msgNum;
    }
    return msgNum;
}

- (void)setShowEmptyLabel:(BOOL)showEmpty
{
    if(showEmpty)
    {
        if(nil == _emptyLabel)
        {
            _emptyLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
            [_emptyLabel setNumberOfLines:0];
            [_emptyLabel setTextAlignment:NSTextAlignmentCenter];
            [_emptyLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [_emptyLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
            [_emptyLabel setFont:[UIFont systemFontOfSize:14]];
            [_emptyLabel setText:@"还没有任何内容哦"];
        }
        [self.view insertSubview:_emptyLabel atIndex:0];
    }
    else
    {
        [_emptyLabel removeFromSuperview];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messageModel numOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.messageModel hasMoreData] && indexPath.row == self.messageModel.modelItemArray.count)//家在更多
    {
        return _getMoreCell;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell";
        MessageGroupItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
            cell = [[MessageGroupItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        [cell setMessageItem:(MessageGroupItem *)[self.messageModel itemForIndexPath:indexPath]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageGroupItemCell cellHeight:(MessageGroupItem *)[self.messageModel itemForIndexPath:indexPath] cellWidth:tableView.width].floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageGroupItem *groupItem = [self.messageModel.modelItemArray objectAtIndex:indexPath.row];
    [groupItem setMsgNum:0];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if([self.messageModel hasMoreData] && [self.messageModel.modelItemArray count] == indexPath.row)
    {
        [self requestData:REQUEST_GETMORE];
    }
    else
    {
        if([groupItem.fromInfo isNotification])
        {
            MessageDetailVC *detailVC = [[MessageDetailVC alloc] init];
            [detailVC setFromInfo:groupItem.fromInfo];
            [self.navigationController pushViewController:detailVC animated:YES];
            [groupItem setMsgNum:0];
            [[UserCenter sharedInstance].statusManager setMsgNum:[self newMessageNum]];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else if(groupItem.fromInfo.type == ChatTypeAttendance)
        {
            
        }
        else if(groupItem.fromInfo.type == ChatTypePractice)
        {
            HomeWorkVC *homeWorkVC = [[HomeWorkVC alloc] init];
            [homeWorkVC setClassID:groupItem.fromInfo.classID];
            [CurrentROOTNavigationVC pushViewController:homeWorkVC animated:YES];
        }
        else
        {
            JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
            [chatVC setChatType:(ChatType)groupItem.fromInfo.type];
            [chatVC setTargetID:groupItem.fromInfo.uid];
            [chatVC setTo_objid:groupItem.fromInfo.from_obj_id];
            [chatVC setMobile:groupItem.fromInfo.mobile];
            NSString *title = groupItem.fromInfo.name;
            if(groupItem.fromInfo.label.length > 0 && groupItem.fromInfo.type != ChatTypeParents)
                title = [NSString stringWithFormat:@"%@(%@)",groupItem.fromInfo.name, groupItem.fromInfo.label];
            [chatVC setTitle:title];
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    NSInteger bottomOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    bottomOffset = (bottomOffset > 0) ? bottomOffset : 0;
    if([scrollView contentOffset].y >= (bottomOffset + 5))
    {
        if(!_isLoading && _getMoreCell.superview && [self.messageModel hasMoreData]) {
            [self requestData:REQUEST_GETMORE];
        }
    }
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
    return YES;
}

- (NSString *)cacheFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[HttpRequestEngine sharedInstance].commonCacheRoot,NSStringFromClass([self class])]];
    return filePath;
}

#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    [super contextMenuCellDidSelectDeleteOption:cell];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MessageGroupItem *groupitem = (MessageGroupItem *)[self.messageModel.modelItemArray objectAtIndex:indexPath.row];
    MessageFromInfo *fromInfo = [groupitem fromInfo];
    //删除消息
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:fromInfo.uid forKey:@"from_id"];
    [params setValue:kStringFromValue(fromInfo.type) forKey:@"from_type"];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_thread" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [self.messageModel.modelItemArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    } fail:^(NSString *errMsg) {
        
    }];
    
}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MessageGroupItem *groupItem = [self.messageModel.modelItemArray objectAtIndex:indexPath.row];
    NSString *soundOn = (groupItem.soundOn ? @"close" : @"open");
    MessageFromInfo *fromInfo = groupItem.fromInfo;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:fromInfo.uid forKey:@"from_id"];
    [params setValue:kStringFromValue(fromInfo.type) forKey:@"from_type"];
    [params setValue:soundOn forKey:@"sound"];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/set_thread" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        groupItem.soundOn = !groupItem.soundOn;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } fail:^(NSString *errMsg) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  MessageVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageVC.h"
#import "MessageDetailVC.h"
#import "HomeworkListVC.h"
#import "DakaViewController.h"
@interface MessageVC ()
@property (nonatomic, strong)MessageSegView *segView;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)BOOL isNotification;
@property (nonatomic, copy)NSString *requestChild;
@property (nonatomic, weak)AFHTTPRequestOperation *requestOperation;
@end

@implementation MessageVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItems = [ApplicationDelegate.homeVC commonLeftBarButtonItems];
    [self.navigationItem setTitleView:_segView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationItem setLeftBarButtonItems:nil];
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self startTimer];
    }
    return self;
}

- (void)startTimer{
    if(self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
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

    @weakify(self);
    _segView = [[MessageSegView alloc] initWithItems:@[@"通知", @"消息"] valueChanged:^(NSInteger selectedIndex) {
        @strongify(self);
        [self onSegmentChanged:selectedIndex];
    }];
    
    self.messageModel = [[MessageGroupListModel alloc] init];
    [self.messageModel setUnreadNumChanged:^(NSInteger notificationNum, NSInteger chatNum) {
        @strongify(self);
        [self.segView setShowBadge:notificationNum > 0 ? @"" : nil atIndex:0];
        [self.segView setShowBadge:chatNum > 0 ? @"" : nil atIndex:1];
    }];
//    [self.messageModel setPlayAlert:YES];
    [self loadCache];
    
    [self setIsNotification:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurChildChanged) name:kUserCenterChangedCurChildNotification object:nil];
}

- (void)showIMVC{
    [self.segView setSelectedIndex:1];
}

- (void)onSegmentChanged:(NSInteger)selectedIndex{
    self.isNotification = (selectedIndex == 0);
}

- (void)setIsNotification:(BOOL)isNotification{
    if(_isNotification != isNotification){
        _isNotification = isNotification;
        [self.tableView reloadData];
    }
}

- (NSArray *)sourceArray{
    return [self.messageModel arrayForType:self.isNotification];
}


- (void)onCurChildChanged
{
    [self.requestOperation cancel];
    [self loadCache];
    [self.tableView reloadData];
}

- (void)loadCache{
    if([self supportCache])//支持缓存，先出缓存中读取数据
    {
        id responseObject = [NSDictionary dictionaryWithContentsOfFile:[self cacheFilePath]];
        if(responseObject)
        {
            [self.messageModel parseData:[TNDataWrapper dataWrapperWithObject:responseObject] type:REQUEST_REFRESH];
        }
    }
    [self.tableView reloadData];
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
        self.requestChild = [UserCenter sharedInstance].curChild.uid;
        self.requestOperation = [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/index" method:REQUEST_GET type:requestType withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [wself onRequestSuccess:operation responseData:responseObject];
        } fail:^(NSString *errMsg) {
            [wself onRequestFail:errMsg];
        }];
    }
}

- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation responseData:(TNDataWrapper *)responseData
{
    if([self.requestChild isEqualToString:[UserCenter sharedInstance].curChild.uid]){
        [self.messageModel parseData:responseData type:operation.requestType];
        [[UserCenter sharedInstance].statusManager setMsgNum:[self newMessageNum]];
//        [self setShowEmptyLabel:(self.messageModel.modelItemArray.count == 0)];
        if([self supportCache])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [responseData.data writeToFile:[self cacheFilePath] atomically:YES];
            });
        }
        [self.tableView reloadData];
    }
    _isLoading = NO;
}

- (void)onRequestFail:(NSString *)errMsg
{
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

- (void)showEmptyView:(BOOL)show{
    
    UIView *emptyView;
    if(self.isNotification){
        if(_notificationHintView == nil){
            _notificationHintView = [[EmptyHintView alloc] initWithImage:@"NoNotification" title:@"暂时没有通知记录"];
        }
        emptyView = _notificationHintView;
        [_chatMessageHintView setHidden:YES];
    }
    else{
        if(_chatMessageHintView == nil){
            _chatMessageHintView = [[EmptyHintView alloc] initWithImage:@"NoChatMessage" title:@"暂时没有消息记录"];
        }
        emptyView = _chatMessageHintView;
        [_notificationHintView setHidden:YES];
    }
    if([emptyView superview] == nil){
        [self.view addSubview:emptyView];
    }
    [self.view bringSubviewToFront:emptyView];
    [emptyView setHidden:!show];
    [emptyView setCenter:CGPointMake(self.view.width / 2, self.view.height / 2)];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [[self sourceArray] count];
    [self showEmptyView:count == 0];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageGroupItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[MessageGroupItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.delegate = self;
    [cell setMessageItem:[self sourceArray][indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageGroupItemCell cellHeight:nil cellWidth:tableView.width].floatValue;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageGroupItem *groupItem = [[self sourceArray] objectAtIndex:indexPath.row];
    if([groupItem.fromInfo isNotification])
    {
        if(groupItem.fromInfo.type == ChatTypeAttendance)
        {
            
        }
        else if(groupItem.fromInfo.type == ChatTypeHomeworkNotification)
        {
            HomeworkListVC *homeWorkVC = [[HomeworkListVC alloc] init];
            [homeWorkVC setFromInfo:groupItem.fromInfo];
            [CurrentROOTNavigationVC pushViewController:homeWorkVC animated:YES];
        }
//        else if(groupItem.fromInfo.type == ChatTypeDoorEntrance){
//            DakaViewController *dakaVC = [[DakaViewController alloc] init];
//            [dakaVC setFromInfo:groupItem.fromInfo];
//            [CurrentROOTNavigationVC pushViewController:dakaVC animated:YES];
//        }
//        else if(groupItem.fromInfo.type == ChatTypeLianZhiBroadcast){
//            
//        }
        else {
            MessageDetailVC *detailVC = [[MessageDetailVC alloc] init];
            [detailVC setFromInfo:groupItem.fromInfo];
            [self.navigationController pushViewController:detailVC animated:YES];
            [groupItem setMsgNum:0];
            [[UserCenter sharedInstance].statusManager setMsgNum:[self newMessageNum]];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else
    {
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setChatType:(ChatType)groupItem.fromInfo.type];
        [chatVC setTargetID:groupItem.fromInfo.uid];
        [chatVC setTo_objid:groupItem.fromInfo.from_obj_id];
        [chatVC setMobile:groupItem.fromInfo.mobile];
        NSString *title = groupItem.fromInfo.name;
        [chatVC setName:title];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    [groupItem setMsgNum:0];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma - cache

#pragma - cache

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFilePath
{
    return [[NHFileManager localCurrentUserRequestCachePath] stringByAppendingPathComponent:@"messageIndex"];
}

#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    [super contextMenuCellDidSelectDeleteOption:cell];
    MessageGroupItemCell *itemCell = (MessageGroupItemCell *)cell;
    MessageGroupItem *groupItem = [itemCell messageItem];
    void (^delete)(MessageGroupItem *) = ^(MessageGroupItem *deleteGroupItem){
        MessageFromInfo *fromInfo = [deleteGroupItem fromInfo];
        if(!fromInfo.isNotification){
            [ChatMessageModel removeConversasionForUid:fromInfo.uid type:fromInfo.type];
        }
        //删除消息
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:fromInfo.uid forKey:@"from_id"];
        [params setValue:kStringFromValue(fromInfo.type) forKey:@"from_type"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_thread" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [self.messageModel deleteItem:deleteGroupItem.fromInfo.uid];
            [self.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    };
    if([groupItem.fromInfo isNotification]){
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"是否删除该记录？" message:@"删除该记录内容也会随之清空" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除(不推荐)"];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setDestructiveHandler:^(LGAlertView *alertView) {
            delete(groupItem);
        }];
        [alertView showAnimated:YES completionHandler:nil];
    
    }
    else{
        delete(groupItem);
    }

}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MessageGroupItem *groupItem = [[self sourceArray] objectAtIndex:indexPath.row];
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

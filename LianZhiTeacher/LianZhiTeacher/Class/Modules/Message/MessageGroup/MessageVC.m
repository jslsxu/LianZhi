//
//  MessageVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageVC.h"
#import "MessageDetailVC.h"
#import "ActionPopView.h"
#import "ContactVC.h"
#import "HomeWorkVC.h"
#import "StudentAttendanceVC.h"
#import "NotificationSendVC.h"
#import "NHFileManager.h"
#import "ActionFadeView.h"
#import "ChatMessageModel.h"
#import "DakaViewController.h"
@interface MessageVC ()
@property (nonatomic, strong)MessageSegView *segView;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)BOOL isNotification;
@property (nonatomic, weak)AFHTTPRequestOperation *requestOperation;
@property (nonatomic, copy)NSString *requestSchool;
@end

@implementation MessageVC

- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItems = [ApplicationDelegate.homeVC commonLeftBarButtonItems];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationItem.leftBarButtonItems = nil;
}

- (void)invalidate
{
    if(self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        [self startTimer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    
    @weakify(self);
    _segView = [[MessageSegView alloc] initWithItems:@[@"通知", @"消息"] valueChanged:^(NSInteger selectedIndex) {
        @strongify(self);
        [self onSegmentChanged:selectedIndex];
    }];
    [self.navigationItem setTitleView:_segView];
    
    [self setIsNotification:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ActionAdd"] style:UIBarButtonItemStylePlain target:self action:@selector(onAddActionClicked:)];
    
    self.messageModel = [[MessageGroupListModel alloc] init];
    [self.messageModel setUnreadNumChanged:^(NSInteger notificationNum, NSInteger chatNum) {
        @strongify(self);
        [self.segView setShowBadge:notificationNum > 0 ? @"" : nil atIndex:0];
        [self.segView setShowBadge:chatNum > 0 ? @"" : nil atIndex:1];
    }];
    [self.messageModel setPlayAlert:YES];
    [self loadCache];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPublishPhotoFinished:) name:kPublishPhotoItemFinishedNotification object:nil];
}

- (void)startTimer{
    if(self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
}

- (void)showIMVC{
    [self.segView setSelectedIndex:1];
}

- (void)onSegmentChanged:(NSInteger)selectedIndex{
    self.isNotification = (selectedIndex == 0);
    
}

- (void)onAddActionClicked:(LZTabBarButton *)button
{
    //    NSString *ActionAddKey = @"ActionAddKey";
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setBool:YES forKey:ActionAddKey];
    //    [userDefaults synchronize];
    //    [button setBadgeValue:nil];
    [ActionFadeView showActionView];
}

- (void)onPublishPhotoFinished:(NSNotification *)notification
{
    [self requestData:REQUEST_REFRESH];
}


- (void)onCurSchoolChanged
{
    [self.requestOperation cancel];
    [self loadCache];
    [self.tableView reloadData];
}


- (void)refreshData
{
    if(ApplicationDelegate.logouted)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    else
        [self requestData:REQUEST_REFRESH];
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
}

- (void)requestData:(REQUEST_TYPE)requestType
{
    if(!_isLoading)
    {
        __weak typeof(self) wself = self;
        self.requestSchool = [UserCenter sharedInstance].curSchool.schoolID;
        self.requestOperation = [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/index" method:REQUEST_GET type:requestType withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [wself onRequestSuccess:operation responseData:responseObject];
        } fail:^(NSString *errMsg) {
            [wself onRequestFail:errMsg];
        }];
    }
}

- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation responseData:(TNDataWrapper *)responseData
{
    if([self.requestSchool isEqualToString:[UserCenter sharedInstance].curSchool.schoolID]){
        [self.messageModel parseData:responseData type:operation.requestType];
        [[UserCenter sharedInstance] save];
        [[UserCenter sharedInstance].statusManager setMsgNum:[self newMessageNum]];
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
}

- (NSInteger)newMessageNum
{
    NSInteger msgNum = 0;
    for (MessageGroupItem *item in self.messageModel.modelItemArray) {
        msgNum += item.msgNum;
    }
    return msgNum;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self sourceArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MessageGroupItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
        cell = [[MessageGroupItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    MessageGroupItem *item = [self sourceArray][indexPath.row];
    [cell setMessageItem:item];
    
    @weakify(self)
    @weakify(cell)
    NSMutableArray *buttonArray = [NSMutableArray array];
    MGSwipeButton * deleteButton = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor colorWithHexString:@"e71f19"] callback:^BOOL(MGSwipeTableCell * sender){
        @strongify(cell)
        @strongify(self)
        [self deleteCell:cell];
        return YES;
    }];
    [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonArray addObject:deleteButton];
    MGSwipeButton * soundButton = [MGSwipeButton buttonWithTitle:item.soundOn ? @"静音" : @"关闭静音" backgroundColor:[UIColor colorWithHexString:@"28c4d8"] callback:^BOOL(MGSwipeTableCell * sender){
        @strongify(cell)
        @strongify(self)
        [self switchSoundForCell:cell];
        return YES;
    }];
    [soundButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [buttonArray addObject:soundButton];
    [cell setRightButtons:buttonArray];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MessageGroupItemCell cellHeight:nil cellWidth:tableView.width].floatValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageGroupItemCell *itemCell = (MessageGroupItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    MessageGroupItem *groupItem = itemCell.messageItem;
    
    if([groupItem.fromInfo isNotification])
    {
        if(groupItem.fromInfo.type == ChatTypeAttendance)
        {
            StudentAttendanceVC *classAttendanceVC = [[StudentAttendanceVC alloc] init];
            classAttendanceVC.classID = groupItem.fromInfo.classID;
            classAttendanceVC.targetStudentID = groupItem.fromInfo.childID;
            [CurrentROOTNavigationVC pushViewController:classAttendanceVC animated:YES];
        }
        else{
            MessageDetailVC *detailVC = [[MessageDetailVC alloc] init];
            [detailVC setFromInfo:groupItem.fromInfo];
            [self.navigationController pushViewController:detailVC animated:YES];
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

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFilePath
{
    return [[NHFileManager localCurrentUserRequestCachePath] stringByAppendingPathComponent:@"messageIndex"];
}

#pragma mark * DAContextMenuCell delegate

- (void)deleteCell:(MessageGroupItemCell *)cell{
    @weakify(self)
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"是否删除该记录？" message:@"删除该记录内容也会随之清空" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除(不推荐)"];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        @strongify(self)
        MessageGroupItemCell *itemCell = (MessageGroupItemCell *)cell;
        MessageGroupItem *groupItem = [itemCell messageItem];
        MessageFromInfo *fromInfo = [groupItem fromInfo];
        if(!fromInfo.isNotification){
            [ChatMessageModel removeConversasionForUid:fromInfo.uid type:fromInfo.type];
        }
        //删除消息
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:fromInfo.uid forKey:@"from_id"];
        [params setValue:kStringFromValue(fromInfo.type) forKey:@"from_type"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_thread" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [self.messageModel deleteItem:groupItem.fromInfo.uid];
            [self.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];
    
}

- (void)switchSoundForCell:(MessageGroupItemCell *)cell{
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

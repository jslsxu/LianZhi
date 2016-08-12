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
#import "ExchangeSchoolVC.h"
#import "NHFileManager.h"
#import "ActionFadeView.h"
#import "ChatMessageModel.h"
@implementation SwitchSchoolButton


- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_redDot == nil)
    {
        _redDot = [[NumIndicator alloc] init];
        [_redDot setIndicator:@""];
        [_redDot setHidden:YES];
        [self addSubview:_redDot];
    }
    [_redDot setCenter:CGPointMake(self.width - 7, 5)];
}

- (void)setHasNew:(BOOL)hasNew
{
    _hasNew = hasNew;
    [_redDot setHidden:!_hasNew];
}

@end

@interface MessageVC ()
@property (nonatomic, strong)MessageSegView *segView;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)BOOL isNotification;

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
    if(self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self.timer fire];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [ApplicationDelegate homeVC].navigationItem.rightBarButtonItem = nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    
    //navigation
    if([UserCenter sharedInstance].userData.schools.count > 1)
    {
        UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
        flexibleSpaceBarButtonItem.width = -5;
        _switchButton = [[SwitchSchoolButton alloc] initWithFrame:CGRectMake(-10, 0, 32, 32)];
        [_switchButton setImage:[UIImage imageNamed:@"SwitchSchool"] forState:UIControlStateNormal];
        [_switchButton addTarget:self action:@selector(switchSchool) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *switchItem = [[UIBarButtonItem alloc] initWithCustomView:_switchButton];
        self.navigationItem.leftBarButtonItems = @[flexibleSpaceBarButtonItem, switchItem];
    }
    @weakify(self);
    _segView = [[MessageSegView alloc] initWithItems:@[@"通知", @"消息"] valueChanged:^(NSInteger selectedIndex) {
        @strongify(self);
        [self onSegmentChanged:selectedIndex];
    }];
    [self.navigationItem setTitleView:_segView];
    
    [self setIsNotification:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ActionAdd"] style:UIBarButtonItemStylePlain target:self action:@selector(onAddActionClicked:)];
    
//    LZTabBarButton *addButton = [LZTabBarButton buttonWithType:UIButtonTypeCustom];
//    [addButton setImage:[UIImage imageNamed:@"ActionAdd"] forState:UIControlStateNormal];
//    [addButton addTarget:self action:@selector(onAddActionClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [addButton setSize:CGSizeMake(40, 40)];
//    
//    NSString *ActionAddKey = @"ActionAddKey";
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    BOOL actionAddNew = [userDefaults boolForKey:ActionAddKey];
//    if(!actionAddNew)
//    {
//        [addButton setBadgeValue:@""];
//    }
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    self.messageModel = [[MessageGroupListModel alloc] init];
    [self.messageModel setUnreadNumChanged:^(NSInteger notificationNum, NSInteger chatNum) {
        @strongify(self);
        [self.segView setShowBadge:notificationNum > 0 ? @"" : nil atIndex:0];
        [self.segView setShowBadge:chatNum > 0 ? @"" : nil atIndex:1];
    }];
    [self.messageModel setPlayAlert:YES];
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
    BOOL hasNew = NO;
    for (NoticeItem *notice in [UserCenter sharedInstance].statusManager.notice) {
        if(![notice.schoolID isEqualToString:[UserCenter sharedInstance].curSchool.schoolID])
            hasNew = YES;
    }
    [_switchButton setHasNew:hasNew];
    [self requestData:REQUEST_REFRESH];
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
    }
}

- (void)onRequestSuccess:(AFHTTPRequestOperation *)operation responseData:(TNDataWrapper *)responseData
{
    [self.messageModel parseData:responseData type:operation.requestType];
    [[UserCenter sharedInstance] save];
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

- (void)switchSchool
{
    ExchangeSchoolVC *exchangeSchoolVC = [[ExchangeSchoolVC alloc] init];
    [self.navigationController pushViewController:exchangeSchoolVC animated:YES];
}
#pragma mark - UITableViewDelegate

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
            [self.view addSubview:_emptyLabel];
        }
         [_emptyLabel setHidden:NO];
    }
    else
    {
        [_emptyLabel setHidden:YES];
    }
}

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
    MessageGroupItemCell *itemCell = (MessageGroupItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
     MessageGroupItem *groupItem = itemCell.messageItem;
    [groupItem setMsgNum:0];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
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
        StudentAttendanceVC *classAttendanceVC = [[StudentAttendanceVC alloc] init];
        classAttendanceVC.classID = groupItem.fromInfo.classID;
        classAttendanceVC.targetStudentID = groupItem.fromInfo.childID;
        [CurrentROOTNavigationVC pushViewController:classAttendanceVC animated:YES];
    }
    else if(groupItem.fromInfo.type == ChatTypePractice)
    {
        
    }

    else
    {
        JSMessagesViewController *chatVC = [[JSMessagesViewController alloc] init];
        [chatVC setChatType:(ChatType)groupItem.fromInfo.type];
        [chatVC setTargetID:groupItem.fromInfo.uid];
        [chatVC setTo_objid:groupItem.fromInfo.from_obj_id];
        [chatVC setMobile:groupItem.fromInfo.mobile];
        [chatVC setSoundOn:groupItem.soundOn];
        NSString *title = groupItem.fromInfo.name;
        if(groupItem.fromInfo.label.length > 0 && groupItem.fromInfo.type != ChatTypeParents)
            title = [NSString stringWithFormat:@"%@(%@)",groupItem.fromInfo.name, groupItem.fromInfo.label];
        [chatVC setTitle:title];
        [self.navigationController pushViewController:chatVC animated:YES];
    }
}

#pragma - cache

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [[NHFileManager localCurrentUserRequestCachePath] stringByAppendingPathComponent:@"messageIndex"];
}

#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    [super contextMenuCellDidSelectDeleteOption:cell];
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



#import "JSMessagesViewController.h"
#import "ChatExtraGroupInfoVC.h"
#import "ChatExtraIndividualInfoVC.h"
#import "MyGiftVC.h"
#import "ChatTopNewMessageView.h"
#import "ChatBottomNewMessageView.h"
#import "ChatTeacherInfoVC.h"
#import "ChatParentInfoVC.h"
static NSString *topChatID = nil;

@interface JSMessagesViewController ()
@property (nonatomic, assign)BOOL quietModeOn;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)ChatMessageModel *chatMessageModel;
@property (nonatomic, assign)BOOL isRequestHistory;
@property (nonatomic, assign)BOOL isRequestLatest;
@property (nonatomic, strong)ChatTopNewMessageView *topNewIndicator;
@property (nonatomic, strong)ChatBottomNewMessageView *bottomNewIndicator;
@property (nonatomic, assign)BOOL showTopAlert;
@property (nonatomic, assign)BOOL firstIn;
@property (nonatomic, assign)BOOL imDisabled;
@end

@implementation JSMessagesViewController


#pragma mark - View lifecycle

+ (NSString *)curChatID
{
    return topChatID;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    topChatID = nil;
}

- (ChatMessageModel *)curChatMessageModel{
    return self.chatMessageModel;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    [self endTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetID forKey:@"from_id"];
    [params setValue:kStringFromValue(self.chatType) forKey:@"from_type"];
    @weakify(self);
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/get_sound" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self);
        NSString *status = [responseObject getStringForKey:@"sound"];
        self.quietModeOn = ![status isEqualToString:@"open"];
        [self updateTitle];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ApplicationDelegate.homeVC showIMVC];
    self.interactivePopDisabled = YES;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    topChatID = self.targetID;
    BOOL isGroup = self.chatType == ChatTypeClass || self.chatType == ChatTypeGroup;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:isGroup ? @"GroupInfoIcon" : @"SingleInfoIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showChatUserInfo)];
    
    _inputView = [[InputBarView alloc] init];
    if(self.chatType == ChatTypeClass)
        [_inputView setClassID:self.targetID];
    else if(self.chatType == ChatTypeGroup)
        [_inputView setGroupID:self.targetID];
    [_inputView setCanSendGift:self.chatType == ChatTypeParents || self.chatType == ChatTypeTeacher];
    [_inputView setCanCallTelephone:((self.chatType == ChatTypeParents || self.chatType == ChatTypeTeacher) && self.mobile.length > 0)];
    [_inputView setInputDelegate:self];
    [_inputView setY:self.view.height - _inputView.height - 64];
    [self.view addSubview:_inputView];
    
    [self.view addSubview:[self tableView]];
    
    [self.chatMessageModel setTargetUser:self.name];
    [self scrollToBottom:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.tableView addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveGift:) name:ReceiveGiftNotification object:nil];
    
    [self startTimer];
    
//    NSTimer *sendTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
//        static NSInteger msgIndex = 0;
//        if(msgIndex == 0){
//            [self inputBarViewDidCommit:@"开始测试" atArray:nil];
//        }
//        else if(msgIndex < 20){
//            //test
//            [self inputBarViewDidCommit:kStringFromValue(msgIndex) atArray:nil];
//        }
//        else{
//            [timer invalidate];
//        }
//        msgIndex ++;
//    } repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:sendTimer forMode:NSRunLoopCommonModes];
//    [sendTimer fire];
}

- (void)startTimer{
    if(!_timer){
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getMessage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}

- (void)endTimer{
    [_timer invalidate];
    _timer = nil;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - _inputView.height) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
        [_tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestOldMessage)]];
    }
    return _tableView;
}

- (ChatMessageModel *)chatMessageModel{
    if(!_chatMessageModel){
        _chatMessageModel = [[ChatMessageModel alloc] initWithUid:self.targetID type:self.chatType];
        [_chatMessageModel setTargetUser:self.name];
    }
    return _chatMessageModel;
}

- (void)setQuietModeOn:(BOOL)quietModeOn
{
    _quietModeOn = quietModeOn;
    [self.chatMessageModel setQuietModeOn:quietModeOn];
}

- (void)setImDisabled:(BOOL)imDisabled{
    _imDisabled = imDisabled;
    [_inputView setImDisabled:_imDisabled];
}

- (void)updateTitle
{
    BOOL earMode = [UserCenter sharedInstance].personalSetting.earPhone;
    BOOL quietModeOn = self.quietModeOn;
    if(!quietModeOn && !earMode){
        self.navigationItem.title = self.name;
        [self.navigationItem setTitleView:nil];
    }
    else{
        NSInteger maxWidth = self.view.width - 80 * 2;
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 40)];
        NSInteger width = 0;
        NSInteger spaceXEnd = titleView.width;
        UIImageView *soundOffImageView = nil;
        if(quietModeOn)
        {
            soundOffImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TitleSoundOff"]];
            [titleView addSubview:soundOffImageView];
            [soundOffImageView setOrigin:CGPointMake(spaceXEnd - soundOffImageView.width, (titleView.height - soundOffImageView.height) / 2)];
            width += soundOffImageView.width + 5;
            spaceXEnd -= soundOffImageView.width + 5;
        }
        UIImageView *earPhoneImageView = nil;
        if(earMode)
        {
            earPhoneImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"EarPhoneMode"]];
            [titleView addSubview:earPhoneImageView];
            width += earPhoneImageView.width + 5;
            spaceXEnd -= earPhoneImageView.width + 5;
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setFont:[UIFont systemFontOfSize:18]];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"252525"]];
        [titleLabel setText:self.name];
        [titleLabel sizeToFit];
        [titleView addSubview:titleLabel];
        width += titleLabel.width;
        
        if(width < maxWidth)
        {
            [titleLabel setOrigin:CGPointMake((titleView.width - width) / 2, (titleView.height - titleLabel.height) / 2)];
            NSInteger spaceXStart = titleLabel.right + 5;
            if(earMode)
            {
                [earPhoneImageView setOrigin:CGPointMake(spaceXStart, (titleView.height - earPhoneImageView.height) / 2)];
                spaceXStart += earPhoneImageView.width + 5;
            }
            if(quietModeOn)
                [soundOffImageView setOrigin:CGPointMake(spaceXStart, (titleView.height - soundOffImageView.height) / 2)];
        }
        else
        {
            [titleLabel setFrame:CGRectMake(0, 0, spaceXEnd, titleView.height)];
        }
        
        self.navigationItem.titleView = titleView;
        self.navigationItem.title = nil;
    }

}
- (void)cleatChatRecordCompletion:(ClearChatFinished)finished{
    @weakify(self)
    NSMutableDictionary *sendParams = [self sendParams];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/clear" method:REQUEST_POST type:REQUEST_REFRESH withParams:sendParams observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self)
        [self.chatMessageModel clearChatRecord];
        [self.tableView reloadData];
        if(finished){
            finished(YES);
        }
    } fail:^(NSString *errMsg) {
        if(finished){
            finished(NO);
        }
    }];
}

- (void)showChatUserInfo
{
    @weakify(self)
    if(self.chatType == ChatTypeClass || self.chatType == ChatTypeGroup){
        ChatExtraGroupInfoVC *chatExtraInfoVC = [[ChatExtraGroupInfoVC alloc] init];
        [chatExtraInfoVC setChatType:self.chatType];
        [chatExtraInfoVC setGroupID:self.targetID];
        [chatExtraInfoVC setQuietModeOn:self.quietModeOn];
        [chatExtraInfoVC setAlertChangeCallback:^(BOOL quietModeOn) {
            @strongify(self)
            self.quietModeOn = quietModeOn;
            [self updateTitle];
        }];
        [chatExtraInfoVC setClearChatRecordCallback:^(ClearChatFinished clearChatFinished) {
            @strongify(self)
            [self cleatChatRecordCompletion:clearChatFinished];
        }];
        [self.navigationController pushViewController:chatExtraInfoVC animated:YES];
    }
    else{
        ChatExtraIndividualInfoVC *chatExtraInfoVC = [[ChatExtraIndividualInfoVC alloc] init];
        [chatExtraInfoVC setUid:self.targetID];
        [chatExtraInfoVC setToObjid:self.to_objid];
        [chatExtraInfoVC setChatType:self.chatType];
        [chatExtraInfoVC setQuietModeOn:self.quietModeOn];
        [chatExtraInfoVC setAlertChangeCallback:^(BOOL quietModeOn) {
            @strongify(self)
            self.quietModeOn = quietModeOn;
            [self updateTitle];
        }];
        [chatExtraInfoVC setClearChatRecordCallback:^(ClearChatFinished clearChatFinished){
            @strongify(self)
            [self cleatChatRecordCompletion:clearChatFinished];
        }];
        [self.navigationController pushViewController:chatExtraInfoVC animated:YES];

    }
}

- (void)scrollToSearchResult:(MessageItem *)messageItem{
    
    for (NSInteger i = 0; i < self.chatMessageModel.messageArray.count; i++) {
        MessageItem *item = self.chatMessageModel.messageArray[i];
        if([item.content.mid isEqualToString:messageItem.content.mid]){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            return;
        }
    }
    [self.chatMessageModel loadForSearchItem:messageItem.content.mid];
    [self.tableView reloadData];
    if([self.chatMessageModel.messageArray count] > 0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
    //如果当前没有，去数据库查
    
}

- (void)onTap
{
    if(_inputView.inputType != InputTypeNone){
        [_inputView setInputType:InputTypeNone];
    }
}


- (void)getMessage
{
    if(ApplicationDelegate.logouted)
    {
        [_timer invalidate];
        _timer = nil;
    }
    else
    {
        [self requestLatestMessage];
        if(self.chatType == ChatTypeClass){
            [self requestIMStatus];
        }
    }
}

- (void)requestIMStatus{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"0" forKey:@"type"];
    [params setValue:self.targetID forKey:@"cg_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/get_im_status" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        self.imDisabled = [responseObject getBoolForKey:@"im_status"];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)requestOldMessage{
    if(self.isRequestHistory)
        return;
    self.isRequestHistory = YES;
    NSInteger loadCount = [self.chatMessageModel loadOldData];
    if(loadCount > 0){
        [self.tableView reloadData];
        //        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:loadCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.tableView.mj_header endRefreshing];
        self.isRequestHistory = NO;
    }
    else{
        NSMutableDictionary *params = [self sendParams];
        
        ChatMessageModel *messageModel = [self chatMessageModel];
        [params setValue:messageModel.oldId forKey:@"more_id"];
        [params setValue:kStringFromValue(0) forKey:@"more_new"];
        @weakify(self);
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/get" method:REQUEST_GET type:REQUEST_GETMORE withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            @strongify(self);
            [self.chatMessageModel parseData:responseObject.data type:RequestMessageTypeOld];
            [self.tableView reloadData];
            self.isRequestHistory = NO;
            [self.tableView.mj_header endRefreshing];
        } fail:^(NSString *errMsg) {
            @strongify(self);
            [self.tableView.mj_header endRefreshing];
            self.isRequestHistory = NO;
        }];
        
    }
}

- (void)requestLatestMessage{
    NSMutableDictionary *params = [self sendParams];
    
    ChatMessageModel *messageModel = [self chatMessageModel];
    [params setValue:kStringFromValue([messageModel checkStatusTime]) forKey:@"ctime"];
    [params setValue:messageModel.latestId forKey:@"more_id"];
    [params setValue:kStringFromValue(1) forKey:@"more_new"];
    @weakify(self);
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/getx" method:REQUEST_GET type:REQUEST_GETMORE withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self);
        TNDataWrapper *items = [responseObject getDataWrapperForKey:@"items"];
        NSInteger unreadCount = 0;
        NSString *atMid = nil;
        MessageItem *atMessageItem;
        for (NSInteger i = 0; i< items.count; i++) {
            TNDataWrapper *messageItemWrapper = [items getDataWrapperForIndex:i];
            MessageItem *messageItem = [MessageItem modelWithDictionary:messageItemWrapper.data];
            if(messageItem.content.unread){
                unreadCount++;
                if([messageItem isAtMe]){
                    atMid = messageItem.content.mid;
                }
            }
        }
        BOOL shouldScrollToBottom = NO;
        if(self.tableView.contentOffset.y + self.tableView.height > self.tableView.contentSize.height - 80){
            shouldScrollToBottom = YES;
        }
        BOOL hasNew = [self.chatMessageModel parseData:responseObject.data type:RequestMessageTypeLatest];
        if(atMid.length > 0){
            for (NSInteger i = self.chatMessageModel.messageArray.count - 1; i >= 0; i--) {
                MessageItem *messageItem = self.chatMessageModel.messageArray[i];
                if([messageItem.content.mid isEqualToString:atMid]){
                    atMessageItem = messageItem;
                }
            }
        }
        BOOL isFirstIn = self.firstIn;
        if(hasNew){
            [self.tableView reloadData];
            if(shouldScrollToBottom){
                if(!self.firstIn){
                    self.firstIn = YES;
                    [self scrollToBottom:NO];
                }
                else{
                    [self scrollToBottom:YES];
                }
                NSArray *visibleCells = [self.tableView visibleCells];
                if(atMessageItem){
                     NSInteger atIndex = [self.chatMessageModel.messageArray indexOfObject:atMessageItem];
                    if(atIndex + visibleCells.count < self.chatMessageModel.messageArray.count && !isFirstIn){//超出显示范围
                        [self showTopNewMessageWithAtItem:atMessageItem];
                    }
                    else{
                        //如果第一个超出范围
                        if(visibleCells.count < unreadCount && !isFirstIn){
                            [self showTopNewMessageWithNum:unreadCount];
                        }
                    }
                }
                else{
                    //如果第一个超出范围
                    if(visibleCells.count < unreadCount && !isFirstIn){
                        [self showTopNewMessageWithNum:unreadCount];
                    }
                }
            }
            else{
                //如果最后一个不再显示范围
                NSInteger count = 0;
                for (MessageItem *item in self.chatMessageModel.messageArray) {
                    if(!item.isRead){
                        count++;
                    }
                }
                if(count > 0){
                    [self showBottomNewMessageWithNum:count];
                }
                else{
                    [self dismissBottomIndicator];
                }
            }
        }
    } fail:^(NSString *errMsg) {
        
    }];
    
}


- (NSMutableDictionary *)sendParams{
    NSMutableDictionary *messageParam = [NSMutableDictionary dictionary];
    [messageParam setValue:[UserCenter sharedInstance].curChild.uid forKey:@"objid"];
    [messageParam setValue:self.to_objid forKey:@"to_objid"];
    [messageParam setValue:self.targetID forKey:@"to_id"];
    [messageParam setValue:kStringFromValue(self.chatType) forKey:@"to_type"];
    [messageParam setValue:self.name forKey:@"target_name"];
    return messageParam;
}

- (void)replaceOriginalMessage:(MessageItem *)originalMessage withSuccessMessage:(MessageItem *)messageItem{
    [self.chatMessageModel updateMessage:messageItem];
    //    NSInteger row = [self.chatMessageModel.messageArray indexOfObject:messageItem];
    [self.tableView reloadData];
}

- (void)commitMessage:(MessageItem *)messageItem{
    [messageItem setTargetUser:self.name];
    MessageItem *preItem = [self.chatMessageModel.messageArray lastObject];
    if(messageItem.content.ctime - preItem.content.ctime <= 60 * 3)
        [messageItem.content setHideTime:YES];
    [self.chatMessageModel sendNewMessage:messageItem];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.chatMessageModel.messageArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self scrollToBottom:YES];
    @weakify(self)
    [messageItem sendWithCommonParams:[self sendParams] progress:^(CGFloat progress) {
        
    } success:^(MessageItem *successMessageItem) {
        @strongify(self)
        [self replaceOriginalMessage:messageItem withSuccessMessage:successMessageItem];
    } fail:^(NSString *errMsg) {
        [self.chatMessageModel updateMessage:messageItem];
        NSInteger index = [[self.chatMessageModel messageArray] indexOfObject:messageItem];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)scrollToBottom:(BOOL)animated
{
    NSArray *modelArray = self.chatMessageModel.messageArray;
    if(modelArray.count > 0)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:modelArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}


- (void)showBottomNewMessageWithNum:(NSInteger)num{
    [self.bottomNewIndicator setMessageNum:num];
    [self.bottomNewIndicator setOrigin:CGPointMake(self.view.width - self.bottomNewIndicator.width - 10, _inputView.top - self.bottomNewIndicator.height - 5)];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomNewIndicator.alpha = 1.f;
    }];
}

- (void)showTopNewMessageWithNum:(NSInteger)num{
    NSInteger count = self.chatMessageModel.messageArray.count;
    NSInteger targetIndex = count - num;
    if(targetIndex < self.chatMessageModel.messageArray.count){
        [self.topNewIndicator showWithTargetItem:self.chatMessageModel.messageArray[targetIndex] newMessageNum:num];
        @weakify(self)
        [self.topNewIndicator setTopNewMessageCallback:^{
            @strongify(self)
            NSInteger row = [self.chatMessageModel.messageArray indexOfObject:self.topNewIndicator.targetItem];
            if(row >= 0 && row < [self.chatMessageModel.messageArray count]){
                [self.tableView scrollToRow:row inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:YES];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    MessageCell *cell = (MessageCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
//                    [cell flashForAtMe];
//                });
            }
            [self dismissTopIndicator];
        }];
        [self.topNewIndicator setOrigin:CGPointMake(self.view.width - self.topNewIndicator.width, 15)];
        [UIView animateWithDuration:0.3 animations:^{
            self.topNewIndicator.alpha = 1.f;
        }];
    }
}

- (void)showTopNewMessageWithAtItem:(MessageItem *)atItem{
    if(self.showTopAlert){
        return;
    }
    self.showTopAlert = YES;
    [self.topNewIndicator showAtWithTargetItem:atItem];
    @weakify(self)
    [self.topNewIndicator setTopNewMessageCallback:^{
        @strongify(self)
        NSInteger row = [self.chatMessageModel.messageArray indexOfObject:self.topNewIndicator.targetItem];
        if(row >= 0 && row < [self.chatMessageModel.messageArray count]){
            [self.tableView scrollToRow:row inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            MessageCell *cell = (MessageCell *)[self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
//            [cell flashForAtMe];
//        });
        [self dismissTopIndicator];
    }];
    [self.topNewIndicator setOrigin:CGPointMake(self.view.width - self.topNewIndicator.width, 15)];
    [UIView animateWithDuration:0.3 animations:^{
        self.topNewIndicator.alpha = 1.f;
    }];
}

- (void)dismissBottomIndicator{
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomNewIndicator.alpha = 0.f;
    }];
}

- (void)dismissTopIndicator{
    [UIView animateWithDuration:0.3 animations:^{
        self.topNewIndicator.alpha = 0.f;
    }];
}

- (ChatTopNewMessageView *)topNewIndicator{
    if(!_topNewIndicator){
        _topNewIndicator = [[ChatTopNewMessageView alloc] init];
        [self.view addSubview:_topNewIndicator];
        [_topNewIndicator setAlpha:0.f];
    }
    return _topNewIndicator;
}

- (ChatBottomNewMessageView *)bottomNewIndicator{
    if(!_bottomNewIndicator){
        @weakify(self)
        _bottomNewIndicator = [[ChatBottomNewMessageView alloc] init];
        [_bottomNewIndicator setBottomNewCallback:^{
            @strongify(self)
            [self scrollToBottom:YES];
            [self dismissBottomIndicator];
        }];
        [_bottomNewIndicator setAlpha:0.f];
        [self.view addSubview:_bottomNewIndicator];
    }
    return _bottomNewIndicator;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatMessageModel.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageItem *messageItem = self.chatMessageModel.messageArray[indexPath.row];
    //    return [messageItem cellHeight];
    return [MessageCell cellHeightForModel:messageItem];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageItem *messageItem = [[self chatMessageModel].messageArray objectAtIndex:indexPath.row];
    NSString *reuseID = messageItem.reuseID;
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell){
        cell = [[MessageCell alloc] initWithModel:messageItem reuseID:reuseID];
    }
    else{
        [cell setMessageItem:messageItem];
    }
    if(messageItem == self.topNewIndicator.targetItem){
        [self dismissTopIndicator];
    }
    [cell setDelegate:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageItem *messageItem = [[self chatMessageModel].messageArray objectAtIndex:indexPath.row];
    messageItem.isRead = YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_inputView.inputType != InputTypeNone && scrollView.tracking)
        [_inputView setInputType:InputTypeNone];
    if(scrollView.contentOffset.y + scrollView.height >= scrollView.contentSize.height){
        [self dismissBottomIndicator];
    }
}

#pragma mark - InputDelegate

- (void)inputBarViewDidChangeHeight:(NSInteger)height
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView setHeight:self.view.height - height];
        [_inputView setFrame:CGRectMake(0, self.view.height - height, self.view.width, height)];
    } completion:^(BOOL finished) {
        
    }];
    [self scrollToBottom:YES];
}

- (void)inputBarViewDidCommit:(NSString *)text atArray:(NSArray *)atArray
{
    MessageItem *messageItem = [MessageItem messageItemWithText:text atArray:atArray];
    [self commitMessage:messageItem];
}

- (void)inputBarViewDidFaceSelect:(NSString *)face
{
    MessageItem *messageItem = [MessageItem messageItemWithFace:face];
    [self commitMessage:messageItem];
}

- (void)inputBarViewDidSendPhoto:(PhotoItem *)photoItem
{
    MessageItem *messageItem = [MessageItem messageItemWithImage:photoItem];
    [self commitMessage:messageItem];
}

- (void)inputBarViewDidSendPhotoArray:(NSArray *)photoArry
{
    for (PhotoItem *image in photoArry)
    {
        [self inputBarViewDidSendPhoto:image];
    }
}

- (void)inputBarViewDidSendVoice:(AudioItem *)audioItem
{
    if(audioItem.timeSpan < 2)
    {
        [ProgressHUD showHintText:@"录音时间太短，请重新录制"];
    }
    else
    {
        MessageItem *messageItem = [MessageItem messageItemWithAudio:audioItem];
        [self commitMessage:messageItem];
    }
}

- (void)inputBarViewDidSendGift:(GiftItem *)giftItem
{
    MessageItem *messageItem = [MessageItem messageItemWithGift:giftItem];
    [self commitMessage:messageItem];
}

- (void)inputBarViewDidSendVideo:(VideoItem *)videoItem{
    MessageItem *messageItem = [MessageItem messageItemWithVideo:videoItem];
    [self commitMessage:messageItem];
}

- (void)inputBarViewDidCallTelephone{
    if(self.mobile.length > 0)
    {
        LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定拨打电话%@吗",self.mobile] style:LGAlertViewStyleAlert buttonTitles:@[@"取消", @"拨打电话"] cancelButtonTitle:nil destructiveButtonTitle:nil];
        [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
        [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
        [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            if(index == 1){
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",self.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            }
        }];
        [alertView showAnimated:YES completionHandler:nil];
    }
}

#pragma mark - MessageCellDelegate

- (void)onMenuShow{
    if(_inputView.inputType != InputTypeNone){
        [_inputView setInputType:InputTypeNone];
    }
}

- (void)onAvatarClicked:(MessageItem *)messageItem{
    UserInfo *userInfo = messageItem.user;
    if(self.chatType == ChatTypeClass){
        NSRange range = [userInfo.name rangeOfString:@"老师"];
        if(range.location == NSNotFound){
            ChatParentInfoVC *parentInfoVC = [[ChatParentInfoVC alloc] init];
            [parentInfoVC setUid:userInfo.uid];
            [self.navigationController pushViewController:parentInfoVC animated:YES];
        }
        else{
            ChatTeacherInfoVC *teacherInfoVC = [[ChatTeacherInfoVC alloc] init];
            [teacherInfoVC setUid:userInfo.uid];
            [teacherInfoVC setLabel:self.name];
            [self.navigationController pushViewController:teacherInfoVC animated:YES];
        }
    }
}

- (void)onLongPressAvatar:(MessageItem *)messageItem{
    if(self.chatType == ChatTypeClass || self.chatType == ChatTypeGroup){
        [_inputView addAtUser:messageItem.user];
    }
}

- (void)onRevokeMessage:(MessageItem *)messageItem
{
    NSMutableDictionary *sendParams = [self sendParams];
    [sendParams setValue:messageItem.content.mid forKey:@"mid"];
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/revoke" method:REQUEST_POST type:REQUEST_REFRESH withParams:sendParams observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        for (MessageItem *item in wself.chatMessageModel.messageArray)
        {
            if([item.content.mid isEqualToString:messageItem.content.mid])
            {
                [item.content setType:UUMessageTypeRevoked];
                [self.chatMessageModel updateMessage:item];
                break;
            }
        }
        [wself.tableView reloadData];
    } fail:^(NSString *errMsg) {
        [ProgressHUD showHintText:errMsg];
    }];
}

- (void)onDeleteMessage:(MessageItem *)messageItem
{
    if([messageItem isLocalMessage]){
        NSInteger row = [self.chatMessageModel.messageArray indexOfObject:messageItem];
        [self.chatMessageModel deleteMessage:messageItem];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    else{
        NSMutableDictionary *sendParams = [self sendParams];
        [sendParams setValue:messageItem.content.mid forKey:@"mid"];
        __weak typeof(self) wself = self;
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:sendParams observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            for (MessageItem *item in wself.chatMessageModel.messageArray)
            {
                if([item.content.mid isEqualToString:messageItem.content.mid])
                {
                    NSInteger row = [wself.chatMessageModel.messageArray indexOfObject:item];
                    [wself.chatMessageModel deleteMessage:item];
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    break;
                }
            }
        } fail:^(NSString *errMsg) {
            [ProgressHUD showHintText:errMsg];
        }];
    }
}

- (void)onResendMessage:(MessageItem *)messageItem
{
    [messageItem setMessageStatus:MessageStatusSending];
    [messageItem setTargetUser:self.name];
    NSInteger row = [self.chatMessageModel.messageArray indexOfObject:messageItem];
    [self.tableView reloadRow:row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
    @weakify(self)
    [messageItem sendWithCommonParams:[self sendParams] progress:^(CGFloat progress) {
        
    } success:^(MessageItem *successMessageItem) {
        @strongify(self)
        [self replaceOriginalMessage:messageItem withSuccessMessage:successMessageItem];
    } fail:^(NSString *errMsg) {
        NSInteger index = [[self.chatMessageModel messageArray] indexOfObject:messageItem];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)onReceiveGift:(MessageItem *)messageItem{
    if(messageItem.content.type == UUMessageTypeGift && messageItem.content.unread && messageItem.from == UUMessageFromOther) {
        //更新已读
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/feed" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"mid" : messageItem.content.mid} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            messageItem.content.unread = 0;
            [self.chatMessageModel updateMessage:messageItem];
            MessageItem *receiveItem = [MessageItem messageItemWithReceiveGift:messageItem.content.exinfo.presentName];
            [self commitMessage:receiveItem];
        } fail:^(NSString *errMsg) {
            
        }];
    }
}

@end

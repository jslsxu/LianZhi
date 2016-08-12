

#import "JSMessagesViewController.h"
#import "ChatExtraGroupInfoVC.h"
#import "ChatExtraIndividualInfoVC.h"
static NSString *topChatID = nil;

@interface JSMessagesViewController ()
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)ChatMessageModel *chatMessageModel;
@property (nonatomic, assign)BOOL isRequestHistory;
@property (nonatomic, assign)BOOL isRequestLatest;
@end

@implementation JSMessagesViewController


#pragma mark - View lifecycle

+ (NSString *)curChatID
{
    return topChatID;
}

- (void)dealloc
{
    topChatID = nil;
}

- (ChatMessageModel *)curChatMessageModel{
    return self.chatMessageModel;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateTitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveGift:) name:ReceiveGiftNotification object:nil];
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(getMessage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetID forKey:@"from_id"];
    [params setValue:kStringFromValue(self.chatType) forKey:@"from_type"];
    @weakify(self);
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/get_sound" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self);
        NSString *status = [responseObject getStringForKey:@"sound"];
        self.soundOn = [status isEqualToString:@"open"];
        [self updateTitle];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    topChatID = self.targetID;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"GroupMemberIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(showChatUserInfo)];
    
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

    [self.chatMessageModel setTargetUser:self.title];
    [self scrollToBottom:NO];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [self.tableView addGestureRecognizer:tapGesture];

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
        [_chatMessageModel setTargetUser:self.title];
    }
    return _chatMessageModel;
}

- (void)setSoundOn:(BOOL)soundOn
{
    _soundOn = soundOn;
    [self.chatMessageModel setSoundOff:!_soundOn];
}

- (void)updateTitle
{
    BOOL earMode = [UserCenter sharedInstance].personalSetting.earPhone;
    BOOL soundOn = self.soundOn;
    if(soundOn && !earMode){
        self.navigationItem.title = self.title;
    }
    else{
        NSInteger maxWidth = self.view.width - 80 * 2;
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 40)];
        NSInteger width = 0;
        NSInteger spaceXEnd = titleView.width;
        UIImageView *soundOffImageView = nil;
        if(!soundOn)
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
        [titleLabel setText:self.title];
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
            if(!soundOn)
                [soundOffImageView setOrigin:CGPointMake(spaceXStart, (titleView.height - soundOffImageView.height) / 2)];
        }
        else
        {
            [titleLabel setFrame:CGRectMake(0, 0, spaceXEnd, titleView.height)];
        }
        
        self.navigationItem.titleView = titleView;
    }
}

- (void)cleatChatRecordCompletion:(ClearChatFinished)finished{
    @weakify(self)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetID forKey:@"to_id"];
    [params setValue:kStringFromValue(self.chatType) forKey:@"to_type"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/clear" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
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
    if(self.chatType == ChatTypeClass || self.chatType == ChatTypeGroup){
        ChatExtraGroupInfoVC *chatExtraInfoVC = [[ChatExtraGroupInfoVC alloc] init];
        [self.navigationController pushViewController:chatExtraInfoVC animated:YES];
    }
    else{
        @weakify(self)
        ChatExtraIndividualInfoVC *chatExtraInfoVC = [[ChatExtraIndividualInfoVC alloc] init];
        [chatExtraInfoVC setUid:self.targetID];
        [chatExtraInfoVC setChatType:self.chatType];
        [chatExtraInfoVC setSoundOn:self.soundOn];
        [chatExtraInfoVC setAlertChangeCallback:^(BOOL soundOn) {
            @strongify(self)
            self.soundOn = soundOn;
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
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    //如果当前没有，去数据库查
    
}

- (void)onTap
{
//    [_inputView setInputType:InputTypeNone];
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
    }
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
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:[UserCenter sharedInstance].curSchool.schoolID forKey:@"objid"];
        [params setValue:self.targetID forKey:@"to_id"];
        [params setValue:kStringFromValue(self.chatType) forKey:@"to_type"];
        if(self.chatType == ChatTypeGroup || self.chatType == ChatTypeClass)
            [params setValue:@"0" forKey:@"to_objid"];
        else
            [params setValue:self.to_objid forKey:@"to_objid"];
        
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[UserCenter sharedInstance].curSchool.schoolID forKey:@"objid"];
    [params setValue:self.targetID forKey:@"to_id"];
    [params setValue:kStringFromValue(self.chatType) forKey:@"to_type"];
    if(self.chatType == ChatTypeGroup || self.chatType == ChatTypeClass)
        [params setValue:@"0" forKey:@"to_objid"];
    else
        [params setValue:self.to_objid forKey:@"to_objid"];
    
    ChatMessageModel *messageModel = [self chatMessageModel];
    [params setValue:messageModel.latestId forKey:@"more_id"];
    [params setValue:kStringFromValue(1) forKey:@"more_new"];
    @weakify(self);
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/get" method:REQUEST_GET type:REQUEST_GETMORE withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self);
        BOOL hasNew = [self.chatMessageModel parseData:responseObject.data type:RequestMessageTypeLatest];
        if(hasNew){
            BOOL shouldScrollToBottom = NO;
            if(self.tableView.contentOffset.y + self.tableView.height > self.tableView.contentSize.height - 160)
                shouldScrollToBottom = YES;
            [self.tableView reloadData];
            if(shouldScrollToBottom)
                [self scrollToBottom:YES];
        }
    } fail:^(NSString *errMsg) {
        
    }];

}
- (void)appendNewMessage:(TNDataWrapper *)response replace:(MessageItem *)messageItem
{
    if(response.count > 0)
    {
        UIImage *image = messageItem.content.exinfo.imgs.image;
        TNDataWrapper *messageItemWrapper = [response getDataWrapperForIndex:0];
        [messageItem modelSetWithJSON:messageItemWrapper.data];
        messageItem.messageStatus = MessageStatusSuccess;
        messageItem.isTmp = NO;
        if(image)
        {
            PhotoItem *photoItem = messageItem.content.exinfo.imgs;
            if(photoItem)
            {
                [[SDImageCache sharedImageCache] storeImage:image forKey:photoItem.small toDisk:YES];
                [[SDImageCache sharedImageCache] storeImage:image forKey:photoItem.big toDisk:YES];
            }
        }
        VideoItem *videoItem = messageItem.content.exinfo.video;
        if(videoItem){
            
        }
        [self.chatMessageModel updateMessage:messageItem];
        NSInteger row = [self.chatMessageModel.messageArray indexOfObject:messageItem];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

//- (void)sendMessageWithText:(NSString *)text{
//    NSMutableDictionary *messageParam = [self sendParams];
//    [messageParam setValue:kStringFromValue(UUMessageTypeText) forKey:@"content_type"];
//    [messageParam setValue:text forKey:@"content"];
//    
//    MessageItem *messageItem = [self createMessageItem];
//    [messageItem.content setType:UUMessageTypeText];
//    [messageItem.content setText:text];
//    
//    MessageItem *preItem = [self.chatMessageModel.messageArray lastObject];
//    if(messageItem.content.ctime - preItem.content.ctime <= 60 * 3)
//        [messageItem.content setHideTime:YES];
//    [self.chatMessageModel sendNewMessage:messageItem];
//    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.chatMessageModel.messageArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//    [self scrollToBottom:YES];
//    
//    
//    [messageParam setValue:messageItem.client_send_id forKey:@"client_send_id"];
//    __weak typeof(self) wself = self;
//    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/send" withParams:messageParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//        [wself appendNewMessage:responseObject replace:messageItem];
//    } fail:^(NSString *errMsg) {
//        messageItem.messageStatus = MessageStatusFailed;
//        [wself.tableView reloadData];
//    }];
//
//}
//
//- (void)sendMessageWithImage:(UIImage *)image{
//    
//}
//
//- (void)sendMessageWithGift:(GiftItem *)giftItem{
//    
//}
//
//- (void)sendMessageWithFace:(NSString *)face{
//    
//}
//
//- (void)sendMessageWithVoice:(NSData *)voiceData time:(NSInteger)voiceDuration{
//    
//}
//
//- (void)sendMessageWithVideo:(VideoItem *)videoItem{
//    
//}

- (NSMutableDictionary *)sendParams{
    NSMutableDictionary *messageParam = [NSMutableDictionary dictionary];
    [messageParam setValue:[UserCenter sharedInstance].curSchool.schoolID forKey:@"objid"];
    if(self.chatType == ChatTypeClass || self.chatType == ChatTypeGroup)
        [messageParam setValue:@"0" forKey:@"to_objid"];
    else
        [messageParam setValue:self.to_objid forKey:@"to_objid"];
    [messageParam setValue:self.targetID forKey:@"to_id"];
    [messageParam setValue:kStringFromValue(self.chatType) forKey:@"to_type"];
    return messageParam;
}

- (MessageItem *)createMessageItem{
    MessageContent *messageContent = [[MessageContent alloc] init];
    [messageContent setCtime:[[NSDate date] timeIntervalSince1970]];
    
    MessageItem *messageItem = [[MessageItem alloc] init];
    [messageItem setTargetUser:self.title];
    [messageItem setMessageStatus:MessageStatusSending];
    [messageItem setIsTmp:YES];
    [messageItem setUser:[UserCenter sharedInstance].userInfo];
    [messageItem setFrom:UUMessageFromMe];
    [messageItem setContent:messageContent];
    [messageItem makeClientSendID];
    return messageItem;
}

- (void)sendMessage:(NSDictionary *)dic
{
    NSMutableDictionary *messageParam = [NSMutableDictionary dictionary];
    [messageParam setValue:[UserCenter sharedInstance].curSchool.schoolID forKey:@"objid"];
    if(self.chatType == ChatTypeClass || self.chatType == ChatTypeGroup)
        [messageParam setValue:@"0" forKey:@"to_objid"];
    else
        [messageParam setValue:self.to_objid forKey:@"to_objid"];
    [messageParam setValue:self.targetID forKey:@"to_id"];
    [messageParam setValue:kStringFromValue(self.chatType) forKey:@"to_type"];
    [messageParam setValue:dic[@"type"] forKey:@"content_type"];
    [messageParam setValue:dic[@"strContent"] forKey:@"content"];
    [messageParam setValue:dic[@"strVoiceTime"] forKey:@"voice_time"];
    [messageParam setValue:dic[@"present_id"] forKey:@"present_id"];
    [messageParam setValue:dic[@"video_time"] forKey:@"video_time"];
    [messageParam setValue:dic[@"im_at"] forKey:@"im_at"];
    MessageType messageType = [dic[@"type"] integerValue];
    UIImage *image = dic[@"picture"];
    NSData *voiceData = dic[@"voice"];
    UIImage* coverImage = dic[@"video_cover"];
    NSString* localVideoPath = dic[@"video"];
    
    MessageContent *messageContent = [[MessageContent alloc] init];
    [messageContent setType:messageType];
    [messageContent setText:dic[@"strContent"]];
    [messageContent setCtime:[[NSDate date] timeIntervalSince1970]];
    
    Exinfo *exinfo = [[Exinfo alloc] init];
    messageContent.exinfo = exinfo;
    if(image)
    {
        PhotoItem *photoItem = [[PhotoItem alloc] init];
        [photoItem setWidth:image.size.width];
        [photoItem setHeight:image.size.height];
        [photoItem setImage:image];
        [exinfo setImgs:photoItem];
    }
    
    if(voiceData)
    {
        NSInteger timeSpan = [dic[@"strVoiceTime"] integerValue];
        AudioItem *audioItem = [[AudioItem alloc] init];
        [audioItem setTimeSpan:timeSpan];
        [exinfo setVoice:audioItem];
    }
    
    if(localVideoPath.length > 0){
        NSInteger videoTime = [dic[@"video_time"] integerValue];
        VideoItem *videoItem = [[VideoItem alloc] init];
        [videoItem setVideoTime:videoTime];
        [videoItem setCoverImage:coverImage];
        [videoItem setLocalVideoPath:localVideoPath];
        [videoItem setCoverWidth:coverImage.size.width];
        [videoItem setCoverHeight:coverImage.size.height];
        [exinfo setVideo:videoItem];
    }
    
    MessageItem *messageItem = [[MessageItem alloc] init];
    [messageItem setTargetUser:self.title];
    messageItem.params = dic;
    [messageItem setMessageStatus:MessageStatusSending];
    [messageItem setIsTmp:YES];
    [messageItem setUser:[UserCenter sharedInstance].userInfo];
    [messageItem setFrom:UUMessageFromMe];
    [messageItem setContent:messageContent];
    [messageItem makeClientSendID];
    
    MessageItem *preItem = [self.chatMessageModel.messageArray lastObject];
    if(messageItem.content.ctime - preItem.content.ctime <= 60 * 3)
        [messageItem.content setHideTime:YES];
    [self.chatMessageModel sendNewMessage:messageItem];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.chatMessageModel.messageArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self scrollToBottom:YES];
    
    
    [messageParam setValue:messageItem.client_send_id forKey:@"client_send_id"];
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/send" withParams:messageParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(messageType == UUMessageTypeVoice)
            [formData appendPartWithFileData:voiceData name:@"file" fileName:@"file" mimeType:@"audio/AMR"];
        else if(messageType == UUMessageTypePicture)
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
        else if(messageType == UUMessageTypeVideo){
            NSString *localVideoPath = dic[@"video"];
            NSData *videoData = [NSData dataWithContentsOfFile:localVideoPath];
            if(videoData){
                [formData appendPartWithFileData:videoData name:@"video" fileName:@"video" mimeType:@"application/octet-stream"];
            }
            if(coverImage){
             [formData appendPartWithFileData:UIImageJPEGRepresentation(coverImage, 0.8) name:@"video_cover" fileName:@"video_cover" mimeType:@"image/jpeg"];
            }
        }
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [wself appendNewMessage:responseObject replace:messageItem];
    } fail:^(NSString *errMsg) {
        messageItem.messageStatus = MessageStatusFailed;
        [wself.tableView reloadData];
    }];
}

- (void)scrollToBottom:(BOOL)animated
{
    NSArray *modelArray = self.chatMessageModel.messageArray;
    if(modelArray.count > 0)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:modelArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
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
    [cell setDelegate:self];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_inputView.inputType != InputTypeNone && scrollView.tracking)
        [_inputView setInputType:InputTypeNone];
    
//    if(scrollView.contentOffset.y < 40){
//        if(!self.isRequestHistory){
//            self.isRequestHistory = YES;
//            [self requestOldMessage];
//        }
//    }
}

#pragma mark - InputDelegate
- (void)inputBarViewDidCommit:(NSString *)text atArray:(NSArray *)atArray
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:text forKey:@"strContent"];
    [params setValue:@(UUMessageTypeText) forKey:@"type"];
    if(atArray.count > 0){
        NSMutableArray *atList = [NSMutableArray array];
        for (UserInfo *userInfo in atArray) {
            NSString *type;
            if([userInfo isKindOfClass:[TeacherInfo class]]){
                type = @"t";
            }
            else{
                type = @"p";
            }
            [atList addObject:@{@"type" : type, @"uid" : userInfo.uid}];
        }
        
        [params setValue:[NSString stringWithJSONObject:atList] forKey:@"im_at"];
    }
    [self dealTheFunctionData:params];
}

- (void)inputBarViewDidChangeHeight:(NSInteger)height
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView setHeight:self.view.height - height];
        [_inputView setFrame:CGRectMake(0, self.view.height - height, self.view.width, height)];
    } completion:^(BOOL finished) {
        
    }];
    [self scrollToBottom:YES];
}

- (void)inputBarViewDidFaceSelect:(NSString *)face
{
    NSDictionary *dic = @{@"strContent": face,
                          @"type": @(UUMessageTypeFace)};
    [self dealTheFunctionData:dic];
}

- (void)inputBarViewDidSendPhoto:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)inputBarViewDidSendPhotoArray:(NSArray *)photoArry
{
    for (UIImage *image in photoArry)
    {
        [self inputBarViewDidSendPhoto:image];
    }
}

- (void)inputBarViewDidSendVoice:(NSData *)amrData time:(NSInteger)time
{
    if(time < 2)
    {
        [ProgressHUD showHintText:@"录音时间太短，请重新录制"];
    }
    else
    {
        NSDictionary *dic = @{@"voice": amrData,
                              @"strVoiceTime": kStringFromValue(time),
                              @"type": @(UUMessageTypeVoice)};
        [self dealTheFunctionData:dic];
    }
}

- (void)inputBarViewDidSendGift:(GiftItem *)giftItem
{
    NSDictionary *dic = @{@"present_id" : giftItem.giftID,
                          @"type" : @(UUMessageTypeGift),
                          @"strContent" : self.title};
    [self dealTheFunctionData:dic];
}

- (void)inputBarViewDidSendVideo:(VideoItem *)videoItem{
    NSDictionary *dic = @{@"type" : @(UUMessageTypeVideo),
                          @"video" : videoItem.localVideoPath,
                          @"video_time" : @(videoItem.videoTime),
                          @"video_cover" : videoItem.coverImage};
    [self dealTheFunctionData:dic];
}

- (void)inputBarViewDidCallTelephone{
    if(self.mobile.length > 0)
    {
        TNButtonItem *cancelItem = [TNButtonItem itemWithTitle:@"取消" action:nil];
        TNButtonItem *item = [TNButtonItem itemWithTitle:@"拨打" action:^{
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",self.mobile];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:[NSString stringWithFormat:@"是否拨打电话%@",self.mobile] buttonItems:@[cancelItem,item]];
        [alertView show];
    }
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self sendMessage:dic];
}

#pragma mark - MessageCellDelegate
- (void)onRevokeMessage:(MessageItem *)messageItem
{
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/revoke" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"mid" : messageItem.content.mid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        for (MessageItem *item in wself.chatMessageModel.messageArray)
        {
            if([item.content.mid isEqualToString:messageItem.content.mid])
                [item.content setType:UUMessageTypeRevoked];
        }
        [wself.tableView reloadData];
    } fail:^(NSString *errMsg) {
        [ProgressHUD showHintText:errMsg];
    }];
}

- (void)onDeleteMessage:(MessageItem *)messageItem
{
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"mid" : messageItem.content.mid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
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

- (void)onResendMessage:(MessageItem *)messageItem
{
#warning todo重发
//    NSDictionary *dic = messageItem.params;
//    NSMutableDictionary *messageParam = [NSMutableDictionary dictionary];
//    [messageParam setValue:[UserCenter sharedInstance].curSchool.schoolID forKey:@"objid"];
//    if(self.chatType == ChatTypeClass || self.chatType == ChatTypeGroup)
//        [messageParam setValue:@"0" forKey:@"to_objid"];
//    else
//        [messageParam setValue:self.to_objid forKey:@"to_objid"];
//    [messageParam setValue:self.targetID forKey:@"to_id"];
//    [messageParam setValue:kStringFromValue(self.chatType) forKey:@"to_type"];
//    [messageParam setValue:dic[@"type"] forKey:@"content_type"];
//    [messageParam setValue:dic[@"strContent"] forKey:@"content"];
//    [messageParam setValue:dic[@"strVoiceTime"] forKey:@"voice_time"];
//    [messageParam setValue:dic[@"present_id"] forKey:@"present_id"];
//    MessageType messageType = [dic[@"type"] integerValue];
//    UIImage *image = dic[@"picture"];
//    NSData *voiceData = dic[@"voice"];
//    
//    [messageParam setValue:messageItem.client_send_id forKey:@"client_send_id"];
//    __weak typeof(self) wself = self;
//    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/send" withParams:messageParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        if(messageType == UUMessageTypeVoice)
//            [formData appendPartWithFileData:voiceData name:@"file" fileName:@"file" mimeType:@"audio/AMR"];
//        else if(messageType == UUMessageTypePicture)
//            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
//    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//        [wself appendNewMessage:responseObject replace:messageItem];
//    } fail:^(NSString *errMsg) {
//        messageItem.messageStatus = MessageStatusFailed;
//        [wself.tableView reloadData];
//    }];
}

- (void)onReceiveGift:(NSNotification *)notification {
    MessageItem *messageItem = notification.userInfo[ReceiveGiftMessageKey];
    if(messageItem.content.type == UUMessageTypeGift && messageItem.content.unread && messageItem.from == UUMessageFromOther) {
        NSDictionary *dic = @{@"strContent": messageItem.content.exinfo.presentName,
                              @"type": @(UUMessageTypeReceiveGift)};
        [self sendMessage:dic];
        //更新已读
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/read" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"mids" : messageItem.content.mid} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            messageItem.content.unread = 0;
            [self.chatMessageModel updateMessage:messageItem];
            [self.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    }
}

@end
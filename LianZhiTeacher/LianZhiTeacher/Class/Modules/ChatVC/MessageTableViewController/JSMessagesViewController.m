

#import "JSMessagesViewController.h"
#import "ClassMemberVC.h"

static NSString *topChatID = nil;
static NSInteger num = 1;

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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    if(self.chatType == ChatTypeClass || self.chatType == ChatTypeGroup)//群组或者班级
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"GroupMemberIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(onShowClassMembers)];
    }
    else
    {
        if(self.mobile.length > 0)
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CallMobile"] style:UIBarButtonItemStylePlain target:self action:@selector(onTelephoneClicked)];
    }
    
    _inputView = [[InputBarView alloc] init];
    [_inputView setCanSendGift:self.chatType == ChatTypeParents || self.chatType == ChatTypeTeacher];
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
    }
    return _chatMessageModel;
}

- (void)send
{
    [self inputBarViewDidCommit:kStringFromValue(num)];
    num++;
    if(num >= 30)
        [_testTimer invalidate];
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
        return;
    }
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

- (void)onShowClassMembers
{
    ClassMemberVC *classMemberVC = [[ClassMemberVC alloc] init];
    [classMemberVC setShowSound:YES];
    if(self.chatType == ChatTypeClass)
        [classMemberVC setClassID:self.targetID];
    else if(self.chatType == ChatTypeGroup)
        [classMemberVC setGroupID:self.targetID];
    [classMemberVC setTitle:self.title];
    [self.navigationController pushViewController:classMemberVC animated:YES];
}

- (void)onTelephoneClicked
{
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
    if([self.chatMessageModel loadOldData]){
        [self.tableView reloadData];
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
        [self.chatMessageModel parseData:responseObject.data type:RequestMessageTypeLatest];
        [self.tableView reloadData];
    } fail:^(NSString *errMsg) {
        
    }];

}
- (void)appendNewMessage:(TNDataWrapper *)response replace:(MessageItem *)messageItem
{
    if(response.count > 0)
    {
        UIImage *image = messageItem.content.exinfo.imgs.image;
        TNDataWrapper *messageItemWrapper = [response getDataWrapperForIndex:0];
        MessageItem *resultItem = [MessageItem nh_modelWithJson:messageItemWrapper.data];
        resultItem.messageStatus = MessageStatusSuccess;
        if(image)
        {
            PhotoItem *photoItem = messageItem.content.exinfo.imgs;
            if(photoItem)
            {
                [[SDImageCache sharedImageCache] storeImage:image forKey:photoItem.small toDisk:YES];
                [[SDImageCache sharedImageCache] storeImage:image forKey:photoItem.big toDisk:YES];
            }
        }
        [self.chatMessageModel updateMessage:resultItem];
        NSInteger row = [self.chatMessageModel.messageArray indexOfObject:resultItem];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
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
    MessageType messageType = [dic[@"type"] integerValue];
    UIImage *image = dic[@"picture"];
    NSData *voiceData = dic[@"voice"];
    
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
    [self.tableView reloadData];
    [self scrollToBottom:YES];
    
    
    [messageParam setValue:messageItem.client_send_id forKey:@"client_send_id"];
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/send" withParams:messageParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(messageType == UUMessageTypeVoice)
            [formData appendPartWithFileData:voiceData name:@"file" fileName:@"file" mimeType:@"audio/AMR"];
        else if(messageType == UUMessageTypePicture)
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
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
    return [messageItem cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(!cell){
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    [cell setDelegate:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *messageCell = (MessageCell *)cell;
    [messageCell setData:[[self chatMessageModel].messageArray objectAtIndex:indexPath.row]];
}

- (void)TNBaseTableViewControllerRequestSuccess
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ChatMessageModel *messageModel = (ChatMessageModel *)self.chatMessageModel;
        NSArray *visibleCells = [self.tableView visibleCells];
        UITableViewCell *cell = [visibleCells lastObject];
        NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
        BOOL scroll = indexpath.row >= messageModel.messageArray.count - messageModel.numOfNew - 1;
        if(messageModel.hasNew && messageModel.messageArray.count >= 1 && (scroll || messageModel.needScrollBottom))
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageModel.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_inputView.inputType != InputTypeNone && scrollView.dragging)
        [_inputView setInputType:InputTypeNone];
    
//    if(scrollView.contentOffset.y < 40){
//        if(!self.isRequestHistory){
//            self.isRequestHistory = YES;
//            [self requestOldMessage];
//        }
//    }
}

#pragma mark - InputDelegate
- (void)inputBarViewDidCommit:(NSString *)text
{
    NSDictionary *dic = @{@"strContent": text,
                          @"type": @(UUMessageTypeText)};
    [self dealTheFunctionData:dic];
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
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
                break;
            }
        }
    } fail:^(NSString *errMsg) {
        [ProgressHUD showHintText:errMsg];
    }];
}

- (void)onResendMessage:(MessageItem *)messageItem
{
    NSDictionary *dic = messageItem.params;
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
    MessageType messageType = [dic[@"type"] integerValue];
    UIImage *image = dic[@"picture"];
    NSData *voiceData = dic[@"voice"];
    
    [messageParam setValue:messageItem.client_send_id forKey:@"client_send_id"];
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/send" withParams:messageParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(messageType == UUMessageTypeVoice)
            [formData appendPartWithFileData:voiceData name:@"file" fileName:@"file" mimeType:@"audio/AMR"];
        else if(messageType == UUMessageTypePicture)
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [wself appendNewMessage:responseObject replace:messageItem];
    } fail:^(NSString *errMsg) {
        messageItem.messageStatus = MessageStatusFailed;
        [wself.tableView reloadData];
    }];
}

- (void)onReceiveGift:(MessageItem *)messageItem {
    if(messageItem.content.type == UUMessageTypeGift && messageItem.content.unread && messageItem.from == UUMessageFromOther) {
        NSDictionary *dic = @{@"strContent": messageItem.content.exinfo.presentName,
                              @"type": @(UUMessageTypeReceiveGift)};
        [self sendMessage:dic];
        //更新已读
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/read" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"mids" : messageItem.content.mid} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            messageItem.content.unread = 0;
        } fail:^(NSString *errMsg) {
            
        }];
    }
}

@end
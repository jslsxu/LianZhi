

#import "JSMessagesViewController.h"
#import "ClassMemberVC.h"

static NSString *topChatID = nil;
static NSInteger num = 1;

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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    Reachability* curReach = ApplicationDelegate.hostReach;
    NetworkStatus status = [curReach currentReachabilityStatus];
    if(status == NotReachable)
        [self updateTitle];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getMessage) userInfo:nil repeats:YES];
    [_timer fire];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetID forKey:@"from_id"];
    [params setValue:kStringFromValue(self.chatType) forKey:@"from_type"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/get_sound" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        NSString *status = [responseObject getStringForKey:@"sound"];
        self.soundOn = [status isEqualToString:@"open"];
        [self updateTitle];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitle) name:kReachabilityChangedNotification object:nil];
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
    [self setSupportPullDown:YES];
    [self.tableView setHeight:self.view.height - _inputView.height];
    [self bindTableCell:@"MessageCell" tableModel:@"ChatMessageModel"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [_tableView addGestureRecognizer:tapGesture];
    
//    _testTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(send) userInfo:nil repeats:YES];
//    _testTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(send) userInfo:nil repeats:YES];
//    [_testTimer fire];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ApplicationDelegate.homeVC selectAtIndex:0];
    });
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
    ChatMessageModel *messageModel = (ChatMessageModel *)self.tableViewModel;
    [messageModel setSoundOff:!_soundOn];
}

- (void)updateTitle
{
    NSString *title = nil;
    Reachability* curReach = ApplicationDelegate.hostReach;
    NetworkStatus status = [curReach currentReachabilityStatus];
    if(status == NotReachable)
    {
        title = @"网络不可用";
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:title];
        [titleLabel sizeToFit];
        [self.navigationItem setTitleView:titleLabel];
    }
    else
    {
        BOOL earMode = [UserCenter sharedInstance].personalSetting.earPhone;
        BOOL soundOn = self.soundOn;
        
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
        [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [titleLabel setTextColor:[UIColor whiteColor]];
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

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"sms/get"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[UserCenter sharedInstance].curSchool.schoolID forKey:@"objid"];
    [params setValue:self.targetID forKey:@"to_id"];
    [params setValue:kStringFromValue(self.chatType) forKey:@"to_type"];
    if(self.chatType == ChatTypeGroup || self.chatType == ChatTypeClass)
        [params setValue:@"0" forKey:@"to_objid"];
    else
        [params setValue:self.to_objid forKey:@"to_objid"];
    
    ChatMessageModel *messageModel = (ChatMessageModel *)[self tableViewModel];
    if(REQUEST_GETMORE == requestType)
    {
        [params setValue:messageModel.latestId forKey:@"more_id"];
        [params setValue:kStringFromValue(1) forKey:@"more_new"];
    }
    else
    {
        [params setValue:messageModel.oldId forKey:@"more_id"];
        [params setValue:kStringFromValue(0) forKey:@"more_new"];
    }
    [task setParams:params];
    return task;
}

- (BOOL)needReload
{
    ChatMessageModel *messageModel = (ChatMessageModel *)self.tableViewModel;
    return messageModel.hasNew || messageModel.getHistory;
}

- (void)getMessage
{
    if(ApplicationDelegate.logouted)
    {
        [_timer invalidate];
        _timer = nil;
    }
    else
        [self requestData:REQUEST_GETMORE];
}


- (void)appendNewMessage:(TNDataWrapper *)response replace:(MessageItem *)messageItem
{
    if(response.count > 0)
    {
        UIImage *image = messageItem.messageContent.photoItem.image;
        TNDataWrapper *messageItemWrapper = [response getDataWrapperForIndex:0];
        [messageItem parseData:messageItemWrapper];
        messageItem.messageStatus = MessageStatusSuccess;
        if(image)
        {
            PhotoItem *photoItem = messageItem.messageContent.photoItem;
            if(photoItem)
            {
                [[SDImageCache sharedImageCache] storeImage:image forKey:photoItem.thumbnailUrl toDisk:YES];
                [[SDImageCache sharedImageCache] storeImage:image forKey:photoItem.originalUrl toDisk:YES];
            }
        }
        messageItem.isTmp = NO;
        BOOL hideTime = NO;
        for (MessageItem *item in self.tableViewModel.modelItemArray)
        {
            if(item != messageItem &&!item.isTmp && [item.messageContent.ctime isEqualToString:messageItem.messageContent.ctime])
                hideTime = YES;
        }
        [messageItem.messageContent setHideTime:hideTime];
        [self.tableView reloadData];
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
    [messageParam setValue:dic[@"giftID"] forKey:@"present_id"];
    MessageType messageType = [dic[@"type"] integerValue];
    UIImage *image = dic[@"picture"];
    NSData *voiceData = dic[@"voice"];
    
    MessageContent *messageContent = [[MessageContent alloc] init];
    [messageContent setMessageType:messageType];
    [messageContent setText:dic[@"strContent"]];
    [messageContent setTimeInterval:[[NSDate date] timeIntervalSince1970]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    messageContent.ctime = [formatter stringFromDate:[NSDate date]];
    
    if(image)
    {
        PhotoItem *photoItem = [[PhotoItem alloc] init];
        [photoItem setWidth:image.size.width];
        [photoItem setHeight:image.size.height];
        [photoItem setImage:image];
        [messageContent setPhotoItem:photoItem];
    }
    
    if(voiceData)
    {
        NSInteger timeSpan = [dic[@"strVoiceTime"] integerValue];
        AudioItem *audioItem = [[AudioItem alloc] init];
        [audioItem setTimeSpan:timeSpan];
        [messageContent setAudioItem:audioItem];
    }
    
    MessageItem *messageItem = [[MessageItem alloc] init];
    messageItem.params = dic;
    [messageItem setMessageStatus:MessageStatusSending];
    [messageItem setIsTmp:YES];
    [messageItem setUserInfo:[UserCenter sharedInstance].userInfo];
    [messageItem setFrom:UUMessageFromMe];
    [messageItem setMessageContent:messageContent];
    
    MessageItem *preItem = [self.tableViewModel.modelItemArray lastObject];
    if([messageItem.messageContent.ctime isEqualToString:preItem.messageContent.ctime])
        [messageItem.messageContent setHideTime:YES];
    [self.tableViewModel.modelItemArray addObject:messageItem];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.tableViewModel.modelItemArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_inputView.inputType != InputTypeNone && scrollView.dragging)
        [_inputView setInputType:InputTypeNone];
}

- (void)scrollToBottom
{
    NSArray *modelArray = self.tableViewModel.modelItemArray;
    if(modelArray.count > 0)
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:modelArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = (MessageCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell setDelegate:self];
    return cell;
}

- (void)TNBaseTableViewControllerRequestSuccess
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ChatMessageModel *messageModel = (ChatMessageModel *)self.tableViewModel;
        NSArray *visibleCells = [_tableView visibleCells];
        UITableViewCell *cell = [visibleCells lastObject];
        NSIndexPath *indexpath = [_tableView indexPathForCell:cell];
        BOOL scroll = indexpath.row >= messageModel.modelItemArray.count - messageModel.numOfNew - 1;
        if(messageModel.hasNew && messageModel.modelItemArray.count >= 1 && (scroll || messageModel.needScrollBottom))
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageModel.modelItemArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    });
}

- (BOOL)hideErrorAlert
{
    return YES;
}


//#pragma mark - TNBaseTableViewDelegate
//- (BOOL)supportCache
//{
//    return YES;
//}
//
//- (NSString *)cacheFileName
//{
//    return [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@",[self class],self.targetID,kStringFromValue(self.chatType),self.to_objid,[UserCenter sharedInstance].curSchool.schoolID,[UserCenter sharedInstance].userInfo.uid];
//}

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
        [_tableView setHeight:self.view.height - height];
        [_inputView setFrame:CGRectMake(0, self.view.height - height, self.view.width, height)];
    } completion:^(BOOL finished) {
        [self scrollToBottom];
    }];
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

- (void)inputBarViewDidSendGift:(NSString *)giftID
{
//    if(giftID)
//    {
//        NSDictionary *dic = @{@"giftID" : giftID, @"type" : @(UUMessageTypeGift)};
//        [self dealTheFunctionData:dic];
//    }
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self sendMessage:dic];
    [_tableView reloadData];
    [self scrollToBottom];
}

#pragma mark - MessageCellDelegate
- (void)onRevokeMessage:(MessageItem *)messageItem
{
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/revoke" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"mid" : messageItem.messageContent.mid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        for (MessageItem *item in wself.tableViewModel.modelItemArray)
        {
            if([item.messageContent.mid isEqualToString:messageItem.messageContent.mid])
                [item.messageContent setMessageType:UUMessageTypeRevoked];
        }
        [wself.tableView reloadData];
    } fail:^(NSString *errMsg) {
        [ProgressHUD showHintText:errMsg];
    }];
}

- (void)onDeleteMessage:(MessageItem *)messageItem
{
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/del" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"mid" : messageItem.messageContent.mid} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        for (MessageItem *item in wself.tableViewModel.modelItemArray)
        {
            if([item.messageContent.mid isEqualToString:messageItem.messageContent.mid])
            {
                [wself.tableViewModel.modelItemArray removeObject:item];
                [wself.tableView reloadData];
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

@end
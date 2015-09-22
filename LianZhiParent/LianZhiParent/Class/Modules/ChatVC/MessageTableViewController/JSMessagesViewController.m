

#import "JSMessagesViewController.h"
@implementation JSMessagesViewController


#pragma mark - View lifecycle

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(getMessage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.name;
    _inputView = [[InputBarView alloc] init];
    [_inputView setInputDelegate:self];
    [_inputView setY:self.view.height - _inputView.height - 64];
    [self.view addSubview:_inputView];
    [self setSupportPullDown:YES];
    [self.tableView setHeight:self.view.height - _inputView.height];
    [self bindTableCell:@"MessageCell" tableModel:@"ChatMessageModel"];
    
    [self requestData:REQUEST_GETMORE];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"sms/get"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetID forKey:@"to_id"];
    [params setValue:kStringFromValue(self.chatType) forKey:@"to_type"];
    
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

- (void)getMessage
{
    [self requestData:REQUEST_GETMORE];
}


- (void)appendNewMessage:(TNDataWrapper *)response
{
    if(response.count > 0)
    {
        ChatMessageModel *model = (ChatMessageModel *)self.tableViewModel;
        for (NSInteger i = 0; i < response.count; i++)
        {
            TNDataWrapper *messageItemWrapper = [response getDataWrapperForIndex:i];
            MessageItem *mesageItem = [[MessageItem alloc] init];
            [mesageItem parseData:messageItemWrapper];
            if([model canInsert:mesageItem])
                [model.modelItemArray addObject:mesageItem];
        }
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.tableViewModel.modelItemArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)sendMessage:(NSDictionary *)dic
{
    NSMutableDictionary *messageParam = [NSMutableDictionary dictionary];
    [messageParam setValue:[UserCenter sharedInstance].curChild.uid forKey:@"objid"];
    [messageParam setValue:self.to_objid forKey:@"to_objid"];
    [messageParam setValue:self.targetID forKey:@"to_id"];
    [messageParam setValue:kStringFromValue(self.chatType) forKey:@"to_type"];
    [messageParam setValue:dic[@"type"] forKey:@"content_type"];
    [messageParam setValue:dic[@"strContent"] forKey:@"content"];
    [messageParam setValue:dic[@"strVoiceTime"] forKey:@"voice_time"];
    
    MessageType messageType = [dic[@"type"] integerValue];
    UIImage *image = dic[@"picture"];
    NSData *voiceData = dic[@"voice"];
    __weak typeof(self) wself = self;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/send" withParams:messageParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(messageType == UUMessageTypeVoice)
            [formData appendPartWithFileData:voiceData name:@"file" fileName:@"file" mimeType:@"audio/AMR"];
        else if(messageType == UUMessageTypePicture)
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [wself appendNewMessage:responseObject];
    } fail:^(NSString *errMsg) {
        
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
    if(modelArray.count > 0 && modelArray.count <= [_tableView numberOfRowsInSection:0])
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:modelArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
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
        [_tableView setHeight:self.view.height - height];
        [_inputView setFrame:CGRectMake(0, self.view.height - height, self.view.width, height)];
        [self scrollToBottom];
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

- (void)inputBarViewDidSendVoice:(NSData *)amrData time:(NSInteger)time
{
    if(time < 2)
    {
        [ProgressHUD showHintText:@"录入语音时间过短，请重新录制"];
    }
    else
    {
        NSDictionary *dic = @{@"voice": amrData,
                              @"strVoiceTime": [NSString stringWithFormat:@"%ld",(long)time],
                              @"type": @(UUMessageTypeVoice)};
        [self dealTheFunctionData:dic];
    }
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self sendMessage:dic];
    [_tableView reloadData];
    [self scrollToBottom];
}

@end
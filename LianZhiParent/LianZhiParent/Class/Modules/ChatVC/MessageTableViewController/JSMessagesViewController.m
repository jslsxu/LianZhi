

#import "JSMessagesViewController.h"
#import "ClassMemberVC.h"
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
    [_timer fire];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.chatType == ChatTypeClass || self.chatType == ChatTypeGroup)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MineProfile"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickClassMember)];
    }
    else
    {
        if(self.mobile.length > 0)
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CallMobile"] style:UIBarButtonItemStylePlain target:self action:@selector(onTelephoneClicked)];
    }
    
    _inputView = [[InputBarView alloc] init];
    [_inputView setInputDelegate:self];
    [_inputView setY:self.view.height - _inputView.height - 64];
    [self.view addSubview:_inputView];
    [self setSupportPullDown:YES];
    [self.tableView setHeight:self.view.height - _inputView.height];
    [self bindTableCell:@"MessageCell" tableModel:@"ChatMessageModel"];
    
    [self requestData:REQUEST_GETMORE];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    [_tableView addGestureRecognizer:tapGesture];
}

- (void)onTap
{
    [_inputView setInputType:InputTypeNone];
}

- (void)onClickClassMember
{
    ClassMemberVC *classMemberVC = [[ClassMemberVC alloc] init];
    [classMemberVC setClassID:self.targetID];
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

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"sms/get"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.targetID forKey:@"to_id"];
    [params setValue:self.to_objid forKey:@"to_objid"];
    [params setValue:[UserCenter sharedInstance].curChild.uid forKey:@"objid"];
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
    if(ApplicationDelegate.logouted)
    {
        [_timer invalidate];
        _timer = nil;
    }
    else
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
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:modelArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


- (void)TNBaseTableViewControllerRequestSuccess
{
    ChatMessageModel *messageModel = (ChatMessageModel *)self.tableViewModel;
    if(messageModel.hasNew)
        [self scrollToBottom];
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
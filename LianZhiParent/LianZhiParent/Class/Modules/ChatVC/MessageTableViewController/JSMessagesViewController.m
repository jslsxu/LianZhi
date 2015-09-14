

#import "JSMessagesViewController.h"
#import "UUMessageCell.h"
@implementation JSMessagesViewController


#pragma mark - View lifecycle

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _chatModel = [[ChatModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"成员" style:UIBarButtonItemStylePlain target:self action:@selector(onShowMember)];
    self.title = self.name;
    _inputView = [[InputBarView alloc] init];
    [_inputView setInputDelegate:self];
    [_inputView setY:self.view.height - _inputView.height - 64];
    [self.view addSubview:_inputView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, _inputView.y) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

- (void)onShowMember
{
    ClassMemberVC *memberVC = [[ClassMemberVC alloc] init];
    [CurrentROOTNavigationVC pushViewController:memberVC animated:YES];
}

//加载之前的
- (void)loadPrevious
{
    if(!_isLoading)
    {
        _isLoading = YES;
        UUMessageFrame *firstMessage = [_chatModel.dataSource firstObject];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/get" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"uid":self.userID,@"to_type":@"1",@"more_id":firstMessage.message.strId} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            _isLoading = NO;
        } fail:^(NSString *errMsg) {
            _isLoading = NO;
        }];
    }
}

//加载最新的
- (void)loadLate
{
    if(!_isLoading)
    {
        _isLoading = YES;
        UUMessageFrame *firstMessage = [_chatModel.dataSource firstObject];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/get" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"uid":self.userID,@"to_type":@"1",@"more_id":firstMessage.message.strId} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            _isLoading = NO;
        } fail:^(NSString *errMsg) {
            _isLoading = NO;
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_inputView.inputType != InputTypeNone && scrollView.dragging)
        [_inputView setInputType:InputTypeNone];
}

- (void)scrollToBottom
{
    if(_chatModel.dataSource.count == 0)
        return;
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_chatModel.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chatModel.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_chatModel.dataSource[indexPath.row] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"UUMessageCell";
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil)
    {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    UUMessageFrame *messageInfo = _chatModel.dataSource[indexPath.row];
    [cell setMessageFrame:messageInfo];
    return cell;
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

- (void)inputBarViewDidSendVoice:(NSData *)amrData
{
    NSDictionary *dic = @{@"voice": amrData,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)2],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [_chatModel addSpecifiedItem:dic];
    [_tableView reloadData];
    [self scrollToBottom];
}

@end
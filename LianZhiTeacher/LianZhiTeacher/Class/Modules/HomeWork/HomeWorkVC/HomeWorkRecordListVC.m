//
//  HomeWorkRecordListVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeWorkRecordListVC.h"
#import "PublishHomeWorkVC.h"
#import "HomeworkDraftManager.h"
#import "HomeworkDetailVC.h"
#import "ContactsLoadingView.h"
@implementation HomeworkSendingItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSize:CGSizeMake(kScreenWidth, 70)];
        [self setBackgroundColor:[UIColor whiteColor]];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.contentView addSubview:_titleLabel];
        
        _audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_audio"]];
        [self.contentView addSubview:_audioImageView];
        
        _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_photo"]];
        [self.contentView addSubview:_photoImageView];
        
        _progressView = [[CircleProgressView alloc] initWithRadius:10];
        [_progressView setOrigin:CGPointMake(self.width - 12 - _progressView.width, 12)];
        [self.contentView addSubview:_progressView];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"28c4d8"] forState:UIControlStateNormal];
        [_cancelButton setImage:[UIImage imageNamed:@"send_cancel"] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton sizeToFit];
        [_cancelButton setSize:CGSizeMake(_cancelButton.width  +10, _cancelButton.height  + 4)];
        [_cancelButton setOrigin:CGPointMake(self.width - 10 - _cancelButton.width, 70 - 10 - _cancelButton.height)];
        [_cancelButton addTarget:self action:@selector(onCancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelButton];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self.contentView addSubview:_sepLine];
        
    }
    return self;
}

- (void)setSendEntity:(HomeWorkEntity *)sendEntity{
    _sendEntity = sendEntity;
    [_titleLabel setFrame:CGRectMake(12, 15, _progressView.left - 5 - 12, 20)];
    if([_sendEntity.words length] > 0){
        [_titleLabel setText:_sendEntity.words];
    }
    else{
        [_titleLabel setText:@"作业练习"];
    }
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
    [_progressView setFProgress:_sendEntity.uploadProgress];
    [RACObserve(_sendEntity, uploadProgress) subscribeNext:^(id x) {
        [_progressView setFProgress:_sendEntity.uploadProgress];
    }];
    [_audioImageView setHidden:!_sendEntity.hasAudio];
    [_photoImageView setHidden:!_sendEntity.hasImage];
    CGFloat spaceXStart = 20;
    CGFloat centerY = 50;
    if(_sendEntity.hasAudio){
        [_audioImageView setCenter:CGPointMake(spaceXStart, centerY)];
        spaceXStart += _audioImageView.width + 15;
    }
    if(_sendEntity.hasImage){
        [_photoImageView setCenter:CGPointMake(spaceXStart, centerY)];
        spaceXStart += _photoImageView.width + 15;
    }
}

- (void)onCancelClicked{
    if(self.cancelCallback){
        self.cancelCallback();
    }
}

@end

@implementation HomeworkRecordItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSize:CGSizeMake(kScreenWidth, 70)];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        [_redDot setOrigin:CGPointMake(4, 25 - 2)];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"E00909"]];
        [_redDot.layer setCornerRadius:2];
        [_redDot.layer setMasksToBounds:YES];
        [_redDot setHidden:YES];
        [self.contentView addSubview:_redDot];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [self.contentView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self.contentView addSubview:_timeLabel];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_stateLabel setFont:[UIFont systemFontOfSize:12]];
        [_stateLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self.contentView addSubview:_stateLabel];
        
        _audioImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_audio"]];
        [self.contentView addSubview:_audioImageView];
        
        _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_photo"]];
        [self.contentView addSubview:_photoImageView];
        
//        _delayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification_delay"]];
//        [self.contentView addSubview:_delayImageView];
        
        
        
//        _revokeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_revokeButton setImage:[UIImage imageNamed:@"notification_revoke"] forState:UIControlStateNormal];
//        [_revokeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [_revokeButton setTitleColor:[UIColor colorWithHexString:@"28c4d8"] forState:UIControlStateNormal];
//        [_revokeButton setTitle:@"撤销" forState:UIControlStateNormal];
//        [_revokeButton sizeToFit];
//        [_revokeButton setSize:CGSizeMake(_revokeButton.width + 10, _revokeButton.height + 4)];
//        [_revokeButton addTarget:self action:@selector(onRevoke) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_revokeButton];
        
        _replyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"canReply"]];
        [_replyImageView setHidden:YES];
        [self.contentView addSubview:_replyImageView];
        
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self.contentView addSubview:_sepLine];
    }
    return self;
}


- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    [_redDot setHidden:!_homeworkItem.unread];
    CGFloat spaceXEnd = self.width - 10;
    //    if(_notificationItem.is_sent){
    [_delayImageView setHidden:YES];
    [_timeLabel setHidden:NO];
    [_stateLabel setHidden:NO];
    [_revokeButton setHidden:YES];
    [_replyImageView setHidden:YES];
    [_timeLabel setText:_homeworkItem.ctime];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(spaceXEnd - _timeLabel.width, 15)];
    spaceXEnd = spaceXEnd - _timeLabel.width - 10;
    
    NSMutableAttributedString *stateStr = [[NSMutableAttributedString alloc] initWithString:@"发送:"];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_homeworkItem.publish_num) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
    if(_homeworkItem.etype){
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人 回复:" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_homeworkItem.reply_num) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人 批阅:" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_homeworkItem.marking_num) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
    }
    else{
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人 已读:" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_homeworkItem.read_num) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
    }
    [_stateLabel setAttributedText:stateStr];
    [_stateLabel sizeToFit];
    [_stateLabel setOrigin:CGPointMake(self.width - 10 - _stateLabel.width, self.height - 15 - _stateLabel.height)];
    //    }
    //    else{
    //        [_delayImageView setHidden:NO];
    //        [_stateLabel setHidden:YES];
    //        [_revokeButton setHidden:NO];
    //        [_revokeButton setOrigin:CGPointMake(spaceXEnd - _revokeButton.width, self.height - 13 - _revokeButton.height)];
    //        [_delayImageView setOrigin:CGPointMake(spaceXEnd - _delayImageView.width, 18)];
    //        spaceXEnd = spaceXEnd - _delayImageView.width - 10;
    //        [_timeLabel setHidden:YES];
    //    }
    [_titleLabel setFrame:CGRectMake(12, 15, spaceXEnd - 12, 20)];
    [_titleLabel setText:_homeworkItem.words];
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
    
    [_audioImageView setHidden:!_homeworkItem.hasAudio];
    [_photoImageView setHidden:!_homeworkItem.hasImage];
    CGFloat spaceXStart = 12;
    CGFloat centerY = 50;
    if(_homeworkItem.hasAudio){
        [_audioImageView setCenter:CGPointMake(spaceXStart + _audioImageView.width / 2, centerY)];
        spaceXStart = _audioImageView.right + 15;
    }
    if(_homeworkItem.hasImage){
        [_photoImageView setCenter:CGPointMake(spaceXStart + _photoImageView.width / 2, centerY)];
        spaceXStart = _photoImageView.right + 15;
    }
    
    if(_homeworkItem.etype){
        [_replyImageView setHidden:NO];
        [_replyImageView setCenter:CGPointMake(spaceXStart + _replyImageView.width / 2, centerY)];
    }
}

- (void)onRevoke{
    if(self.revokeCallback){
        self.revokeCallback();
    }
}


@end


@interface HomeWorkRecordListVC ()
@end

@implementation MySendHomeworkListModel

- (BOOL)hasMoreData{
    return self.has;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type{
//    self.total = [data getIntegerForKey:@"total"];
    if(type == REQUEST_REFRESH){
        [self.modelItemArray removeAllObjects];
    }
    TNDataWrapper *moreWrapper = [data getDataWrapperForKey:@"more"];
    self.max_id = [moreWrapper getStringForKey:@"id"];
    self.has = [moreWrapper getBoolForKey:@"has"];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"items"];
    [self.modelItemArray addObjectsFromArray:[HomeworkItem nh_modelArrayWithJson:listWrapper.data]];
    
    return YES;
}

@end

@interface HomeWorkRecordListVC ()
@property (nonatomic, strong)ContactsLoadingView *notificationLoadingView;
@end

@implementation HomeWorkRecordListVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHomeworkChanged) name:kHomeworkManagerChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHomeworkSendSuccess:) name:kHomeworkSendSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHomeworkReadNumChanged:) name:kHomeworkReadNumChangedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    UIView* sendView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    [sendView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
    [self setupSendView:sendView];
    [self.view addSubview:sendView];
    
    [self bindTableCell:@"HomeworkRecordItemCell" tableModel:@"MySendHomeworkListModel"];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
}

- (void)setupSendView:(UIView *)viewParent{
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, kLineHeight)];
    [sepLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:sepLine];
    
    UIButton*   sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(publishHomework) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setFrame:CGRectMake(10, 10, viewParent.width - 10 * 2, viewParent.height - 10 * 2)];
    [sendButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:sendButton.size cornerRadius:3] forState:UIControlStateNormal];
    [sendButton setImage:[UIImage imageNamed:@"publishHomework"] forState:UIControlStateNormal];
    [viewParent addSubview:sendButton];
}

- (ContactsLoadingView *)notificationLoadingView{
    if(_notificationLoadingView == nil){
        _notificationLoadingView = [[ContactsLoadingView alloc] init];
        [_notificationLoadingView setCenter:CGPointMake(self.view.width / 2, (kScreenHeight - 64) / 2)];
    }
    return _notificationLoadingView;
}

- (EmptyHintView *)emptyView{
    if(!_emptyView){
        _emptyView = [[EmptyHintView alloc] initWithImage:@"NoSendNotification" title:@"暂时没有作业记录"];
    }
    return _emptyView;
}

- (void)clear{
    @weakify(self)
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否清空已发记录?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        @strongify(self)
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/tclear" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:NO];
            [self requestData:REQUEST_REFRESH];
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)publishHomework{
    PublishHomeWorkVC *publishHomeWorkVC = [[PublishHomeWorkVC alloc] init];
    [CurrentROOTNavigationVC pushViewController:publishHomeWorkVC animated:YES];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    MySendHomeworkListModel *model = (MySendHomeworkListModel *)self.tableViewModel;
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"exercises/lists"];
    [task setRequestMethod:REQUEST_GET];
    if(requestType == REQUEST_GETMORE){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:model.max_id forKey:@"max_id"];
        [task setParams:params];
    }
    return task;
}

- (void)onHomeworkChanged{
    NSInteger count = self.tableViewModel.modelItemArray.count + [HomeworkManager sharedInstance].sendingHomeworkArray.count;
    [self.tableView reloadData];
    if(count > 0){
        [self.tableView scrollToRow:0 inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

- (void)onHomeworkSendSuccess:(NSNotification *)notification{
    HomeworkItem *item = notification.userInfo[kNewHomeworkToSend];
    if(item){
        [self.tableViewModel.modelItemArray insertObject:item atIndex:0];
        [self saveModel];
        [self.tableView reloadData];
        [self.tableView scrollToTop];
    }
}

- (void)onHomeworkReadNumChanged:(NSNotification *)notification{
    HomeworkItem *item = notification.userInfo[@"notification"];
    if(item){
        for (HomeworkItem *homeworkItem in self.tableViewModel.modelItemArray) {
            if([homeworkItem.eid isEqualToString:item.eid]){
                homeworkItem.read_num = item.read_num;
                [self.tableView reloadData];
                [self saveModel];
                break;
            }
        }
    }
}

- (void)saveModel{
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:self.tableViewModel];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [modelData writeToFile:[self cacheFilePath] atomically:YES];
        if(success)
            NSLog(@"save success");
    });
}

- (void)deleteHomeworkItem:(HomeworkItem *)homework{
    NSInteger row = [self.tableViewModel.modelItemArray indexOfObject:homework];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/delete" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"eid" : homework.eid} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [self.tableViewModel.modelItemArray removeObject:homework];
        [self saveModel];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)TNBaseTableViewControllerRequestStart{
    if(self.tableViewModel.modelItemArray.count == 0){
        [self.notificationLoadingView show];
        [self showEmptyView:NO];
    }
}

- (void)TNBaseTableViewControllerRequestSuccess{
    [self.notificationLoadingView dismiss];
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg{
    [self.notificationLoadingView dismiss];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.tableViewModel.modelItemArray.count + [HomeworkManager sharedInstance].sendingHomeworkArray.count;
    BOOL showEmpty = count == 0;
    [self showEmptyView:showEmpty && !self.isLoading];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    MGSwipeTableCell *tableCell = nil;
    if([HomeworkManager sharedInstance].sendingHomeworkArray.count > row){//正在发送
        HomeWorkEntity *sendEntity = [HomeworkManager sharedInstance].sendingHomeworkArray[row];
        NSString *reuseID = @"NotificationSendingItemCell";
        HomeworkSendingItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil){
            cell = [[HomeworkSendingItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        [cell setSendEntity:sendEntity];
        [cell setCancelCallback:^{
            [sendEntity cancelSend];
            [[HomeworkDraftManager sharedInstance] addDraft:sendEntity];
            [[HomeworkManager sharedInstance] removeHomework:sendEntity];
            [ProgressHUD showHintText:@"取消成功，存入到草稿"];
            //取消发送，加入草稿
        }];
        tableCell = cell;
    }
    else{//已发发送的
        
        HomeworkItem *item = self.tableViewModel.modelItemArray[row - [HomeworkManager sharedInstance].sendingHomeworkArray.count];
        NSString *reuseID = @"NotificationRecordItemCell";
        HomeworkRecordItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil){
            cell = [[HomeworkRecordItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        [cell setHomeworkItem:item];
        [cell setRevokeCallback:^{
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/cancel_send_notice" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"id" : item.eid} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                [ProgressHUD showHintText:@"已撤销"];
            } fail:^(NSString *errMsg) {
                [ProgressHUD showHintText:errMsg];
            }];
        }];
        tableCell = cell;
        NSMutableArray *buttonArray = [NSMutableArray array];
        @weakify(self)
        MGSwipeButton * deleteButton = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell * sender){
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否删除该条记录?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setDestructiveHandler:^(LGAlertView *alertView) {
                @strongify(self)
                [self deleteHomeworkItem:item];
            }];
            [alertView showAnimated:YES completionHandler:nil];
            return YES;
        }];
        [buttonArray addObject:deleteButton];
        MGSwipeButton * forwardButton = [MGSwipeButton buttonWithTitle:@"转发" backgroundColor:[UIColor colorWithHexString:@"28c4d8"] callback:^BOOL(MGSwipeTableCell * sender){
            HomeWorkEntity *sendEntity = [HomeWorkEntity sendEntityWithHomeworkItem:item];
            [sendEntity setForward:YES];
            PublishHomeWorkVC *sendVC = [[PublishHomeWorkVC alloc] initWithHomeWorkEntity:sendEntity];
            [CurrentROOTNavigationVC pushViewController:sendVC animated:YES];
            return YES;
        }];
        [buttonArray addObject:forwardButton];
        [tableCell setRightButtons:buttonArray];
    }
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([HomeworkManager sharedInstance].sendingHomeworkArray.count > indexPath.row){
        
    }
    else{
        __weak typeof(self) wself = self;
        HomeworkItem *item = self.tableViewModel.modelItemArray[indexPath.row - [HomeworkManager sharedInstance].sendingHomeworkArray.count];
        HomeworkDetailVC*  detailVC = [[HomeworkDetailVC alloc] init];
        [detailVC setHid:item.eid];
        [detailVC setHasNew:item.unread];
        [detailVC setDeleteCallback:^(NSString *hid) {
            for (HomeworkItem *notiItem in wself.tableViewModel.modelItemArray) {
                if([hid isEqualToString:notiItem.eid]){
                    [wself.tableViewModel.modelItemArray removeObject:notiItem];
                    [wself.tableView reloadData];
                    break;
                }
            }
        }];
        [detailVC setReadCallback:^{
            [wself requestData:REQUEST_REFRESH];
        }];
        [CurrentROOTNavigationVC pushViewController:detailVC animated:YES];
    }
}

- (BOOL)supportCache{
    return YES;
}

- (NSString *)cacheFileName{
    return kSendedHomeworkKey;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

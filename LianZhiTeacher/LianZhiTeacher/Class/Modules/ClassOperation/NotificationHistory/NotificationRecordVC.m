//
//  NotificationRecordVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationRecordVC.h"
#import "NotificationDetailVC.h"
#import "NotificationDraftManager.h"

@implementation NotificationSendingItemCell
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
        
        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_video"]];
        [self.contentView addSubview:_videoImageView];
        
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

- (void)setSendEntity:(NotificationSendEntity *)sendEntity{
    _sendEntity = sendEntity;
    [_titleLabel setFrame:CGRectMake(12, 18, self.width - 12 * 2, 20)];
    [_titleLabel setText:_sendEntity.words];
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
    [_progressView setFProgress:_sendEntity.uploadProgress];
    [RACObserve(_sendEntity, uploadProgress) subscribeNext:^(id x) {
        [_progressView setFProgress:_sendEntity.uploadProgress];
    }];
    [_audioImageView setHidden:!_sendEntity.hasAudio];
    [_photoImageView setHidden:!_sendEntity.hasImage];
    [_videoImageView setHidden:!_sendEntity.hasVideo];
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
    if(_sendEntity.hasVideo){
        [_videoImageView setCenter:CGPointMake(spaceXStart, centerY)];
    }
}

- (void)onCancelClicked{
    if(self.cancelCallback){
        self.cancelCallback();
    }
}

@end

@implementation NotificationRecordItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setSize:CGSizeMake(kScreenWidth, 70)];
        [self setBackgroundColor:[UIColor whiteColor]];
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
        
        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"draft_video"]];
        [self.contentView addSubview:_videoImageView];
        
        _delayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification_delay"]];
        [self.contentView addSubview:_delayImageView];
        
        _revokeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_revokeButton setImage:[UIImage imageNamed:@"notification_revoke"] forState:UIControlStateNormal];
        [_revokeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_revokeButton setTitleColor:[UIColor colorWithHexString:@"28c4d8"] forState:UIControlStateNormal];
        [_revokeButton setTitle:@"撤销" forState:UIControlStateNormal];
        [_revokeButton sizeToFit];
        [_revokeButton setSize:CGSizeMake(_revokeButton.width + 10, _revokeButton.height + 4)];
        [_revokeButton addTarget:self action:@selector(onRevoke) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_revokeButton];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self.contentView addSubview:_sepLine];
    }
    return self;
}


- (void)setNotificationItem:(NotificationItem *)notificationItem{
    _notificationItem = notificationItem;
    
    CGFloat spaceXEnd = self.width - 10;
//    if(_notificationItem.is_sent){
        [_delayImageView setHidden:YES];
        [_timeLabel setHidden:NO];
        [_stateLabel setHidden:NO];
        [_revokeButton setHidden:YES];
        [_timeLabel setText:_notificationItem.created_time];
        [_timeLabel sizeToFit];
        [_timeLabel setOrigin:CGPointMake(spaceXEnd - _timeLabel.width, 15)];
        spaceXEnd = spaceXEnd - _timeLabel.width - 10;
        
        NSMutableAttributedString *stateStr = [[NSMutableAttributedString alloc] initWithString:@"发送:"];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_notificationItem.sent_num) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人 已读:" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_notificationItem.read_num) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
        [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
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
    [_titleLabel setText:_notificationItem.words];
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
    
    [_audioImageView setHidden:!_notificationItem.hasAudio];
    [_photoImageView setHidden:!_notificationItem.hasImage];
    [_videoImageView setHidden:!_notificationItem.hasVideo];
    CGFloat spaceXStart = 20;
    CGFloat centerY = 50;
    if(_notificationItem.hasAudio){
        [_audioImageView setCenter:CGPointMake(spaceXStart, centerY)];
        spaceXStart += _audioImageView.width + 15;
    }
    if(_notificationItem.hasImage){
        [_photoImageView setCenter:CGPointMake(spaceXStart, centerY)];
        spaceXStart += _photoImageView.width + 15;
    }
    if(_notificationItem.hasVideo){
        [_videoImageView setCenter:CGPointMake(spaceXStart, centerY)];
    }

}

- (void)onRevoke{
    if(self.revokeCallback){
        self.revokeCallback();
    }
}

@end

@interface NotificationRecordVC ()
@end

@implementation NotificationRecordVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationChanged) name:kNotificationManagerChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationSendSuccess:) name:kNotificationSendSuccessNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindTableCell:@"NotificationRecordItemCell" tableModel:@"MySendNotificationModel"];
    [self.tableView setFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
}


- (void)clear{
    @weakify(self)
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否清空已发送记录?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"清空"];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/clear_send_list" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            @strongify(self)
            [self.tableViewModel.modelItemArray removeAllObjects];
            [[NSFileManager defaultManager] removeItemAtPath:[self cacheFilePath] error:nil];
            [[NotificationManager sharedInstance] clearSendingList];
            [self.tableView reloadData];
        } fail:^(NSString *errMsg) {
            
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)onNotificationChanged{
    NSInteger count = self.tableViewModel.modelItemArray.count + [NotificationManager sharedInstance].sendingNotificationArray.count;
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

- (void)onNotificationSendSuccess:(NSNotification *)notification{
    NotificationItem *item = notification.userInfo[kNewNotificationToSend];
    if(item){
        [self.tableViewModel.modelItemArray insertObject:item atIndex:0];
        [self saveModel];
        [self.tableView reloadData];
        [self.tableView scrollToTop];
    }
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    MySendNotificationModel *model = (MySendNotificationModel *)self.tableViewModel;
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"notice/my_send_list"];
    [task setParams:@{@"from" : kStringFromValue(model.modelItemArray.count)}];
    [task setRequestMethod:REQUEST_GET];
    return task;
}

- (void)saveModel{
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:self.tableViewModel];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [modelData writeToFile:[self cacheFilePath] atomically:YES];
        if(success)
            NSLog(@"save success");
    });
}

- (void)deleteNotificationItem:(NotificationItem *)notificationItem{
    NSInteger row = [self.tableViewModel.modelItemArray indexOfObject:notificationItem];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_send_notice" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"id" : notificationItem.nid} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [self.tableViewModel.modelItemArray removeObject:notificationItem];
        [self saveModel];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } fail:^(NSString *errMsg) {
        
    }];

}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = self.tableViewModel.modelItemArray.count + [NotificationManager sharedInstance].sendingNotificationArray.count;
    NSLog(@"table count is %zd",count);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    NSLog(@"row is %zd",row);
    MGSwipeTableCell *tableCell = nil;
    if(self.tableViewModel.modelItemArray.count > row){//已发送的
        NotificationItem *item = self.tableViewModel.modelItemArray[row];
        NSString *reuseID = @"NotificationRecordItemCell";
        NotificationRecordItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil){
            cell = [[NotificationRecordItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        [cell setNotificationItem:item];
        [cell setRevokeCallback:^{
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/cancel_send_notice" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"id" : item.nid} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
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
            [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setDestructiveHandler:^(LGAlertView *alertView) {
                @strongify(self)
                [self deleteNotificationItem:item];
                }];
            [alertView showAnimated:YES completionHandler:nil];
            return YES;
        }];
        [buttonArray addObject:deleteButton];
        MGSwipeButton * forwardButton = [MGSwipeButton buttonWithTitle:@"转发" backgroundColor:[UIColor colorWithHexString:@"28c4d8"] callback:^BOOL(MGSwipeTableCell * sender){
            return YES;
        }];
        [buttonArray addObject:forwardButton];
        [tableCell setRightButtons:buttonArray];
    }
    else{//正在发送的
        NotificationSendEntity *sendEntity = [NotificationManager sharedInstance].sendingNotificationArray[indexPath.row - self.tableViewModel.modelItemArray.count];
        NSString *reuseID = @"NotificationSendingItemCell";
        NotificationSendingItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil){
            cell = [[NotificationSendingItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        [cell setSendEntity:sendEntity];
        [cell setCancelCallback:^{
            [sendEntity cancelSend];
            [[NotificationDraftManager sharedInstance] addDraft:sendEntity];
            [[NotificationManager sharedInstance] removeNotification:sendEntity];
            //取消发送，加入草稿
        }];
        tableCell = cell;
    }
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.tableViewModel.modelItemArray.count > indexPath.row){
        NotificationItem *item = self.tableViewModel.modelItemArray[indexPath.row];
        NotificationDetailVC*  detailVC = [[NotificationDetailVC alloc] init];
        [detailVC setNotificationID:item.nid];
        [CurrentROOTNavigationVC pushViewController:detailVC animated:YES];
    }
    else{
        
    }
}

- (BOOL)supportCache{
    return YES;
}

- (NSString *)cacheFileName{
    return kSendedNotificationKey;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  HomeWorkRecordListVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeWorkRecordListVC.h"
#import "PublishHomeWorkVC.h"
#import "HomeworkDetailVC.h"
#import "HomeworkDraftManager.h"
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
    [_titleLabel setText:_sendEntity.words];
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


- (void)setHomeworkEntity:(HomeWorkEntity *)homeworkEntity{
    _homeworkEntity = homeworkEntity;
    
    CGFloat spaceXEnd = self.width - 10;
    //    if(_notificationItem.is_sent){
    [_delayImageView setHidden:YES];
    [_timeLabel setHidden:NO];
    [_stateLabel setHidden:NO];
    [_revokeButton setHidden:YES];
    [_timeLabel setText:_homeworkEntity.createTime];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(spaceXEnd - _timeLabel.width, 15)];
    spaceXEnd = spaceXEnd - _timeLabel.width - 10;
    
    NSMutableAttributedString *stateStr = [[NSMutableAttributedString alloc] initWithString:@"发送:"];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_homeworkEntity.sent_num) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人 回复:" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_homeworkEntity.reply_num) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"人 批阅:" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]}]];
    [stateStr appendAttributedString:[[NSAttributedString alloc] initWithString:kStringFromValue(_homeworkEntity.read_num) attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"28c4d8"]}]];
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
    [_titleLabel setText:_homeworkEntity.words];
    [_sepLine setFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
    
    [_audioImageView setHidden:!_homeworkEntity.hasAudio];
    [_photoImageView setHidden:!_homeworkEntity.hasImage];
    CGFloat spaceXStart = 20;
    CGFloat centerY = 50;
    if(_homeworkEntity.hasAudio){
        [_audioImageView setCenter:CGPointMake(spaceXStart, centerY)];
        spaceXStart += _audioImageView.width + 15;
    }
    if(_homeworkEntity.hasImage){
        [_photoImageView setCenter:CGPointMake(spaceXStart, centerY)];
        spaceXStart += _photoImageView.width + 15;
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

- (instancetype)init{
    self = [super init];
    if(self){
        for (NSInteger i = 0; i < 10; i++) {
            HomeWorkEntity *homeworkEntity = [[HomeWorkEntity alloc] init];
            [self.modelItemArray addObject:homeworkEntity];
        }
    }
    return self;
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type{
//    self.total = [data getIntegerForKey:@"total"];
    if(type == REQUEST_REFRESH){
        [self.modelItemArray removeAllObjects];
    }
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"list"];
    [self.modelItemArray addObjectsFromArray:[HomeWorkEntity nh_modelArrayWithJson:listWrapper.data]];
    
    return YES;
}

@end

@implementation HomeWorkRecordListVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationChanged) name:kHomeworkManagerChangedNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationSendSuccess:) name:kHomeworkSendSuccessNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationReadNumChanged:) name:kNotificationReadNumChangedNotification object:nil];
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
//    [self requestData:REQUEST_REFRESH];
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
    [sendButton setImage:[UIImage imageNamed:@"send_notification"] forState:UIControlStateNormal];
    [viewParent addSubview:sendButton];
}

- (void)publishHomework{
    PublishHomeWorkVC *publishHomeWorkVC = [[PublishHomeWorkVC alloc] init];
    [CurrentROOTNavigationVC pushViewController:publishHomeWorkVC animated:YES];
}

- (void)deleteHomeworkItem:(HomeWorkEntity *)homework{
    
}

- (void)TNBaseTableViewControllerRequestStart{
 
}

- (void)TNBaseTableViewControllerRequestSuccess{
   
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg{
    
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
    if([HomeworkManager sharedInstance].sendingHomeworkArray.count > row){//已发送的
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
    else{//正在发送的
        
        HomeWorkEntity *item = self.tableViewModel.modelItemArray[row - [HomeworkManager sharedInstance].sendingHomeworkArray.count];
        NSString *reuseID = @"NotificationRecordItemCell";
        HomeworkRecordItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        if(cell == nil){
            cell = [[HomeworkRecordItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        }
        [cell setHomeworkEntity:item];
        [cell setRevokeCallback:^{
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/cancel_send_notice" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{@"id" : item.hid} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
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
            PublishHomeWorkVC *sendVC = [[PublishHomeWorkVC alloc] initWithHomeWorkEntity:item];
            [sendVC setSendType:HomeworkSendForward];
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
        @weakify(self)
        HomeWorkEntity *item = self.tableViewModel.modelItemArray[indexPath.row - [HomeworkManager sharedInstance].sendingHomeworkArray.count];
        HomeworkDetailVC*  detailVC = [[HomeworkDetailVC alloc] init];
        [detailVC setHid:item.hid];
        [detailVC setDeleteCallback:^(NSString *hid) {
            @strongify(self)
            for (NotificationItem *notiItem in self.tableViewModel.modelItemArray) {
                if([hid isEqualToString:notiItem.nid]){
                    [self.tableViewModel.modelItemArray removeObject:notiItem];
                    [self.tableView reloadData];
                    break;
                }
            }
        }];
        [CurrentROOTNavigationVC pushViewController:detailVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

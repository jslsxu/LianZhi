//
//  NotificationDetailVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailVC.h"
#import "NotificationDetailActionView.h"
#import "NotificationDetailView.h"
#import "NotificationTargetListView.h"
#import "NotificationSendVC.h"
#import "ContactsLoadingView.h"
NSString *const kNotificationReadNumChangedNotification = @"NotificationReadNumChangedNotification";

@interface NotificationDetailVC (){
    UISegmentedControl*             _segmentCtrl;
    NotificationDetailView*         _detailView;
    NotificationTargetListView*     _targetListView;
}
@property (nonatomic, strong)UIButton *moreButton;
@property (nonatomic, strong)NotificationItem* notificationItem;
@property (nonatomic, strong)ContactsLoadingView *contactsLoadingView;
@end

@implementation NotificationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _segmentCtrl  = [[UISegmentedControl alloc] initWithItems:@[@"通知详情",@"阅读人数"]];
    [_segmentCtrl setWidth:150];
    [_segmentCtrl setSelectedSegmentIndex:0];
    [_segmentCtrl addTarget:self action:@selector(onSegValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:_segmentCtrl];
    
    [self setRightbarButtonHighlighted:NO];
    
    _detailView = [[NotificationDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [self.view addSubview:_detailView];
    
    _targetListView = [[NotificationTargetListView alloc] initWithFrame:_detailView.frame];
    [_targetListView setHidden:YES];
    [self.view addSubview:_targetListView];
    @weakify(self)
    [_targetListView setNotificationRefreshCallback:^(NotificationItem *notificationItem) {
        @strongify(self)
        [self setNotificationItem:notificationItem];
        [self saveNotification:notificationItem];
    }];
    NSData *notificationData = [NSData dataWithContentsOfFile:[self cacheFilePath]];
    if(notificationData){
        self.notificationItem = [NSKeyedUnarchiver unarchiveObjectWithData:notificationData];
    }

    [self loadData];
}

- (void)setNotificationItem:(NotificationItem *)notificationItem{
    _notificationItem = notificationItem;
    _notificationItem.user = [UserCenter sharedInstance].userInfo;
    [_detailView setNotificationItem:self.notificationItem];
    [_targetListView setNotificationItem:self.notificationItem];
    
    if(notificationItem){
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReadNumChangedNotification object:nil userInfo:@{@"notification" : notificationItem}];
    }
}

- (void)saveNotification:(NotificationItem *)notification{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.notificationItem];
        [data writeToFile:[self cacheFilePath] atomically:YES];
    });
}

- (ContactsLoadingView *)contactsLoadingView{
    if(!_contactsLoadingView){
        _contactsLoadingView = [[ContactsLoadingView alloc] initWithFrame:CGRectZero];
        [_contactsLoadingView setCenter:CGPointMake(self.view.width / 2, (kScreenHeight - 64) / 2)];
        [self.view addSubview:_contactsLoadingView];
    }
    return _contactsLoadingView;
}

- (void)loadData{
    if(self.notificationItem == nil){
        [self.contactsLoadingView show];
    }
    @weakify(self)
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/my_send_detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"id" : self.notificationID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self)
        [self.contactsLoadingView dismiss];
        NotificationItem *notification = [NotificationItem nh_modelWithJson:responseObject.data];
        self.notificationItem = notification;
        [self saveNotification:self.notificationItem];
    } fail:^(NSString *errMsg) {
        @strongify(self)
        [self.contactsLoadingView dismiss];
    }];
}

- (void)setRightbarButtonHighlighted:(BOOL)highlighted{
    if(_moreButton == nil){
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setSize:CGSizeMake(30, 40)];
        [_moreButton addTarget:self action:@selector(onMoreClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithCustomView:_moreButton];
        self.navigationItem.rightBarButtonItem = moreItem;
    }
     [_moreButton setImage:[UIImage imageNamed:highlighted ? @"noti_detail_more_highlighted" : @"noti_detail_more"] forState:UIControlStateNormal];
}

- (void)onSegValueChanged{
    NSInteger index = _segmentCtrl.selectedSegmentIndex;
    if(index == 0){
        [_detailView setHidden:NO];
        [_targetListView setHidden:YES];
    }
    else{
        [_detailView setHidden:YES];
        [_targetListView setHidden:NO];
        if([[MLAmrPlayer shareInstance] isPlaying]){
            [[MLAmrPlayer shareInstance] stopPlaying];
        }
    }
}

- (void)onMoreClicked{
    if([[MLAmrPlayer shareInstance] isPlaying]){
        [[MLAmrPlayer shareInstance] stopPlaying];
    }
    [self setRightbarButtonHighlighted:YES];
    if(self.notificationItem){
        @weakify(self);
        NotificationActionItem *forwadItem = [NotificationActionItem actionItemWithTitle:@"转发" action:^{
            @strongify(self)
            if(self.notificationItem){
                NotificationSendVC *sendVC = [[NotificationSendVC alloc] initWithSendEntity:[NotificationSendEntity sendEntityWithNotification:self.notificationItem]];
                [sendVC setSendType:NotificationSendForward];
                [CurrentROOTNavigationVC pushViewController:sendVC animated:YES];
            }
        } destroyItem:NO];
        //    NotificationActionItem *sendItem = [NotificationActionItem actionItemWithTitle:@"立即发送" action:^{
        //
        //    } destroyItem:NO];
        //    NotificationActionItem *revokeItem = [NotificationActionItem actionItemWithTitle:@"撤销" action:^{
        //
        //    } destroyItem:NO];
        //    NotificationActionItem *editItem = [NotificationActionItem actionItemWithTitle:@"编辑" action:^{
        //
        //    } destroyItem:NO];
        //    NotificationActionItem *shareItem = [NotificationActionItem actionItemWithTitle:@"分享" action:^{
        //        [ShareActionView shareWithTitle:@"分享" content:@"" image:[UIImage imageNamed:@"ClassZone"] imageUrl:@"" url:@""];
        //    } destroyItem:NO];
        NotificationActionItem *deleteItem = [NotificationActionItem actionItemWithTitle:@"删除" action:^{
            @strongify(self)
            LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否删除这条?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
            [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
            [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
            [alertView setDestructiveHandler:^(LGAlertView *alertView) {
                [self deleteNotificationItem];
            }];
            [alertView showAnimated:YES completionHandler:nil];
        } destroyItem:YES];
        [NotificationDetailActionView showWithActions:@[forwadItem, /*sendItem, revokeItem,*/  deleteItem] completion:^{
            @strongify(self);
            [self setRightbarButtonHighlighted:NO];
        }];

    }
    else{
        [ProgressHUD showHintText:@"没有获取到通知详情"];
    }
}

- (void)deleteNotificationItem{
    if(self.notificationItem){
        @weakify(self)
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_send_notice" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"id" : self.notificationItem.nid} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [ProgressHUD showHintText:@"删除成功"];
            @strongify(self)
            if(self.deleteCallback){
                self.deleteCallback(self.notificationID);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } fail:^(NSString *errMsg) {
            
        }];
    }
}

- (BOOL)supportCache{
    return YES;
}

- (NSString *)cacheFileName{
    return [NSString stringWithFormat:@"mySendNotificaiton_%@",self.notificationID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

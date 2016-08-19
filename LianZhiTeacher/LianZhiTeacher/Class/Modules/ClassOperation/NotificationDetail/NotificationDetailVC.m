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
@interface NotificationDetailVC (){
    UISegmentedControl*             _segmentCtrl;
    NotificationDetailView*         _detailView;
    NotificationTargetListView*     _targetListView;
}
@property (nonatomic, strong)UIButton *moreButton;
@property (nonatomic, strong)NotificationItem* notificationItem;
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
    
    [self loadData];
}

- (void)setNotificationItem:(NotificationItem *)notificationItem{
    _notificationItem = notificationItem;
    [_detailView setNotificationItem:self.notificationItem];
    [_targetListView setTargetArray:self.notificationItem.targetArray];
}

- (void)loadData{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/my_send_detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"id" : self.notificationID} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        NotificationItem *notification = [NotificationItem nh_modelWithJson:responseObject.data];
        self.notificationItem = notification;
    } fail:^(NSString *errMsg) {
        
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
    }
}

- (void)onMoreClicked{
    [self setRightbarButtonHighlighted:YES];
    NotificationActionItem *forwadItem = [NotificationActionItem actionItemWithTitle:@"转发" action:^{
        
    } destroyItem:NO];
    NotificationActionItem *sendItem = [NotificationActionItem actionItemWithTitle:@"立即发送" action:^{
        
    } destroyItem:NO];
    NotificationActionItem *revokeItem = [NotificationActionItem actionItemWithTitle:@"撤销" action:^{
        
    } destroyItem:NO];
    NotificationActionItem *editItem = [NotificationActionItem actionItemWithTitle:@"编辑" action:^{
        
    } destroyItem:NO];
    NotificationActionItem *shareItem = [NotificationActionItem actionItemWithTitle:@"分享" action:^{
        [ShareActionView shareWithTitle:@"分享" content:@"" image:[UIImage imageNamed:@"ClassZone"] imageUrl:@"" url:@""];
    } destroyItem:NO];
    NotificationActionItem *deleteItem = [NotificationActionItem actionItemWithTitle:@"删除" action:^{
        
    } destroyItem:YES];
    @weakify(self);
    [NotificationDetailActionView showWithActions:@[forwadItem, sendItem, revokeItem, editItem, shareItem, deleteItem] completion:^{
        @strongify(self);
        [self setRightbarButtonHighlighted:NO];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

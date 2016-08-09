//
//  MessageNotificationDetailVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/8.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MessageNotificationDetailVC.h"
#import "NotificationDetailView.h"
#import "NotificationDetailActionView.h"
@interface MessageNotificationDetailVC (){
    NotificationDetailView*         _detailView;
}
@property (nonatomic, strong)UIButton *moreButton;
@property (nonatomic, strong)NotificationSendEntity *notificationEntity;
@end

@implementation MessageNotificationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知详情";
    [self setRightbarButtonHighlighted:NO];
    _detailView = [[NotificationDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_detailView setNotificationSendEntity:self.notificationEntity];
    [self.view addSubview:_detailView];
}

- (void)setMessageDetailItem:(MessageDetailItem *)messageDetailItem{
    _messageDetailItem = messageDetailItem;
    self.notificationEntity = [[NotificationSendEntity alloc] initWithMessageDetailItem:_messageDetailItem];
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

- (void)onMoreClicked{
    [self setRightbarButtonHighlighted:YES];
    @weakify(self)
    NotificationActionItem *forwadItem = [NotificationActionItem actionItemWithTitle:@"转发到树屋" action:^{
        
    } destroyItem:NO];
    NotificationActionItem *shareItem = [NotificationActionItem actionItemWithTitle:@"分享" action:^{
        [ShareActionView shareWithTitle:@"分享" content:@"" image:nil imageUrl:@"" url:@""];
    } destroyItem:NO];
    NotificationActionItem *deleteItem = [NotificationActionItem actionItemWithTitle:@"删除" action:^{
        @strongify(self)
        [self deleteNotification];
    } destroyItem:YES];
    [NotificationDetailActionView showWithActions:@[forwadItem, shareItem, deleteItem] completion:^{
        @strongify(self);
        [self setRightbarButtonHighlighted:NO];
    }];

}

- (void)deleteNotification{
    @weakify(self)
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.messageDetailItem.msgID forKey:@"notice_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/delete_notice" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

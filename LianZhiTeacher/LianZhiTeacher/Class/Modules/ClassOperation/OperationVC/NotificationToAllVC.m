//
//  NotificationToAllVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NotificationToAllVC.h"
#import "TextMessageSendVC.h"
#import "PhotoOperationVC.h"
#import "AudioMessageSendVC.h"
@implementation NotificationItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.groupID = [dataWrapper getStringForKey:@"id"];
    self.groupName = [dataWrapper getStringForKey:@"name"];
    self.comment = [dataWrapper getStringForKey:@"year"];
    self.selected = NO;
    self.canSelected = YES;
}

@end

@implementation NotificationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
        [self.textLabel setFont:[UIFont systemFontOfSize:13]];
        [self.detailTextLabel setFont:[UIFont systemFontOfSize:11]];
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setNotificationItem:(NotificationItem *)notificationItem
{
    _notificationItem = notificationItem;
    [self.imageView setImage:[UIImage imageNamed:@"NotiRecordAudioIcon"]];
    [self.textLabel setText:@"发送了三张照片"];
    [self.detailTextLabel setText:@"wifi下自动发送"];
}

@end

@interface NotificationToAllVC()

@end

@implementation NotificationToAllVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _latestArray = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布通知";
    
    UIView *operationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 75)];
    [operationView setBackgroundColor:kCommonTeacherTintColor];
    [self setupHeaderView:operationView];
    [self.view addSubview:operationView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, operationView.bottom, self.view.width, self.view.height - operationView.bottom - 64) style:UITableViewStyleGrouped];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 30)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"E6E6E6"]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.width - 10 * 2, headerView.height)];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
    [titleLabel setFont:[UIFont systemFontOfSize:12]];
    [titleLabel setText:@"近期发送记录"];
    [headerView addSubview:titleLabel];
    [_tableView setTableHeaderView:headerView];
}

- (void)setupHeaderView:(UIView *)viewParent
{
    NSInteger itemWidth = 50;
    NSInteger itemHeight = 60;
    NSInteger innerMagin = 36;
    NSInteger spaceXStart = (viewParent.width - itemWidth * 3 - innerMagin * 2) / 2;
    NSArray *imageArray = @[@"NotificationMessage",@"NotificationPhoto",@"NotificationAudio"];
    NSArray *titleArray = @[@"消息通知",@"图片通知",@"语音通知"];
    for (NSInteger i = 0; i < 3; i++)
    {
        LZTabBarButton *sendButton = [LZTabBarButton buttonWithType:UIButtonTypeCustom];
        [sendButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        [sendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [sendButton addTarget:self action:NSSelectorFromString([NSString stringWithFormat:@"on%@",imageArray[i]]) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setFrame:CGRectMake(spaceXStart + (itemWidth + innerMagin) * i, (viewParent.height - itemHeight) / 2, itemWidth, itemHeight)];
        [viewParent addSubview:sendButton];
    }
}

- (void)onNotificationMessage
{
    TextMessageSendVC *messageOperationVC = [[TextMessageSendVC alloc] init];
    TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:messageOperationVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)onNotificationPhoto
{
    PhotoOperationVC *photoOperationVC = [[PhotoOperationVC alloc] init];
    TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:photoOperationVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)onNotificationAudio
{
    AudioMessageSendVC *messageOperationVC = [[AudioMessageSendVC alloc] init];
    TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:messageOperationVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UItableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"NotificationGroupCell";
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[NotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setNotificationItem:nil];
    return cell;
}
@end

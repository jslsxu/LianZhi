//
//  NotificationHistoryVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationHistoryVC.h"
#import "NotificationRecordVC.h"
#import "NotificationDraftVC.h"
#import "NotificationSendVC.h"
@interface NotificationHistoryVC ()
@property (nonatomic, strong)UISegmentedControl*    segmentCtrl;
@property (nonatomic, strong)NotificationRecordVC*  recordVC;
@property (nonatomic, strong)NotificationDraftVC*   draftVC;
@property (nonatomic, strong)UIView*                sendNotificationView;
@end

@implementation NotificationHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitleView:self.segmentCtrl];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(onClear)];
    
    self.recordVC = [[NotificationRecordVC alloc] init];
    self.draftVC = [[NotificationDraftVC alloc] init];
    [self.recordVC.view setFrame:self.view.bounds];
    [self.draftVC.view setFrame:self.view.bounds];
    [self.view addSubview:self.recordVC.view];
    [self.view addSubview:self.draftVC.view];
    [self.draftVC.view setHidden:YES];
    
    self.sendNotificationView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - 50, self.view.width, 50)];
    [self setupSendView:self.sendNotificationView];
    [self.view addSubview:self.sendNotificationView];
}

- (void)setupSendView:(UIView *)viewParent{
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, kLineHeight)];
    [sepLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:sepLine];
    
    UIButton*   sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(sendNotification) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setFrame:CGRectMake(10, 10, viewParent.width - 10 * 2, viewParent.height - 10 * 2)];
    [sendButton.layer setBorderColor:kCommonTeacherTintColor.CGColor];
    [sendButton.layer setBorderWidth:1];
    [sendButton.layer setCornerRadius:2];
    [sendButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [sendButton setTitle:@"发布通知" forState:UIControlStateNormal];
    [viewParent addSubview:sendButton];
}

- (UISegmentedControl *)segmentCtrl{
    if(_segmentCtrl == nil){
        _segmentCtrl = [[UISegmentedControl alloc] initWithItems:@[@"记录",@"草稿"]];
        [_segmentCtrl setWidth:120];
        [_segmentCtrl setSelectedSegmentIndex:0];
        [_segmentCtrl addTarget:self action:@selector(onValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentCtrl;
}

- (void)onValueChanged{
    NSInteger index = self.segmentCtrl.selectedSegmentIndex;
    if(index == 0){
        [self.recordVC.view setHidden:NO];
        [self.sendNotificationView setHidden:NO];
        [self.draftVC.view setHidden:YES];
    }
    else{
        [self.recordVC.view setHidden:YES];
        [self.sendNotificationView setHidden:YES];
        [self.draftVC.view setHidden:NO];
    }
}

- (void)sendNotification{
    NotificationSendVC *sendVC = [[NotificationSendVC alloc] init];
    [self.navigationController pushViewController:sendVC animated:YES];
}

- (void)onClear{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
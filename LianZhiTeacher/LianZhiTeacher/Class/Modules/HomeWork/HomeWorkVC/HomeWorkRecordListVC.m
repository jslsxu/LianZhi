//
//  HomeWorkRecordListVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeWorkRecordListVC.h"
#import "PublishHomeWorkVC.h"
@interface HomeWorkRecordListVC ()
@end

@implementation HomeWorkRecordListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50)];
    [self.tableView.layer setBorderColor:[UIColor redColor].CGColor];
    [self.tableView.layer setBorderWidth:1];
    [self.tableView.layer setMasksToBounds:YES];
    UIView* sendView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50, self.view.width, 50)];
    [sendView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
    [self setupSendView:sendView];
    [self.view addSubview:sendView];
    
//    [self bindTableCell:@"" tableModel:@""];
//    [self setSupportPullUp:YES];
//    [self setSupportPullDown:YES];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  HomeworkListVC.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkListVC.h"
#import "HomeworkListModel.h"
#import "HomeworkDetailVC.h"
#import "HomeworkNotificationListModel.h"
@interface HomeworkListVC ()
@end

@implementation HomeworkListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作业通知";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"eeeef4"]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    [self bindTableCell:@"HomeworkNotificationCell" tableModel:@"HomeworkNotificationListModel"];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
}

- (void)clear{
    
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    HttpRequestTask *task = [HttpRequestTask alloc];
    [task setRequestUrl:@"notice/exercises"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [task setParams:params];
    [task setParams:params];
    return task;
}

#pragma mark - 
- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    HomeworkItem *homeworkItem = (HomeworkItem *)modelItem;
    HomeworkDetailVC *homeworkDetailVC = [[HomeworkDetailVC alloc] init];
    [homeworkDetailVC setHomeworkId:homeworkItem.homeworkId];
    [self.navigationController pushViewController:homeworkDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

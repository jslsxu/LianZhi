//
//  HomeWorkVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkVC.h"
#import "HomeWorkListModel.h"
@interface HomeWorkVC ()

@end

@implementation HomeWorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作业练习";
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self bindTableCell:@"HomeWorkCell" tableModel:@"HomeWorkListModel"];
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"practice/get_list"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"class_id"];
    [task setParams:params];
    return task;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

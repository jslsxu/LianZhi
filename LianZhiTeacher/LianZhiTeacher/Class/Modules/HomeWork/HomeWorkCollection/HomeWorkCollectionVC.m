//
//  HomeWorkCollectionVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkCollectionVC.h"

@interface HomeWorkCollectionVC ()

@end

@implementation HomeWorkCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindTableCell:@"HomeWorkHistoryCell" tableModel:@"HomeWorkCollectionModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"practice/get_fav"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:nil forKey:@"max_id"];
    
    [task setParams:params];
    [task setObserver:self];
    return task;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

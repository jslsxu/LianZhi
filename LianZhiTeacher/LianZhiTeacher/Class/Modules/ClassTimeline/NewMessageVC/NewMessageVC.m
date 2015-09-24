//
//  NewMessageVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NewMessageVC.h"
#import "NewMessageCell.h"
#import "NewMessageModel.h"
@interface NewMessageVC ()

@end

@implementation NewMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(onCleanMessage)];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self bindTableCell:@"NewMessageCell" tableModel:@"NewMessageModel"];
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"notice/lognotice"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    
    NewMessageModel *model = (NewMessageModel *)self.tableViewModel;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if(requestType == REQUEST_GETMORE)
        [params setValue:model.lastID forKey:@"more_id"];
    [params setValue:kStringFromValue(self.types) forKey:@"types"];
    [params setValue:self.objid forKey:@"objid"];
    [task setParams:params];
    return task;
}

- (void)onCleanMessage
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

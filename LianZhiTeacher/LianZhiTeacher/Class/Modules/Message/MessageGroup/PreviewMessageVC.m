//
//  PreviewMessageVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/3/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PreviewMessageVC.h"

@implementation PreviewMessageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self bindTableCell:@"MessageGroupItemCell" tableModel:@"MessageGroupListModel"];
    [self setSupportPullDown:YES];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"notice/index"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.schoolID forKey:@"school_id"];
    [task setParams:params];
    [task setObserver:self];
    return task;
}
@end

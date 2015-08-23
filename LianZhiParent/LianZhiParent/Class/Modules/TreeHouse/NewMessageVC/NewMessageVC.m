//
//  NewMessageVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "NewMessageVC.h"

@interface NewMessageVC ()

@end

@implementation NewMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清除" style:UIBarButtonItemStylePlain target:self action:@selector(onCleanMessage)];

}

- (void)onCleanMessage
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

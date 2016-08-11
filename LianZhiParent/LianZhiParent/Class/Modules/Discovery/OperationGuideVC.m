//
//  OperationGuideVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/1.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "OperationGuideVC.h"

@interface OperationGuideVC ()

@end

@implementation OperationGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连枝剧场";
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *guidePath = [path stringByAppendingPathComponent:@"Guide"];
    NSString *htmlPath = [guidePath stringByAppendingPathComponent:@"index.html"];;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

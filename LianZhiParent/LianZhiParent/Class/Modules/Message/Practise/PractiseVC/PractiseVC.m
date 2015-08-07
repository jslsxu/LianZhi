//
//  PractiseVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PractiseVC.h"

@interface PractiseVC ()

@end

@implementation PractiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindTableCell:@"PractiseItemCell" tableModel:@"PractiseModel"];
    [self requestData:REQUEST_REFRESH];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

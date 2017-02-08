//
//  RecordReplyVC.m
//  LianZhiParent
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "RecordReplyVC.h"

@interface RecordReplyVC ()

@end

@implementation RecordReplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回复";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

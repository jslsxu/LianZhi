//
//  PublishBaseVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/20.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishBaseVC.h"
@implementation PublishBaseVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:(@"WhiteLeftArrow.png")] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(onSendClicked)];
}

- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:^{
//            
//        }];
}

- (void)onSendClicked
{
    
}
@end

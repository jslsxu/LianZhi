//
//  PublishBaseVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/20.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishBaseVC.h"
@implementation PublishBaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"WhiteLeftArrow.png")] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
}

- (void)onBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end

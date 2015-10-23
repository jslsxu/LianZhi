//
//  OperationGuideVC.m
//  LianZhiTeacher
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WhiteLeftArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *guidePath = [path stringByAppendingPathComponent:@"Guide"];
    NSString *htmlPath = [guidePath stringByAppendingPathComponent:@"index.html"];;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlPath]]];
}

- (void)back
{
    if([_webView canGoBack])
    {
        [_webView goBack];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

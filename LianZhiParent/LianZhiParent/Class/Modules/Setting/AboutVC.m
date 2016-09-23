//
//  AboutVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/28.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AboutVC.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于连枝";
}

- (void)setupSubviews
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
    [imageView setFrame:CGRectMake((self.view.width - 120) / 2, (self.view.height - 120) / 2 - 60, 120, 120)];
    [self.view addSubview:imageView];
    
    UILabel *preLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [preLabel setBackgroundColor:[UIColor clearColor]];
    [preLabel setTextAlignment:NSTextAlignmentCenter];
    [preLabel setFont:[UIFont systemFontOfSize:15]];
    [preLabel setTextColor:[UIColor grayColor]];
    [preLabel setText:@"连接家校 枝叶相持"];
    [preLabel sizeToFit];
    [preLabel setOrigin:CGPointMake((self.view.width - preLabel.width) / 2, imageView.bottom + 10)];
    [self.view addSubview:preLabel];

    
    UILabel* versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [versionLabel setBackgroundColor:[UIColor clearColor]];
    [versionLabel setFont:[UIFont systemFontOfSize:15]];
    [versionLabel setTextColor:[UIColor grayColor]];
    NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
    [versionLabel setText:[NSString stringWithFormat:@"家长版 Ver %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]]];
    [versionLabel sizeToFit];
    [versionLabel setOrigin:CGPointMake((self.view.width - versionLabel.width) / 2, preLabel.bottom + 10)];
    [self.view addSubview:versionLabel];


}


- (void)onCheckButtonClicked
{
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/check_status" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [ProgressHUD showHintText:@"当前已是最新版本"];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

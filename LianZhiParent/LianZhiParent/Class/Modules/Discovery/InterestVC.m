//
//  InterestVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/13.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "InterestVC.h"

@interface InterestVC ()

@end

@implementation InterestVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        NSString *url = [UserCenter sharedInstance].userData.config.dicoveryUrl;
        if([url rangeOfString:@"?"].length != 0)
        {
            url = [NSString stringWithFormat:@"%@&child_id=%@",url,[UserCenter sharedInstance].curChild.uid];
        }
        else
            url = [NSString stringWithFormat:@"%@?child_id=%@",url,[UserCenter sharedInstance].curChild.uid];
        [self setUrl:url];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DetailShareNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(onShare)];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"info/set_read" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"type": @"1"} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [[UserCenter sharedInstance].statusManager setFound:NO];
    } fail:^(NSString *errMsg) {

    }];
}

- (void)onShare
{
    [ShareActionView shareWithTitle:@"" content:nil image:nil imageUrl:nil url:self.url];
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

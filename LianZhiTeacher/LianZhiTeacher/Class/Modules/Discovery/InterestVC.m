//
//  InterestVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/17.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "InterestVC.h"

@interface InterestVC ()

@end

@implementation InterestVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        NSString *url = [UserCenter sharedInstance].userData.config.dicoveryUrl;
        if([url rangeOfString:@"?"].length != 0)
        {
            url = [NSString stringWithFormat:@"%@&school_id=%@",url,[UserCenter sharedInstance].curSchool.schoolID];
        }
        else
            url = [NSString stringWithFormat:@"%@?school_id=%@",url,[UserCenter sharedInstance].curSchool.schoolID];
        [self setUrl:url];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DetailShareNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(onShare)];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"info/set_read" method:REQUEST_GET type:REQUEST_REFRESH withParams:@{@"type": @"1"} observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [[UserCenter sharedInstance].statusManager setFound:NO];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)onShare
{
    [ShareActionView shareWithTitle:nil content:nil image:nil imageUrl:nil url:self.url];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

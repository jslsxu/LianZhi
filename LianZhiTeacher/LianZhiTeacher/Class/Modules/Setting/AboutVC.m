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
    // Do any additional setup after loading the view.
}

- (void)setupSubviews
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
    [imageView setFrame:CGRectMake((self.view.width - 120) / 2, (self.view.height - 120) / 2 - 60, 120, 120)];
    [imageView.layer setCornerRadius:15];
    [imageView.layer setMasksToBounds:YES];
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
    [versionLabel setText:[NSString stringWithFormat:@"教师版 Ver %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]]];
    [versionLabel sizeToFit];
    [versionLabel setOrigin:CGPointMake((self.view.width - versionLabel.width) / 2, preLabel.bottom + 10)];
    [self.view addSubview:versionLabel];
    
//    UILabel* companyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    [companyLabel setTextColor:[UIColor lightGrayColor]];
//    [companyLabel setFont:[UIFont systemFontOfSize:14]];
//    [companyLabel setText:@"天津市世纪伟业科技发展有限公司"];
//    [companyLabel sizeToFit];
//    [self.view addSubview:companyLabel];
//    [companyLabel setOrigin:CGPointMake((self.view.width - companyLabel.width) / 2, versionLabel.bottom + 40)];
//    
//    TTTAttributedLabel*    companyLinkLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
//    [companyLinkLabel setNumberOfLines:0];
//    [companyLinkLabel setDelegate:self];
//    [companyLinkLabel setTextAlignment:NSTextAlignmentCenter];
//    [companyLinkLabel setUserInteractionEnabled:YES];
//    
//    NSString *first = @"COPYRIGHT © 2015 ";
//    NSString *second = @"SJWYCN.COM";
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",first,second]];
//    [attrStr setAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:14]} range:NSMakeRange(0, attrStr.length)];
//    [attrStr setAttributes:@{NSForegroundColorAttributeName : kCommonTeacherTintColor,NSFontAttributeName : [UIFont systemFontOfSize:14]} range:NSMakeRange(first.length, second.length)];
//    [companyLinkLabel setAttributedText:attrStr];
//    [companyLinkLabel sizeToFit];
//    [self.view addSubview:companyLinkLabel];
//    [companyLinkLabel setOrigin:CGPointMake((self.view.width - companyLinkLabel.width) / 2, companyLabel.bottom + 10)];
//    [companyLinkLabel addLinkToURL:[NSURL URLWithString:[UserCenter sharedInstance].userData.config.aboutUrl] withRange:NSMakeRange(first.length, second.length)];
//    
//    UILabel *extraLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    [extraLabel setTextAlignment:NSTextAlignmentCenter];
//    [extraLabel setTextColor:[UIColor lightGrayColor]];
//    [extraLabel setFont:[UIFont systemFontOfSize:14]];
//    [extraLabel setText:@"ALL RIGHTS RESERVED"];
//    [extraLabel sizeToFit];
//    [extraLabel setOrigin:CGPointMake((self.view.width - extraLabel.width) / 2, companyLinkLabel.bottom + 5)];
//    [self.view addSubview:extraLabel];
    
    
//    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [checkButton addTarget:self action:@selector(onCheckButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [checkButton setBackgroundImage:[[UIImage imageNamed:(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
//    [checkButton setFrame:CGRectMake(10, self.view.height - 45 - 10, self.view.width - 10 * 2, 45)];
//    [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [checkButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
//    [checkButton setTitle:@"检查版本更新" forState:UIControlStateNormal];
//    [self.view addSubview:checkButton];
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

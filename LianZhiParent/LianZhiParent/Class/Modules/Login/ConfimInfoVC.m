//
//  ConfimInfoVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ConfimInfoVC.h"

@interface ConfimInfoVC ()

@end

@implementation ConfimInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关联信息";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"WhiteLeftArrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
}

- (void)setupSubviews
{
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 70) style:UITableViewStylePlain];
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
//    [_tableView setDelegate:self];
//    [_tableView setDataSource:self];
//    [self.view addSubview:_tableView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 70)];
    [self setupHeaderView:_headerView];
    [_tableView setTableHeaderView:_headerView];
    
    _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_reportButton setFrame:CGRectMake(15, self.view.height - 45 - 15, self.view.width - 15 * 2, 45)];
    [_reportButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:_reportButton.size cornerRadius:5] forState:UIControlStateNormal];
    [_reportButton addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];
    [_reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_reportButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_reportButton setTitle:@"报告关联错误" forState:UIControlStateNormal];
    [self.view addSubview:_reportButton];
}

- (void)onBack
{
    AppDelegate *appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    [appDelegate loginSuccess];
}

- (void)report
{
    
}

- (void)setupHeaderView:(UIView *)viewParent
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"WhiteBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [bgImageView setFrame:CGRectMake(10, 10, viewParent.width - 10 * 2, 60)];
    [bgImageView setUserInteractionEnabled:YES];
    [viewParent addSubview:bgImageView];
    
    AvatarView *avatar = [[AvatarView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    [avatar.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [avatar.layer setBorderWidth:2];
    [bgImageView addSubview:avatar];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 60;
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  AccountVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AccountVC.h"
#import "AwardVC.h"

@interface AccountVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSArray *actionVCArray;
@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连枝账户";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStylePlain target:self action:@selector(onMessageClicked)];
    self.titleArray = @[@"奖励任务",@"派送抽奖",@"兑换活动"];
    self.imageArray = @[@"",@"",@""];
    self.actionVCArray = @[@"",@"",@""];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 160)];
    [_tableView setTableHeaderView:headerView];
}

- (void)reloadData
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 160)];
    [self setupHeaderView:headerView];
    [_tableView setTableHeaderView:headerView];
    
    
    [_tableView reloadData];
}

- (void)onMessageClicked
{
    
}

- (void)setupHeaderView:(UIView *)viewParent
{
    
}
#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"AccountCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    [cell.imageView setImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
    [cell.textLabel setText:self.titleArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TNBaseViewController *vc = [[NSClassFromString(self.actionVCArray[indexPath.row]) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

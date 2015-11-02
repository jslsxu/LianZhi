//
//  AccountVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AccountVC.h"

@interface AccountVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSArray *imageArray;
@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连枝账户";
    self.titleArray = @[@"奖励任务",@"派送抽奖",@"兑换活动"];
    self.imageArray = @[@"",@"",@""];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 160)];
    [_tableView setTableHeaderView:headerView];
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
    }
    [cell.imageView setImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
    [cell.textLabel setText:self.titleArray[indexPath.row]];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

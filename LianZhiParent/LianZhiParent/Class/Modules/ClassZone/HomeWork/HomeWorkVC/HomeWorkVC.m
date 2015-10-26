//
//  HomeWorkVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkVC.h"
#import "HomeWorkListModel.h"
@interface HomeWorkVC ()

@end

@implementation HomeWorkVC

- (UITableViewStyle)tableViewStyle
{
    return UITableViewStyleGrouped;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindTableCell:@"HomeWorkCell" tableModel:@"HomeWorkListModel"];
    [self.tableView reloadData];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSInteger count = self.tableViewModel.modelItemArray.count;
    if(section == count - 1)
        return 10;
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HomeWorkGroup *group = self.tableViewModel.modelItemArray[section];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
    
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:11]];
    [label setTextColor:[UIColor colorWithHexString:@"b7b7b7"]];
    [label setText:group.dateStr];
    
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

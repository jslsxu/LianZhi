//
//  ClassSelectionVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassSelectionVC.h"
#import "ContactModel.h"
#import "ContactItemCell.h"
@interface ClassSelectionVC ()<UITableViewDataSource, UITableViewDelegate>
@end

@implementation ClassSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:kSepLineColor];
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableviewdele

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ContactModel sharedInstance].classKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ContactGroup *group = [ContactModel sharedInstance].classes[section];
    return group.contacts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 25)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, headerView.width - 15, headerView.height)];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"8e8e8e"]];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setText:[ContactModel sharedInstance].classKeys[section]];
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ClassItemCell";
    ClassItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[ClassItemCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        [cell.chatButton setHidden:YES];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.detailTextLabel setTextColor:kCommonTeacherTintColor];
    }
    ContactGroup *group = [ContactModel sharedInstance].classes[indexPath.section];
    ClassInfo *classInfo = group.contacts[indexPath.row];
    [cell setClassInfo:classInfo];
    BOOL isSelected = [self.originalClassID isEqualToString:classInfo.classID];
    if(isSelected)
    {
        [cell.detailTextLabel setText:@"当前"];
        [cell setAccessoryView:nil];
    }
    else
    {
        [cell.detailTextLabel setText:nil];
        [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactGroup *group = [ContactModel sharedInstance].classes[indexPath.section];
    ClassInfo *classInfo = group.contacts[indexPath.row];
    if(self.selection)
        self.selection(classInfo);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

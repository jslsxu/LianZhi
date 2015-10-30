//
//  GrowthTimelineClassChangeVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelineClassChangeVC.h"
#import "GrowthTimelineStudentsSelectVC.h"

@interface GrowthTimelineClassChangeVC ()
@property (nonatomic, strong)NSArray *classArray;
@end

@implementation GrowthTimelineClassChangeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我所有的班";
    NSMutableArray *classArray = [NSMutableArray array];
    if([UserCenter sharedInstance].curSchool.classes.count > 0)
    {
        NSMutableDictionary *group = [NSMutableDictionary dictionary];
        [group setValue:@"我教授的班" forKey:@"groupName"];
        [group setValue:[NSArray arrayWithArray:[UserCenter sharedInstance].curSchool.classes] forKey:@"groupArray"];
        [classArray addObject:group];
    }
    
    if([UserCenter sharedInstance].curSchool.managedClasses.count > 0)
    {
        NSMutableDictionary *group = [NSMutableDictionary dictionary];
        [group setValue:@"我管理的班" forKey:@"groupName"];
        [group setValue:[NSArray arrayWithArray:[UserCenter sharedInstance].curSchool.managedClasses] forKey:@"groupArray"];
        [classArray addObject:group];
    }
    
    self.classArray = classArray;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - 64) style:UITableViewStyleGrouped];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(onSendClicked)];
}
#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.classArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *group = self.classArray[section];
    NSArray *groupArray = group[@"groupArray"];
    return groupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NotificationGroupHeaderView *headerView = [[NotificationGroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
    NSDictionary *groupDic = self.classArray[section];
    [headerView.nameLabel setText:groupDic[@"groupName"]];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"NotificationTargetCell";
    NotificationTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell)
    {
        cell = [[NotificationTargetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    }
    NSDictionary *groupDic = self.classArray[indexPath.section];
    NSArray *groupArray = groupDic[@"groupArray"];
    ClassInfo *classInfo = groupArray[indexPath.row];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",classInfo.students.count]];
    [cell.nameLabel setText:classInfo.className];
    [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *groupDic = self.classArray[indexPath.section];
    NSArray *groupArray = groupDic[@"groupArray"];
    ClassInfo *classInfo = groupArray[indexPath.row];
    GrowthTimelineStudentsSelectVC *studentVC = [[GrowthTimelineStudentsSelectVC alloc] init];
    [studentVC setClassInfo:classInfo];
    [studentVC setRecord:self.record];
    [studentVC setTitle:classInfo.className];
    [self.navigationController pushViewController:studentVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

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
    
    _selectedMateArray = [NSMutableArray array];
    _selectedStudentDic = [NSMutableDictionary dictionary];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - 64) style:UITableViewStyleGrouped];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(onSendClicked)];
}

- (void)onSendClicked
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithJSONObject:self.record] forKey:@"record"];
    
    
    NSMutableArray *classArray = [NSMutableArray array];
    NSArray *keys = _selectedStudentDic.allKeys;
    for (NSString *key in keys)
    {
        NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
        [classDic setValue:key forKey:@"classid"];
        NSMutableArray *studentArray = [NSMutableArray array];
        for (StudentInfo *student in _selectedStudentDic[key])
        {
            [studentArray addObject:student.uid];
        }
        [classDic setValue:studentArray forKey:@"students"];
        if(studentArray.count > 0)
            [classArray addObject:classDic];
    }
    if(classArray.count > 0)
        [params setValue:[NSString stringWithJSONObject:classArray] forKey:@"classes"];
    else
        [ProgressHUD showHintText:@"没有选择班级"];
    //转换
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在提交" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/record" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:NO];
        [ProgressHUD showSuccess:@"发送成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } fail:^(NSString *errMsg) {
        [hud hide:NO];
        [ProgressHUD showHintText:errMsg];
    }];

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
    NSInteger selectNum = 0;
    NSArray *groupArray = groupDic[@"groupArray"];
    for (ClassInfo *classInfo in groupArray)
    {
        if([_selectedStudentDic valueForKey:classInfo.classID])
            selectNum ++;
    }
    if(selectNum == 0)
        [headerView setSelectType:SelectTypeNone];
    else if(selectNum == groupArray.count)
        [headerView setSelectType:SelectTypeAll];
    else
        [headerView setSelectType:SelectTypePart];
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
    NSArray *selectedArray = _selectedStudentDic[classInfo.classID];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)selectedArray.count,classInfo.students.count]];
    [cell.nameLabel setText:classInfo.className];
    [cell.checkButton setSelected:[_selectedStudentDic valueForKey:classInfo.classID]];
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
    [studentVC setOriginalStudentArray:_selectedStudentDic[classInfo.classID]];
    [studentVC setTitle:classInfo.className];
    [studentVC setCompletion:^(NSArray *studentArray) {
        if(studentArray.count > 0)
            [_selectedStudentDic setValue:studentArray forKey:classInfo.classID];
        else
            [_selectedStudentDic removeObjectForKey:classInfo.classID];
        [_tableView reloadData];
    }];
    [self.navigationController pushViewController:studentVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

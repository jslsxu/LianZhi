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
@property (nonatomic, strong)NSMutableArray *selectedArray;
@property (nonatomic, strong)NSArray *classArray;
@end

@implementation GrowthTimelineClassChangeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我所有的班";
    self.selectedArray = [NSMutableArray array];
    self.classArray = [UserCenter sharedInstance].curSchool.allClasses;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height  - 64 - 45) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(onSendClicked)];
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - 45, self.view.width, 45)];
    [bottomView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [self setupBottomView:bottomView];
    [self.view addSubview:bottomView];
}

- (void)setupBottomView:(UIView *)viewParent
{
    _selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectAllButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [_selectAllButton addTarget:self action:@selector(onSelectAllClicked) forControlEvents:UIControlEventTouchUpInside];
    [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllButton setTitle:@"反选" forState:UIControlStateSelected];
    [_selectAllButton setFrame:CGRectMake(0, 0, 50, viewParent.height)];
    [viewParent addSubview:_selectAllButton];
}

- (void)onSelectAllClicked
{
    _selectAllButton.selected = !_selectAllButton.selected;
    [_selectedArray removeAllObjects];
   if(_selectAllButton.selected)
   {
       for (ClassInfo *classInfo in self.classArray) {
           [_selectedArray addObject:classInfo.classID];
       }
   }
    [_tableView reloadData];
}

- (BOOL)hasBeenSelected:(NSString *)classID
{
    for (NSString *selectedClassID in self.selectedArray)
    {
        if([classID isEqualToString:selectedClassID])
            return YES;
    }
    return NO;
}

- (void)onCheckClicked:(UIButton *)button
{
    NotificationTargetCell *cell = (NotificationTargetCell*)[button superview];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    ClassInfo *classInfo = self.classArray[indexPath.row];
    if([self hasBeenSelected:classInfo.classID])
        [self.selectedArray removeObject:classInfo.classID];
    else
        [self.selectedArray addObject:classInfo.classID];
    [_tableView reloadData];
}

- (void)onSendClicked
{
    if(_selectedArray.count == 0)
    {
        [ProgressHUD showHintText:@"你还没有选择班级"];
        return;
    }
    
    NSMutableArray *sendTargetArray = [NSMutableArray array];
    for (NSString *classID in _selectedArray)
    {
        NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
        [classDic setValue:classID forKey:@"classid"];
        [sendTargetArray addObject:classDic];
    }
    NSString *targetStr = [NSString stringWithJSONObject:sendTargetArray];
    if(self.selectionCompletion)
    {
        self.selectionCompletion(targetStr);
    }
    else
    {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:targetStr forKey:@"classes"];
        [params setValue:[NSString stringWithJSONObject:self.record] forKey:@"record"];
        //转换
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在提交" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/record" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:NO];
            [ProgressHUD showSuccess:@"发送成功"];
            UIViewController *baseVC = nil;
            for (UIViewController *vc in self.navigationController.viewControllers)
            {
                if([NSStringFromClass([vc class]) isEqualToString:@"PublishGrowthTimelineVC"])
                    baseVC = vc;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(baseVC)
                    [self.navigationController popToViewController:baseVC animated:YES];
                
            });
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
            [ProgressHUD showHintText:errMsg];
        }];
    }
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.classArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    NotificationGroupHeaderView *headerView = [[NotificationGroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
//    NSDictionary *groupDic = self.classArray[section];
//    [headerView.nameLabel setText:groupDic[@"groupName"]];
//    return headerView;
//}

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
    ClassInfo *classInfo = self.classArray[indexPath.row];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",classInfo.students.count]];
    [cell.nameLabel setText:classInfo.name];
    [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RightArrow"]]];
    [cell.checkButton setSelected:[self hasBeenSelected:classInfo.classID]];
    [cell.checkButton addTarget:self action:@selector(onCheckClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassInfo *classInfo = self.classArray[indexPath.row];
    GrowthTimelineStudentsSelectVC *studentVC = [[GrowthTimelineStudentsSelectVC alloc] init];
    [studentVC setClassInfo:classInfo];
    [studentVC setHomework:self.homework];
    [studentVC setRecord:self.record];
    [studentVC setTitle:classInfo.name];
    [studentVC setSelectionCompletion:self.selectionCompletion];
    [self.navigationController pushViewController:studentVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

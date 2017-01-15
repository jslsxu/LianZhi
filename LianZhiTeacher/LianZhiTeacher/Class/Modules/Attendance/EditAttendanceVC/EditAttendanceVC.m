//
//  EditAttendanceVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "EditAttendanceVC.h"
#import "StudentsAttendanceHeaderView.h"
#import "EditAttendanceCell.h"
#import "StudentsAttendanceListModel.h"
@interface EditAttendanceVC ()
@property (nonatomic, strong)StudentsAttendanceHeaderView* headerView;
@property (nonatomic, strong)StudentsAttendanceListModel* listModel;
@property (nonatomic, strong)MBProgressHUD* hud;
@end

@implementation EditAttendanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self setupTitle];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    
    [self.view addSubview:[self headerView]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString* dateString = [formatter stringFromDate:self.date];
    [self.headerView.titleLabel setText:[NSString stringWithFormat:@"%@ %@",dateString, [Utility weekdayStr:self.date]]];
    [self.tableView setSectionIndexColor:kColor_66];
    [self.tableView setFrame:CGRectMake(0, 70, self.view.width, self.view.height - 70)];
    [self bindTableCell:@"EditAttendanceCell" tableModel:@"StudentsAttendanceListModel"];
     StudentsAttendanceListModel* model = (StudentsAttendanceListModel *)self.tableViewModel;
    [model setAttendaceEdit:YES];
    [self requestData:REQUEST_REFRESH];
}

- (void)setupTitle{
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setNumberOfLines:0];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
    NSMutableAttributedString* titleString = [[NSMutableAttributedString alloc] initWithString:@"编辑考勤\n" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    [titleString appendAttributedString:[[NSAttributedString alloc] initWithString:self.classInfo.name attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}]];
    [titleLabel setAttributedText:titleString];
    [titleLabel sizeToFit];
    [self.navigationItem setTitleView:titleLabel];
}

- (StudentsAttendanceHeaderView *)headerView{
    if(nil == _headerView){
        __weak typeof(self) wself = self;
        _headerView = [[StudentsAttendanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 70)];
        [_headerView setSortCallback:^(NSInteger sortType) {
            if(sortType == 2){
                StudentsAttendanceListModel* model = (StudentsAttendanceListModel *)wself.tableViewModel;
                [model setSortIndex:sortType];
                NSDictionary* modelDic = [model modelDictionary];
                NSInteger count = -1;
                NSArray* keys = [modelDic allKeys];
                NSIndexPath *indexPath;
                for (StudentAttendanceItem* item in model.modelItemArray) {
                    [item setAbsenceHighlighted:NO];
                }
                for (NSString* key in keys) {
                    NSArray* sectionArray = modelDic[key];
                    for (NSInteger i = 0; i < [sectionArray count]; i++) {
                        StudentAttendanceItem* item = sectionArray[i];
                        if(![item normalAttendance]){
                            count++;
                            if(count == model.absenceIndex){
                                [item setAbsenceHighlighted:YES];
                                indexPath = [NSIndexPath indexPathForRow:i inSection:[keys indexOfObject:key]];
                                break;
                            }
                        }
                    }
                }
                
                [wself.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    EditAttendanceCell *cell = [wself.tableView cellForRowAtIndexPath:indexPath];
                    [cell flash];
                });   
            }
        }];
    }
    return _headerView;
}

- (NSString* )dateString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [formatter stringFromDate:self.date];
    return dateString;
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    task.requestUrl = @"leave/nclass";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[self dateString] forKey:@"cdate"];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [task setParams:params];
    return task;
}


- (void)commit{
    if([self.tableViewModel.modelItemArray count] > 0){
        MBProgressHUD* hud = [MBProgressHUD showMessag:@"" toView:nil];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.classInfo.classID forKey:@"class_id"];
        [params setValue:[self dateString] forKey:@"cdate"];
        NSMutableArray* leaveArray = [NSMutableArray array];
        for (StudentAttendanceItem* item in self.tableViewModel.modelItemArray) {
            if([item edited]){
                [leaveArray addObject:[item attedanceInfo]];
            }
        }
        [params setValue:[leaveArray modelToJSONString] forKey:@"leave_json"];
        
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"leave/neditleave" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:NO];
            [ProgressHUD showHintText:@"编辑考勤成功"];
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
        }];
    }

}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, headerView.width - 10 * 2, headerView.height)];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [headerLabel setTextColor:kColor_66];
    StudentsAttendanceListModel* model = (StudentsAttendanceListModel *)self.tableViewModel;
    NSArray* titleArray = [model titleArray];
    [headerLabel setText:titleArray[section]];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    StudentsAttendanceListModel* model = (StudentsAttendanceListModel *)self.tableViewModel;
    return [model titleArray];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    EditAttendanceCell* attendanceCell = (EditAttendanceCell *)cell;
    [attendanceCell setAttendanceChanged:^{
        [wself.tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)TNBaseTableViewControllerRequestStart{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)TNBaseTableViewControllerRequestSuccess{
    [self.hud hide:NO];
    [self showEmptyView:[self.tableViewModel.modelItemArray count] == 0];
    StudentsAttendanceListModel* model = (StudentsAttendanceListModel *)self.tableViewModel;
    [self.headerView.nameButton setTitle:[NSString stringWithFormat:@"姓名(%zd)", [self.tableViewModel.modelItemArray count]] forState:UIControlStateNormal];
    [self.headerView.attendanceButton setTitle:[NSString stringWithFormat:@"出勤(%zd)", model.info.attendance] forState:UIControlStateNormal];
    [self.headerView.offButton setTitle:[NSString stringWithFormat:@"缺勤(%zd)", [model.info absence]] forState:UIControlStateNormal];
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg{
    [self.hud hide:NO];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

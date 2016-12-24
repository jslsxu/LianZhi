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
@interface EditAttendanceVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)StudentsAttendanceHeaderView* headerView;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)NSMutableArray* notes;
@property (nonatomic, strong)NSMutableArray* indexTitleArray;
@end

@implementation EditAttendanceVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.notes = [NSMutableArray array];
        self.indexTitleArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 20; i++) {
            StudentAttendanceItem* attendaceItem = [[StudentAttendanceItem alloc] init];
            [self.notes addObject:attendaceItem];
            [self.indexTitleArray addObject:[attendaceItem.studentInfo.name substringToIndex:1]];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self setupTitle];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    
    [self.view addSubview:[self headerView]];
    [self.headerView.titleLabel setText:@"2016年3月4日 星期五"];
    
    [self.view addSubview:[self tableView]];
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
        _headerView = [[StudentsAttendanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 70)];
    }
    return _headerView;
}

- (UITableView *)tableView{
    if(nil == _tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, self.view.width, self.view.height - 70) style:UITableViewStylePlain];
        [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setSectionIndexColor:kColor_66];
    }
    return _tableView;
}

- (void)commit{
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.notes count];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexTitleArray;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.indexTitleArray[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentAttendanceItem* attendanceItem = self.notes[indexPath.section];
    return [EditAttendanceCell cellHeight:attendanceItem cellWidth:tableView.width].floatValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseID = @"EditAttendanceCell";
    EditAttendanceCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell){
        cell = [[EditAttendanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    StudentAttendanceItem* attendanceItem = self.notes[indexPath.section];
    [cell setAttendanceItem:attendanceItem];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

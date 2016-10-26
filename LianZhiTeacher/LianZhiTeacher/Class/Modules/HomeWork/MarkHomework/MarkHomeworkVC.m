//
//  MarkHomeworkVC.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "MarkHomeworkVC.h"
#import "HomeworkMarkHeaderView.h"
#import "HomeworkMarkFooterView.h"
#import "ZYBannerView.h"


@interface MarkHomeworkVC ()<ZYBannerViewDelegate, ZYBannerViewDataSource, HomeworkMarkHeaderDelegate>
@property (nonatomic, strong)HomeworkMarkHeaderView*    headerView;
@property (nonatomic, strong)ZYBannerView*              circleView;
@property (nonatomic, strong)HomeworkMarkFooterView*    footerView;
@property (nonatomic, strong)HomeworkMarkItem*          markItem;
@property (nonatomic, strong)NSMutableDictionary*       markMap;
@end

@implementation MarkHomeworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.markItem = [[HomeworkMarkItem alloc] init];
    self.title = @"批阅作业";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"批阅" style:UIBarButtonItemStylePlain target:self action:@selector(mark)];
    [self.view addSubview:[self headerView]];
    [self.view addSubview:[self footerView]];
    [self.view addSubview:[self circleView]];
    
    [self showHomeworkWithIndex:self.curIndex];
    
    for (HomeworkStudentInfo *studentInfo in self.homeworkArray) {
        HomeworkTeacherMark* teacherMark = [[HomeworkTeacherMark alloc] initWithPhotoArray:studentInfo.s_answer.pics];
        [self.markMap setValue:teacherMark forKey:studentInfo.student.uid];
    }
}

- (NSMutableDictionary *)markMap{
    if(_markMap == nil){
        _markMap = [NSMutableDictionary dictionary];
    }
    return _markMap;
}

- (void)mark{
    __weak typeof(self) wself = self;
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    if(![studentInfo.s_answer marked]){
        HomeworkTeacherMark *mark = self.markMap[studentInfo.student.uid];
        if(![mark isEmpty]){
            NSString *markDetail = [mark modelToJSONString];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:markDetail forKey:@"mark_detail"];
            [params setValue:self.homeworkItem.hid forKey:@"eid"];
            [params setValue:studentInfo.student.uid forKey:@"child_id"];
            [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/marking" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
                [studentInfo setMark_detail:markDetail];
                [wself.navigationItem.rightBarButtonItem setEnabled:NO];
            } fail:^(NSString *errMsg) {
                
            }];
        }
       
    }
}

- (HomeworkMarkHeaderView *)headerView{
    if(_headerView == nil){
        _headerView = [[HomeworkMarkHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 110)];
    }
    return _headerView;
}

- (ZYBannerView *)circleView{
    if(_circleView == nil){
        _circleView = [[ZYBannerView alloc] initWithFrame:CGRectMake(0, [self.headerView bottom], self.view.width, self.view.height - 120 - 64 - (self.headerView.bottom))];
        [_circleView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
        [_circleView setDelegate:self];
        [_circleView setDataSource:self];

    }
    return _circleView;
}

- (HomeworkMarkFooterView *)footerView{
    if(_footerView == nil){
        _footerView = [[HomeworkMarkFooterView alloc] initWithFrame:CGRectMake(0, self.view.height - 120 - 64, self.view.width, 120)];
    }
    return _footerView;
}

- (void)showHomeworkWithIndex:(NSInteger)index{
    self.curIndex = index;
    [self.headerView setCanPre:self.curIndex > 0];
    [self.headerView setCanNext:self.curIndex < [self.homeworkArray count] - 1];
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    [self.navigationItem.rightBarButtonItem setEnabled:[studentInfo.mark_detail length] == 0];
    
    [self.headerView setStudentHomeworkInfo:studentInfo];
    [self.circleView reloadData];
}

#pragma mark - HomeworkMarkHeaderDelegate
- (void)requestPreHomework{
    if(self.curIndex > 0){
        [self showHomeworkWithIndex:self.curIndex - 1];
    }
}

- (void)requestNextHomework{
    if(self.curIndex < [self.homeworkArray count] - 1){
        [self showHomeworkWithIndex:self.curIndex + 1];
    }
}

#pragma mark - ZYbannerDelegate
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner{
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    HomeworkTeacherMark* teacherMark = self.markMap[studentInfo.student.uid];
    return [teacherMark.marks count];
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index{
    HomeworkPhotoImageView *imageView = [[HomeworkPhotoImageView alloc] initWithFrame:banner.bounds];
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    HomeworkTeacherMark* teacherMark = self.markMap[studentInfo.student.uid];
    [imageView setMarkItem:teacherMark.marks[index]];
    return imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

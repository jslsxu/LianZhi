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
}

- (void)mark{
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    if(![studentInfo.reply marked]){
        HomeworkTeacherMark *mark = [studentInfo.reply teacherMark];
        NSString *markDetail = [mark modelToJSONString];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:markDetail forKey:@"mark_detail"];
        [params setValue:self.homeworkItem.hid forKey:@"eid"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/marking" method:REQUEST_POST type:REQUEST_REFRESH withParams:@{} observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [studentInfo setMark_detail:markDetail];
        } fail:^(NSString *errMsg) {
            
        }];
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
    HomeworkStudentInfo *studentInfo = self.homeworkArray[self.curIndex];
    [self.navigationItem.rightBarButtonItem setEnabled:![studentInfo.reply marked]];
    
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
    return 1;
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index{
    HomeworkPhotoImageView *imageView = [[HomeworkPhotoImageView alloc] initWithFrame:banner.bounds];
    [imageView setMarkItem:self.markItem];
    return imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

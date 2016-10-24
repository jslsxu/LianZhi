//
//  HomeworkDetailVC.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkDetailVC.h"
#import "HomeworkStudentAnswer.h"
#import "HomeworkTeacherMark.h"
@interface HomeworkDetailVC ()
@property (nonatomic, strong)HomeworkItem*  homeworkItem;
@property (nonatomic, strong)UISegmentedControl*    segCtrl;
@property (nonatomic, strong)HomeworkDetailView*    homeworkDetailView;
@property (nonatomic, strong)HomeworkFinishView*    homeworkFinishView;
@property (nonatomic, strong)HomeworkStudentAnswer* reply;          //作业回复
@property (nonatomic, strong)HomeworkTeacherMark*   teacherMark;    //作业批阅
@end

@implementation HomeworkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitleView:[self segCtrl]];
    self.homeworkItem = [[HomeworkItem alloc] init];
    [self.view addSubview:[self homeworkDetailView]];
    [self.view addSubview:[self homeworkFinishView]];
    [[self segCtrl] setSelectedSegmentIndex:0];
    [self onSegValueChanged];
}

- (UISegmentedControl *)segCtrl{
    if(_segCtrl == nil){
        _segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"作业详情", @"完成作业"]];
        [_segCtrl addTarget:self action:@selector(onSegValueChanged) forControlEvents:UIControlEventValueChanged];
        [_segCtrl setWidth:140];
    }
    return _segCtrl;
}

- (HomeworkDetailView *)homeworkDetailView{
    if(_homeworkDetailView == nil){
        _homeworkDetailView = [[HomeworkDetailView alloc] initWithFrame:self.view.bounds];
        [_homeworkDetailView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_homeworkDetailView setHomeworkItem:self.homeworkItem];
    }
    return _homeworkDetailView;
}

- (HomeworkFinishView *)homeworkFinishView{
    if(_homeworkFinishView == nil){
        _homeworkFinishView = [[HomeworkFinishView alloc] initWithFrame:self.view.bounds];
        [_homeworkFinishView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    }
    return _homeworkFinishView;
}

- (void)onSegValueChanged{
    NSInteger selectedIndex = self.segCtrl.selectedSegmentIndex;
    [self.homeworkDetailView setHidden:selectedIndex != 0];
    [self.homeworkFinishView setHidden:selectedIndex != 1];
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    [self.homeworkDetailView setHomeworkItem:_homeworkItem];
    
}


- (void)requestHomeworkDetail{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.homeworkId forKey:@"eid"];
    
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/detail" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

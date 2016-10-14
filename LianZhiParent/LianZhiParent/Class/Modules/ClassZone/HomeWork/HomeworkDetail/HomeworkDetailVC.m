//
//  HomeworkDetailVC.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkDetailVC.h"

@interface HomeworkDetailVC ()
@property (nonatomic, strong)UISegmentedControl*    segCtrl;
@property (nonatomic, strong)HomeworkDetailView*    homeworkDetailView;
@property (nonatomic, strong)HomeworkFinishView*    homeworkFinishView;
@end

@implementation HomeworkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitleView:[self segCtrl]];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

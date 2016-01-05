//
//  MyHomeworkList.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "MyHomeworkList.h"

@interface MyHomeworkList ()

@end

@implementation MyHomeworkList

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"我的作业库";
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [headerView setBackgroundColor:[UIColor colorWithHexString:@"0fabc1"]];
    
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"历史记录",@"收藏"]];
    [_segmentControl setTintColor:[UIColor colorWithHexString:@"96e065"]];
    [_segmentControl setFrame:CGRectMake((headerView.width - 160) / 2, (headerView.height - 30) / 2, 160, 30)];
    [_segmentControl addTarget:self action:@selector(onSegmentValueChanged) forControlEvents:UIControlEventValueChanged];
    [_segmentControl setSelectedSegmentIndex:0];
    [headerView addSubview:_segmentControl];
    [self.view addSubview:headerView];
    
    _historyVC = [[HomeWorkHistoryVC alloc] init];
    [_historyVC setCompletion:self.completion];
    _collectionVC = [[HomeWorkCollectionVC alloc] init];
    [_historyVC setCompletion:self.completion];
    [_historyVC.view setHidden:NO];
    [_collectionVC.view setHidden:YES];
}

- (void)onSegmentValueChanged
{
    NSInteger selectedIndex = _segmentControl.selectedSegmentIndex;
    [_historyVC.view setHidden:selectedIndex != 0];
    [_collectionVC.view setHidden:selectedIndex != 1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

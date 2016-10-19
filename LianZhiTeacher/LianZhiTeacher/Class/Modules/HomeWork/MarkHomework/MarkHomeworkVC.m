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
@interface MarkHomeworkVC ()<ZYBannerViewDelegate, ZYBannerViewDataSource>
@property (nonatomic, strong)HomeworkItem*              homeworkItem;
@property (nonatomic, strong)HomeworkMarkHeaderView*    headerView;
@property (nonatomic, strong)ZYBannerView*              circleView;
@property (nonatomic, strong)HomeworkMarkFooterView*    footerView;
@end

@implementation MarkHomeworkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"批阅作业";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"批阅" style:UIBarButtonItemStylePlain target:self action:@selector(mark)];
    [self.view addSubview:[self headerView]];
    [self.view addSubview:[self footerView]];
    [self.view addSubview:[self circleView]];
}

- (void)mark{
    
}

- (HomeworkMarkHeaderView *)headerView{
    if(_headerView == nil){
        _headerView = [[HomeworkMarkHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 110)];
    }
    [_headerView setHomeworkItem:self.homeworkItem];
    return _headerView;
}

- (ZYBannerView *)circleView{
    if(_circleView == nil){
        _circleView = [[ZYBannerView alloc] initWithFrame:CGRectMake(0, [self.headerView bottom], self.view.width, self.footerView.top)];
        [_circleView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    }
    return _circleView;
}

- (HomeworkMarkFooterView *)footerView{
    if(_footerView == nil){
        _footerView = [[HomeworkMarkFooterView alloc] initWithFrame:CGRectMake(0, self.view.height - 120, self.view.width, 120)];
        [_footerView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    }
    return _footerView;
}

#pragma mark - ZYbannerDelegate
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner{
    return 3;
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index{
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

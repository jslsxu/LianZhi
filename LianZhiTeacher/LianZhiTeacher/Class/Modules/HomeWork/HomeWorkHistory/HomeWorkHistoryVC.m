//
//  HomeWorkHistoryVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkHistoryVC.h"
#import "HomeWorkDetailVC.h"
@interface HomeWorkHistoryVC ()<ActionSelectViewDelegate>
@property (nonatomic, copy)NSString *course;
@property (nonatomic, strong)NSMutableArray *courseArray;
@end

@implementation HomeWorkHistoryVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self bindTableCell:@"HomeWorkHistoryCell" tableModel:@"HomeWorkHistoryModel"];
    [self setSupportPullDown:NO];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFavChanged:) name:kAddFavNotification object:nil];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"practice/get_list"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    HomeWorkHistoryModel *model = (HomeWorkHistoryModel *)self.tableViewModel;
    if(REQUEST_GETMORE == requestType)
        [params setValue:[model maxID] forKey:@"max_id"];
    [task setParams:params];
    [task setObserver:self];
    return task;
    
}

- (void)onFavChanged:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    HomeWorkItem *item = userInfo[kPractiseItemKey];
    for (NSInteger i = 0; i < self.tableViewModel.modelItemArray.count; i++)
    {
        HomeWorkItem *targetItem = self.tableViewModel.modelItemArray[i];
        if([item.homeworkId isEqualToString:targetItem.homeworkId])
        {
            targetItem.fav = item.fav;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    HomeWorkItem *homeWorkItem = (HomeWorkItem *)modelItem;
    HomeWorkDetailVC *detailVC = [[HomeWorkDetailVC alloc] init];
    [detailVC setHomeworkID:homeWorkItem.homeworkId];
    [detailVC setCompletion:self.completion];
    [CurrentROOTNavigationVC pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

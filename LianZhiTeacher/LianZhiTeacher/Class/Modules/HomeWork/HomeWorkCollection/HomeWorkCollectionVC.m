//
//  HomeWorkCollectionVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/11/27.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkCollectionVC.h"
#import "HomeWorkDetailVC.h"
NSString *const kCollectionStatusChangedNotification = @"CollectionStatusChangedNotification";
@interface HomeWorkCollectionVC ()

@end

@implementation HomeWorkCollectionVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self bindTableCell:@"HomeWorkHistoryCell" tableModel:@"HomeWorkCollectionModel"];
    [self setSupportPullDown:NO];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFavChanged:) name:kAddFavNotification object:nil];
}


- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"practice/get_fav"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    if(requestType == REQUEST_GETMORE)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        HomeWorkCollectionModel *model = (HomeWorkCollectionModel *)self.tableViewModel;
        [params setValue:[model maxID] forKey:@"max_id"];
        
        [task setParams:params];
    }
    [task setObserver:self];
    return task;
    
}
- (void)onFavChanged:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    HomeWorkItem *item = userInfo[kPractiseItemKey];
    if(item.fav)
        [self requestData:REQUEST_REFRESH];
    else
    {
        for (NSInteger i = 0; i < self.tableViewModel.modelItemArray.count; i++)
        {
            HomeWorkItem *targetItem = self.tableViewModel.modelItemArray[i];
            if([item.homeworkId isEqualToString:targetItem.homeworkId])
            {
                targetItem.fav = item.fav;
                if(!targetItem.fav)
                {
                    [self.tableViewModel.modelItemArray removeObject:targetItem];
                    [self.tableView reloadData];
                }
            }
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

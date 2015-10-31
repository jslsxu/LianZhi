//
//  ClassAppVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassAppVC.h"
#import "GrowthTimelineVC.h"
#import "ContactListVC.h"
#import "CourseListVC.h"
@interface ClassAppVC ()

@end

@implementation ClassAppVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self setCellName:@"ClassAppCell"];
        [self setModelName:@"ClassAppModel"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"班应用";
    [self.collectionView setScrollEnabled:NO];
    [self requestData:REQUEST_REFRESH];
}

- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewLayout *)layout
{
    NSInteger itemSize = (self.view.width - 15 * 2 - 10 * 2) / 3;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    [flowLayout setItemSize:CGSizeMake(itemSize, itemSize)];
    [flowLayout setMinimumInteritemSpacing:10];
    [flowLayout setMinimumLineSpacing:10];
    [flowLayout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"class/app_list"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [task setParams:params];
    [task setObserver:self];
    return task;
}

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),self.classInfo.classID];
}

- (void)TNBaseTableViewControllerRequestStart
{
    [self startLoading];
}

- (void)TNBaseTableViewControllerRequestSuccess
{
    [self endLoading];
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg
{
    [self endLoading];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    CourseListVC *courseListVC = [[CourseListVC alloc] init];
    [CurrentROOTNavigationVC pushViewController:courseListVC animated:YES];
    return;
    ClassAppItem *appItem = (ClassAppItem *)modelItem;
    NSString *actionUrl = appItem.actionUrl;
    if([actionUrl length] > 0)
    {
        NSURL *hyperLink = [NSURL URLWithString:actionUrl];
        if(hyperLink)
        {
            NSString *scheme = hyperLink.scheme;
            NSString *host = hyperLink.host;
            if([scheme isEqualToString:@"http"])
            {
                TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] init];
                [webVC setUrl:actionUrl];
                [webVC setTitle:appItem.appName];
                [self.navigationController pushViewController:webVC animated:YES];
            }
            else if([scheme isEqualToString:@"lianzhi"])
            {
                if([host isEqualToString:@"contact"])
                {
                    ContactListVC *contactVC = [[ContactListVC alloc] init];
                    [self.navigationController pushViewController:contactVC animated:YES];
                }
                else if([host isEqualToString:@"record"])
                {
                    GrowthTimelineVC *recordVC = [[GrowthTimelineVC alloc] init];
                    [recordVC setClassInfo:self.classInfo];
                    [self.navigationController pushViewController:recordVC animated:YES];
                }
//                else if ([host isEqualToString:@"vacation"])
//                {
//                    RequestVacationVC *vacationVC = [[RequestVacationVC alloc] init];
//                    [self.navigationController pushViewController:vacationVC animated:YES];
//                }
//                else if([host isEqualToString:@"homework"])
//                {
//                    CourseListVC *courseListVC = [[CourseListVC alloc] init];
//                    [self.navigationController pushViewController:courseListVC animated:YES];
//                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

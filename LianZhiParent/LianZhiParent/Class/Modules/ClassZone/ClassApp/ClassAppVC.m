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
#import "VacationHistoryVC.h"
#import "HomeWorkVC.h"
#import "ClassZoneVC.h"
#import "ClassAlbumVC.h"
#import "ClassSelectionVC.h"
#import "LZAccountVC.h"

@implementation ClassAppVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self setCellName:@"ClassAppCell"];
        [self setModelName:@"ClassAppModel"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurChildChanged) name:kUserCenterChangedCurChildNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSupportPullDown:YES];
    [self requestData:REQUEST_REFRESH];
}

- (void)onCurChildChanged
{
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
    [task setRequestUrl:@"class/app_list_all"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    [task setObserver:self];
    return task;
}

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),[UserCenter sharedInstance].curChild.uid];
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
    ClassSelectionVC *classSelectionVC = [[ClassSelectionVC alloc] init];
    [classSelectionVC setSelection:^(ClassInfo *classInfo) {
        VacationHistoryVC *vacationHistoryVC = [[VacationHistoryVC alloc] init];
        [vacationHistoryVC setClassInfo:classInfo];
        [CurrentROOTNavigationVC pushViewController:vacationHistoryVC animated:YES];
    }];
    [CurrentROOTNavigationVC pushViewController:classSelectionVC animated:YES];
//    LZAccountVC *accountVC = [[LZAccountVC alloc] init];
//    [CurrentROOTNavigationVC pushViewController:accountVC animated:YES];
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
                NSArray *classArray = [UserCenter sharedInstance].curChild.classes;
                if(classArray.count == 0)
                    [ProgressHUD showHintText:@"孩子不在任何班级"];
                else if(classArray.count == 1)
                {
                    ClassInfo *classInfo = classArray[0];
                    if([host isEqualToString:@"class"])
                    {
                        ClassZoneVC *classZoneVC = [[ClassZoneVC alloc] init];
                        [classZoneVC setClassInfo:classInfo];
                        [CurrentROOTNavigationVC pushViewController:classZoneVC animated:YES];
                    }
                    else if([host isEqualToString:@"class_album"])
                    {
                        ClassAlbumVC *photoBrowser = [[ClassAlbumVC alloc] init];
                        [photoBrowser setShouldShowEmptyHint:YES];
                        [photoBrowser setClassID:classInfo.classID];
                        [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
                    }
                    else if([host isEqualToString:@"record"])
                    {
                        GrowthTimelineVC *growthTimeLineVC = [[GrowthTimelineVC alloc] init];
                        [growthTimeLineVC setClassInfo:classInfo];
                        [CurrentROOTNavigationVC pushViewController:growthTimeLineVC animated:YES];
                    }
                }
                else
                {
                    ClassSelectionVC *classSelectionVC = [[ClassSelectionVC alloc] init];
                    [classSelectionVC setSelection:^(ClassInfo *classInfo) {
                        if([host isEqualToString:@"class"])
                        {
                            ClassZoneVC *classZoneVC = [[ClassZoneVC alloc] init];
                            [classZoneVC setClassInfo:classInfo];
                            [CurrentROOTNavigationVC pushViewController:classZoneVC animated:YES];
                        }
                        else if([host isEqualToString:@"class_album"])
                        {
                            ClassAlbumVC *photoBrowser = [[ClassAlbumVC alloc] init];
                            [photoBrowser setShouldShowEmptyHint:YES];
                            [photoBrowser setClassID:classInfo.classID];
                            [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
                        }
                        else if([host isEqualToString:@"record"])
                        {
                            GrowthTimelineVC *growthTimeLineVC = [[GrowthTimelineVC alloc] init];
                            [growthTimeLineVC setClassInfo:classInfo];
                            [CurrentROOTNavigationVC pushViewController:growthTimeLineVC animated:YES];
                        }
                    }];
                    [CurrentROOTNavigationVC pushViewController:classSelectionVC animated:YES];
                }
                
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

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

@interface ClassAppVC ()
@property (nonatomic, copy)NSString *classBadge;    //班博客
@property (nonatomic, assign)NSInteger recordNum;       //成长记录
@property (nonatomic, assign)NSInteger appPractice; //练习
@end

@implementation ClassAppVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self setCellName:@"ClassAppCell"];
        [self setModelName:@"ClassAppModel"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCurChildChanged) name:kUserCenterChangedCurChildNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
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

- (void)onStatusChanged
{
    NSArray *classRecordArray = [UserCenter sharedInstance].statusManager.classRecordArray;
    NSInteger recordNum = 0;
    for (ClassFeedNotice *noticeItem in classRecordArray)
    {
        recordNum += noticeItem.num;
    }
    self.recordNum = recordNum;
    
    NSArray *classNewCommentArray = [UserCenter sharedInstance].statusManager.classNewCommentArray;
    NSInteger classZoneNum = 0;
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curChild.classes)
    {
        NSString *classID = classInfo.classID;
        for (TimelineCommentItem *item in classNewCommentArray)
        {
            if([item.objid isEqualToString:classID])
            {
                classZoneNum = item.alertInfo.num;
                break;
            }
        }
    }
    if(classZoneNum > 0)
        self.classBadge = kStringFromValue(classZoneNum);
    else
    {
        for (ClassFeedNotice *notice in [UserCenter sharedInstance].statusManager.feedClassesNew)
        {
            classZoneNum += notice.num;
        }
        
        if(classZoneNum > 0)
            self.classBadge = @"";
        else
            self.classBadge = nil;
    }

    
    for (ClassAppItem *appItem in self.collectionViewModel.modelItemArray)
    {
        NSURL *url = [NSURL URLWithString:appItem.actionUrl];
        if([url.host isEqualToString:@"record"])
        {
            if(self.recordNum > 0)
                appItem.badge = @"";
            else
                appItem.badge = nil;
        }
        if([url.host isEqualToString:@"class"])
        {
            appItem.badge = self.classBadge;
        }
        if([url.host isEqualToString:@"practice"])
        {
            appItem.badge = [UserCenter sharedInstance].statusManager.practiceNum > 0 ? @"" : nil;
        }
    }
    [self.collectionView reloadData];
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
    for (ClassAppItem *appItem in self.collectionViewModel.modelItemArray)
    {
        NSURL *url = [NSURL URLWithString:appItem.actionUrl];
        if([url.host isEqualToString:@"record"])
        {
            if(self.recordNum > 0)
                appItem.badge = @"";
            else
                appItem.badge = nil;
        }
        if([url.host isEqualToString:@"class"])
        {
            appItem.badge = self.classBadge;
        }
        
        if([url.host isEqualToString:@"practice"])
        {
            appItem.badge = [UserCenter sharedInstance].statusManager.practiceNum > 0 ? @"" : nil;
        }
    }

    [self endLoading];
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg
{
    [self endLoading];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
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
                BOOL needSelectClass = NO;
                NSString *paramString = hyperLink.parameterString;
                if(paramString.length > 0) {
                    NSArray *params = [paramString componentsSeparatedByString:@"&"];
                    for (NSString *str in params) {
                        NSArray *paramPair = [str componentsSeparatedByString:@"="];
                        if(paramPair.count > 0) {
                            if([paramPair[0] isEqualToString:@"userClassId"])
                            {
                                if(paramPair.count == 1)//没有值
                                {
                                    needSelectClass = YES;
                                }
                            }
                        }
                    }
                }
                
                void (^openWebVC)(NSString *) = ^(NSString *url){
                    TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] init];
                    [webVC setUrl:url];
                    [webVC setTitle:appItem.appName];
                    [self.navigationController pushViewController:webVC animated:YES];
                };
                
                if(needSelectClass) {
                    NSArray *classArray = [UserCenter sharedInstance].curChild.classes;
                    if(classArray.count == 1) {
                        ClassInfo *classInfo = classArray[0];
                        NSString *classId = classInfo.classID;
                        NSString *url = [actionUrl stringByReplacingOccurrencesOfString:@"userClassId=" withString:[NSString stringWithFormat:@"userClassId=%@",classId]];
                        openWebVC(url);
                    }
                    else {
                        ClassSelectionVC *classSelectionVC = [[ClassSelectionVC alloc] init];
                        [classSelectionVC setSelection:^(ClassInfo *classInfo) {
                            NSString *classId = classInfo.classID;
                            NSString *url = [actionUrl stringByReplacingOccurrencesOfString:@"userClassId=" withString:[NSString stringWithFormat:@"userClassId=%@",classId]];
                            openWebVC(url);
                        }];
                        [CurrentROOTNavigationVC pushViewController:classSelectionVC animated:YES];
                    }
                }
                else {
                    openWebVC(actionUrl);
                }
            
            }
            else if([scheme isEqualToString:@"lianzhi"])
            {
                if([host isEqualToString:@"account"])
                {
                    LZAccountVC *accountVC = [[LZAccountVC alloc] init];
                    [self.navigationController pushViewController:accountVC animated:YES];
                }
                else
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
                        else if([host isEqualToString:@"practice"])
                        {
                            HomeWorkVC *homeWorkVC = [[HomeWorkVC alloc] init];
                            [homeWorkVC setClassID:classInfo.classID];
                            [CurrentROOTNavigationVC pushViewController:homeWorkVC animated:YES];
                        }
                        else if([host isEqualToString:@"leave"])
                        {
                            VacationHistoryVC *vacationHistoryVC = [[VacationHistoryVC alloc] init];
                            [vacationHistoryVC setClassInfo:classInfo];
                            [CurrentROOTNavigationVC pushViewController:vacationHistoryVC animated:YES];
                        }
                    }
                    else
                    {
                        ClassSelectionVC *classSelectionVC = [[ClassSelectionVC alloc] init];
                        NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
                        if([host isEqualToString:@"class"])//班博客
                        {
                            NSArray *feedClassNewArray = [UserCenter sharedInstance].statusManager.feedClassesNew;
                            NSArray *classNewCommentArray = [UserCenter sharedInstance].statusManager.classNewCommentArray;
                            for (ClassInfo *classInfo in [UserCenter sharedInstance].curChild.classes)
                            {
                                NSString *classID = classInfo.classID;
                                NSString *badge = nil;
                                NSInteger count = 0;
                                for (TimelineCommentItem *commentItem in classNewCommentArray)
                                {
                                    if([commentItem.objid isEqualToString:classID])
                                        count += commentItem.alertInfo.num;
                                }
                                if(count > 0)
                                    badge = kStringFromValue(count);
                                else
                                {
                                    for (ClassFeedNotice *notice in feedClassNewArray)
                                    {
                                        if([notice.classID isEqualToString:classID])
                                            count += notice.num;
                                    }
                                    if(count > 0)
                                        badge = @"";
                                }
                                [classDic setValue:badge forKey:classID];
                            }
                        }
                        else if ([host isEqualToString:@"practice"])
                        {
                            for (NSString *key in [UserCenter sharedInstance].statusManager.appPractice.allKeys) {
                                NSInteger num = [[UserCenter sharedInstance].statusManager.appPractice[key] integerValue];
                                if(num > 0)
                                    [classDic setValue:@"" forKey:key];
                            }
                            [classSelectionVC setIsHomework:YES];
                        }
                        
                        [classSelectionVC setClassDic:classDic];
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
                            else if([host isEqualToString:@"practice"])
                            {
                                HomeWorkVC *homeWorkVC = [[HomeWorkVC alloc] init];
                                [homeWorkVC setClassID:classInfo.classID];
                                [CurrentROOTNavigationVC pushViewController:homeWorkVC animated:YES];
                            }
                            else if([host isEqualToString:@"leave"])
                            {
                                VacationHistoryVC *vacationHistoryVC = [[VacationHistoryVC alloc] init];
                                [vacationHistoryVC setClassInfo:classInfo];
                                [CurrentROOTNavigationVC pushViewController:vacationHistoryVC animated:YES];
                            }
                        }];
                        [CurrentROOTNavigationVC pushViewController:classSelectionVC animated:YES];
                    }

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

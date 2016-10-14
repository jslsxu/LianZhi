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
#import "AttendanceDetailVC.h"
#import "HomeWorkVC.h"
#import "ClassZoneVC.h"
#import "ClassAlbumVC.h"
#import "ClassSelectionVC.h"
#import "LZAccountVC.h"
#import "TreeHouseVC.h"
#import "ClassAppCell.h"
#define ClassIdKey                  @"userClassId"
#define kBannerHeight               (kScreenWidth * 29 / 64)

@implementation ApplicationBoxHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _bannerView = [[ZYBannerView alloc] initWithFrame:self.bounds];
        [_bannerView setDelegate:self];
        [_bannerView setDataSource:self];
        [_bannerView setShouldLoop:YES];
        [_bannerView setAutoScroll:YES];
        [_bannerView setScrollInterval:5];
        [self addSubview:_bannerView];
    }
    return self;
}

- (void)updateWithHeight:(CGFloat)height{
    [_bannerView setFrame:CGRectMake(0, self.height - height, self.width, height)];
}

- (void)setBannerArray:(NSArray *)bannerArray{
    if(_bannerArray != bannerArray){
        _bannerArray = bannerArray;
        [_bannerView reloadData];
    }
}

#pragma mark - ZYBannerViewDelegate

- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner{
    return self.bannerArray.count;
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index{
    BannerItem *bannerItem = self.bannerArray[index];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:banner.bounds];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView sd_setImageWithURL:[NSURL URLWithString:bannerItem.pic] placeholderImage:nil];
    return imageView;
}

- (void)banner:(ZYBannerView *)banner didSelectItemAtIndex:(NSInteger)index{
    BannerItem *bannerItem = self.bannerArray[index];
    if(bannerItem.url){
        TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:bannerItem.url]];
        [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
    }
}

@end


@interface ClassAppVC ()
@property (nonatomic, copy)NSString *classBadge;    //班博客
@property (nonatomic, assign)NSInteger recordNum;       //成长记录
@property (nonatomic, assign)NSInteger appPractice; //练习
@property (nonatomic, weak)ApplicationBoxHeaderView*    headerView;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItems = [ApplicationDelegate.homeVC commonLeftBarButtonItems];
    [self requestData:REQUEST_REFRESH];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationItem setLeftBarButtonItems:nil];
}
- (void)setTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setTextColor:[UIColor colorWithHexString:@"252525"]];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setText:title];
    [label sizeToFit];
    [self.navigationItem setTitleView:label];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班应用";
    // Do any additional setup after loading the view.
    [self.collectionView registerClass:[ApplicationBoxHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ApplicationBoxHeaderView"];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
}

- (void)onCurChildChanged
{
    [self requestData:REQUEST_REFRESH];
}

- (void)onStatusChanged
{
//    NSArray *classRecordArray = [UserCenter sharedInstance].statusManager.classRecordArray;
//    NSInteger recordNum = 0;
//    for (ClassFeedNotice *noticeItem in classRecordArray)
//    {
//        recordNum += noticeItem.num;
//    }
    self.recordNum = [[UserCenter sharedInstance].statusManager newCountForClassRecord];
    
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
//        for (ClassFeedNotice *notice in [UserCenter sharedInstance].statusManager.feedClassesNew)
//        {
//            if([notice.childID isEqualToString:[UserCenter sharedInstance].curChild.uid]){
//                classZoneNum += notice.num;
//            }
//        }
        classZoneNum += [[UserCenter sharedInstance].statusManager newCountForClassFeed];
        
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
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    [flowLayout setItemSize:CGSizeMake(self.view.width / 4, [ClassAppCell cellHeight])];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.width, kBannerHeight)];
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
    return @"classApp";
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
                NSString *paramString = hyperLink.query;
                if(paramString.length > 0) {
                    NSArray *params = [paramString componentsSeparatedByString:@"&"];
                    for (NSString *str in params) {
                        NSArray *paramPair = [str componentsSeparatedByString:@"="];
                        if(paramPair.count > 0) {
                            if([paramPair[0] isEqualToString:ClassIdKey])
                            {
                                NSString *value = [paramPair[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                if(value.length == 0)//没有值
                                {
                                    needSelectClass = YES;
                                }
                            }
                        }
                    }
                }
                
                void (^openWebVC)(NSString *) = ^(NSString *url){
                    TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:url]];
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
                else if([host isEqualToString:@"tree"]){
                    TreeHouseVC *treeHouseVC = [[TreeHouseVC alloc] init];
                    [CurrentROOTNavigationVC pushViewController:treeHouseVC animated:YES];
                }
                else
                {
                    void (^selectClassCallBack)(ClassInfo *classInfo) = ^(ClassInfo *classInfo){
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
                            AttendanceDetailVC *vacationHistoryVC = [[AttendanceDetailVC alloc] init];
                            [vacationHistoryVC setClassInfo:classInfo];
                            [CurrentROOTNavigationVC pushViewController:vacationHistoryVC animated:YES];
                        }
                    };
                    NSArray *classArray = [UserCenter sharedInstance].curChild.classes;
                    if(classArray.count == 0)
                        [ProgressHUD showHintText:@"孩子不在任何班级"];
                    else if(classArray.count == 1)
                    {
                        ClassInfo *classInfo = classArray[0];
                        selectClassCallBack(classInfo);
                    }
                    else
                    {
                        ClassSelectionVC *classSelectionVC = [[ClassSelectionVC alloc] init];
                        
                        if([host isEqualToString:@"class"])//班博客
                        {
                            [classSelectionVC setValidateStatus:^NSDictionary *{
                                NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
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
                                        //                                    count += [[UserCenter sharedInstance].statusManager newCountForClassFeed];
                                        if(count > 0)
                                            badge = @"";
                                    }
                                    [classDic setValue:badge forKey:classID];
                                }
                                return classDic;
                            }];
                        }
                        else if ([host isEqualToString:@"record"]){
                            [classSelectionVC setValidateStatus:^NSDictionary *{
                                NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
                                NSArray *classRecordArray = [UserCenter sharedInstance].statusManager.classRecordArray;
                                for (ClassInfo *classInfo in [UserCenter sharedInstance].curChild.classes){
                                    NSString *classID = classInfo.classID;
                                    for (ClassFeedNotice *notice in classRecordArray) {
                                        if([notice.classID isEqualToString:classID] && [notice.childID isEqualToString:[UserCenter sharedInstance].curChild.uid]){
                                            if(notice.num > 0){
                                                [classDic setValue:@"" forKey:classID];
                                            }
                                        }
                                    }
                                }
                                return classDic;
                            }];
                        }
                        else if ([host isEqualToString:@"practice"])
                        {
                            [classSelectionVC setValidateStatus:^NSDictionary *{
                                NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
                                for (NSString *key in [UserCenter sharedInstance].statusManager.appPractice.allKeys) {
                                    NSInteger num = [[UserCenter sharedInstance].statusManager.appPractice[key] integerValue];
                                    if(num > 0)
                                        [classDic setValue:@"" forKey:key];
                                }
                                return classDic;
                            }];
                        }
                        [classSelectionVC setSelection:^(ClassInfo *classInfo) {
                            selectClassCallBack(classInfo);
                        }];
                        [CurrentROOTNavigationVC pushViewController:classSelectionVC animated:YES];
                    }

                }
            }
        }
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ApplicationBoxHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ApplicationBoxHeaderView" forIndexPath:indexPath];
    NSArray *bannerArray = [(ClassAppModel *)self.collectionViewModel banner];
    [headerView setBannerArray:bannerArray];
    self.headerView = headerView;
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y <= 0){
        [self.headerView updateWithHeight:kBannerHeight - scrollView.contentOffset.y];
    }
    else{
        [self.headerView updateWithHeight:kBannerHeight];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

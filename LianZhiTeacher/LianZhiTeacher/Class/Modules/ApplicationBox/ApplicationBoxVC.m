//
//  ApplicationBoxVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ApplicationBoxVC.h"
#import "PublishGrowthTimelineVC.h"
#import "ContactVC.h"
#import "ClassSelectionVC.h"
#import "GrowthTimelineVC.h"
#import "PhotoFlowVC.h"
#import "HomeWorkVC.h"
#import "ClassAttendanceVC.h"
#import "MyAttendanceVC.h"
#import "LZAccountVC.h"
#import "NotificationSendVC.h"
#import "NotificationHistoryVC.h"
#import "SDCycleScrollView.h"

@implementation ApplicationBoxHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:nil placeholderImage:nil];
        [_cycleScrollView setInfiniteLoop:YES];
        [_cycleScrollView setPageControlStyle:SDCycleScrollViewPageContolStyleClassic];
        [_cycleScrollView setAutoScrollTimeInterval:3.f];
        [self addSubview:_cycleScrollView];
    }
    return self;
}

- (void)updateWithHeight:(CGFloat)height{
    [_cycleScrollView setFrame:CGRectMake(0, self.height - height, self.width, height)];
}

@end

@implementation BannerItem

- (void)parseData:(TNDataWrapper *)dataWrapper{
    [self modelSetWithJSON:dataWrapper.data];
}

@end

@implementation ApplicationItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.icon = [dataWrapper getStringForKey:@"icon"];
    self.appId = [dataWrapper getStringForKey:@"id"];
    self.name = [dataWrapper getStringForKey:@"name"];
    self.url = [dataWrapper getStringForKey:@"url"];
}
@end

@implementation ApplicationItemCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _appImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 50) / 2, self.height - 80, 50, 50)];
        [_appImageView setClipsToBounds:YES];
        [_appImageView  setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_appImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - 30, self.width, 30)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:13]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
        
        _indicator = [[NumIndicator alloc] initWithFrame:CGRectZero];
        [self addSubview:_indicator];

    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    ApplicationItem *item = (ApplicationItem *)modelItem;
    [_appImageView sd_setImageWithURL:[NSURL URLWithString:item.icon] placeholderImage:nil];
    [_nameLabel setText:item.name];
    [self setBadge:item.badge];
}


- (void)setBadge:(NSString *)badge
{
    _badge = badge;
    [_indicator setOrigin:CGPointMake(_appImageView.right, _appImageView.y)];
    [_indicator setHidden:!_badge];
    [_indicator setIndicator:_badge];
}
@end

@implementation ApplicationModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    TNDataWrapper *dataWrapper = [data getDataWrapperForKey:@"list"];
    if(dataWrapper.count > 0)
    {
        for (NSInteger i = 0; i < dataWrapper.count; i++)
        {
            TNDataWrapper *itemWrapper = [dataWrapper getDataWrapperForIndex:i];
            ApplicationItem *item = [[ApplicationItem alloc] init];
            [item parseData:itemWrapper];
            [self.modelItemArray addObject:item];
        }
    }
    
    TNDataWrapper *bannerWrapper = [data getDataWrapperForKey:@"banner"];
    self.banner = [BannerItem nh_modelArrayWithJson:bannerWrapper.data];
    return YES;
}

@end

@interface ApplicationBoxVC ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong)NSMutableArray *appItems;
@property (nonatomic, copy)NSString *classBadge;
@property (nonatomic, weak)ApplicationBoxHeaderView*    headerView;
@property (nonatomic, weak)SDCycleScrollView*   cycleScrollView;
@end

@implementation ApplicationBoxVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self setCellName:@"ApplicationItemCell"];
        [self setModelName:@"ApplicationModel"];
        [self setHideNavigationBar:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [self.collectionView registerClass:[ApplicationBoxHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ApplicationBoxHeaderView"];
    [self.collectionView setShowsVerticalScrollIndicator:NO];

    [self requestData:REQUEST_REFRESH];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
}

- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    [flowLayout setItemSize:CGSizeMake(self.view.width / 4, MIN(self.view.width / 4 + 20, 100))];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.width, self.view.width / 2)];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"app/list"];
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
    return [NSString stringWithFormat:@"%@_%@",[self class],[UserCenter sharedInstance].curSchool.schoolID];
}

- (void)onSchoolChanged
{
    [self requestData:REQUEST_REFRESH];
}

- (void)onStatusChanged
{
    //新动态
    NSArray *newCommentArray = [UserCenter sharedInstance].statusManager.classNewCommentArray;
    NSInteger commentNum = 0;
    for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes)
    {
        for (TimelineCommentItem *commentItem in newCommentArray)
        {
            if([commentItem.classID isEqualToString:classInfo.classID] && commentItem.alertInfo.num > 0)
                commentNum += commentItem.alertInfo.num;
        }
    }
    if(commentNum > 0)
        self.classBadge = kStringFromValue(commentNum);
    else
    {
        //新日志
        NSArray *newFeedArray = [UserCenter sharedInstance].statusManager.feedClassesNew;
        NSInteger num = 0;
        for (ClassFeedNotice *noticeItem in newFeedArray)
        {
            if([noticeItem.schoolID isEqualToString:[UserCenter sharedInstance].curSchool.schoolID])
            {
                num += noticeItem.num;
            }
        }
        if(num > 0)
            self.classBadge = @"";
        else
            self.classBadge = nil;
    }
    for (ApplicationItem *appItem in self.collectionViewModel.modelItemArray)
    {
        NSURL *url = [NSURL URLWithString:appItem.url];
        if([url.host isEqualToString:@"class"])
        {
            [appItem setBadge:self.classBadge];
        }
        if([url.host isEqualToString:@"leave"])
        {
            NSString *badge = [UserCenter sharedInstance].statusManager.leaveNum > 0 ? @"" : nil;
            [appItem setBadge:badge];
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - 
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSArray *bannerArray = [(ApplicationModel *)self.collectionViewModel banner];
    BannerItem *bannerItem = bannerArray[index];
    if(bannerItem.url){
        TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:bannerItem.url]];
        [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
    }
}

#pragma mark - UICollectionView

- (void)TNBaseTableViewControllerRequestSuccess
{
    for (ApplicationItem *appItem in self.collectionViewModel.modelItemArray)
    {
        NSURL *url = [NSURL URLWithString:appItem.url];
        if([url.host isEqualToString:@"class"])
        {
            [appItem setBadge:self.classBadge];
        }
        if([url.host isEqualToString:@"leave"])
        {
            NSString *badge = [UserCenter sharedInstance].statusManager.leaveNum > 0 ? @"" : nil;
            [appItem setBadge:badge];
        }
    }

    NSArray *bannerArray = [(ApplicationModel *)self.collectionViewModel banner];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (BannerItem *bannerItem in bannerArray) {
        [imageArray addObject:bannerItem.pic];
    }
    [self.cycleScrollView setImageURLStringsGroup:imageArray];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath
{
    ApplicationItem *item = (ApplicationItem *)modelItem;
    NSString *url = item.url;
    if([url hasPrefix:@"http"])
    {
        TNBaseWebViewController *webVC = [[TNBaseWebViewController alloc] initWithUrl:[NSURL URLWithString:url]];
        [CurrentROOTNavigationVC pushViewController:webVC animated:YES];
    }
    else if([url hasPrefix:@"lianzhi://"])
    {
        NSURL *path = [NSURL URLWithString:url];
        NSString *host = path.host;
        if([host isEqualToString:@"notice"])//发通知
        {
//            NotificationSendVC *notificationSendVC = [[NotificationSendVC alloc] init];
//            TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:notificationSendVC];
            NotificationHistoryVC *historyVC = [[NotificationHistoryVC alloc] init];
            [CurrentROOTNavigationVC pushViewController:historyVC animated:YES];
        }
        else if([host isEqualToString:@"contact"])//联系人
        {
            ContactVC *contactListVC = [[ContactVC alloc] init];
            [CurrentROOTNavigationVC pushViewController:contactListVC animated:YES];
        }
        else if([host isEqualToString:@"class"])//班博客
        {
            NSMutableDictionary *classInfoDic = [NSMutableDictionary dictionary];
            //新动态
            NSArray *newCommentArray = [UserCenter sharedInstance].statusManager.classNewCommentArray;
            
            for (ClassInfo *classInfo in [UserCenter sharedInstance].curSchool.classes)
            {
                NSString *badge = nil;
                NSInteger commentNum = 0;
                for (TimelineCommentItem *commentItem in newCommentArray)
                {
                    if([commentItem.classID isEqualToString:classInfo.classID] && commentItem.alertInfo.num > 0)
                        commentNum += commentItem.alertInfo.num;
                }
                
                if(commentNum > 0)
                    badge = kStringFromValue(commentNum);
                else
                {
                    //新日志
                    NSArray *newFeedArray = [UserCenter sharedInstance].statusManager.feedClassesNew;
                    NSInteger num = 0;
                    for (ClassFeedNotice *noticeItem in newFeedArray)
                    {
                        if([noticeItem.schoolID isEqualToString:[UserCenter sharedInstance].curSchool.schoolID] && [noticeItem.classID isEqualToString:classInfo.classID])
                        {
                            num += noticeItem.num;
                        }
                    }
                    if(num > 0)
                        badge = @"";
                    else
                        badge = nil;
                }
                [classInfoDic setValue:badge forKey:classInfo.classID];
            }
            
            ClassSelectionVC *selectionVC = [[ClassSelectionVC alloc] init];
            [selectionVC setShowNew:YES];
            [selectionVC setClassInfoDic:classInfoDic];
            [selectionVC setSelection:^(ClassInfo *classInfo) {
                ClassZoneVC *classZoneVC = [[ClassZoneVC alloc] init];
                [classZoneVC setClassInfo:classInfo];
                [CurrentROOTNavigationVC pushViewController:classZoneVC animated:YES];
            }];
            [CurrentROOTNavigationVC pushViewController:selectionVC animated:YES];
        }
        else if([host isEqualToString:@"record"])//家园手册
        {
            if([UserCenter sharedInstance].curSchool.classes.count == 0)
            {
                ClassSelectionVC *selectionVC = [[ClassSelectionVC alloc] init];
                [selectionVC setSelection:^(ClassInfo *classInfo) {
                    GrowthTimelineVC *growthTimelineVC = [[GrowthTimelineVC alloc] init];
                    [growthTimelineVC setClassID:classInfo.classID];
                    [growthTimelineVC setTitle:classInfo.name];
                    [CurrentROOTNavigationVC pushViewController:growthTimelineVC animated:YES];
                }];
                [CurrentROOTNavigationVC pushViewController:selectionVC animated:YES];
            }
            else
            {
                PublishGrowthTimelineVC *publishGrowthTimelineVC = [[PublishGrowthTimelineVC alloc] init];
                [CurrentROOTNavigationVC pushViewController:publishGrowthTimelineVC animated:YES];
            }
            
        }
        else if([host isEqualToString:@"class_album"])//版相册
        {
            ClassSelectionVC *selectionVC = [[ClassSelectionVC alloc] init];
            [selectionVC setSelection:^(ClassInfo *classInfo) {
                PhotoFlowVC *albumVC = [[PhotoFlowVC alloc] init];
                [albumVC setClassID:classInfo.classID];
                [CurrentROOTNavigationVC pushViewController:albumVC animated:YES];
            }];
            [CurrentROOTNavigationVC pushViewController:selectionVC animated:YES];
        }
        else if([host isEqualToString:@"practice"])//联系
        {
            HomeWorkVC *homeWorkVC = [[HomeWorkVC alloc] init];
            [CurrentROOTNavigationVC pushViewController:homeWorkVC animated:YES];
        }
        else if([host isEqualToString:@"leave"])//考勤
        {
            ClassAttendanceVC *classAttendanceVC = [[ClassAttendanceVC alloc] init];
            [CurrentROOTNavigationVC pushViewController:classAttendanceVC animated:YES];
        }
        else if ([host isEqualToString:@"account"])//炼制账户
        {
            LZAccountVC *accountVC = [[LZAccountVC alloc] init];
            [CurrentROOTNavigationVC pushViewController:accountVC animated:YES];
        }
        else if([host isEqualToString:@"leave_my_record"])//我的考勤
        {
            MyAttendanceVC *myAttendanceVC = [[MyAttendanceVC alloc] init];
            [CurrentROOTNavigationVC pushViewController:myAttendanceVC animated:YES];
        }
    }

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ApplicationBoxHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ApplicationBoxHeaderView" forIndexPath:indexPath];
    self.headerView = headerView;
    self.cycleScrollView = headerView.cycleScrollView;
    [self.cycleScrollView setDelegate:self];
    NSArray *bannerArray = [(ApplicationModel *)self.collectionViewModel banner];
    NSMutableArray *imageArray = [NSMutableArray array];
    for (BannerItem *bannerItem in bannerArray) {
        [imageArray addObject:bannerItem.pic];
    }
    if(imageArray.count > 0){
        [self.cycleScrollView setImageURLStringsGroup:imageArray];
    }
    return headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y <= 0){
        [self.headerView updateWithHeight:self.view.width / 2 - scrollView.contentOffset.y];
    }
    else{
        [self.headerView updateWithHeight:self.view.width / 2];
    }
}
@end

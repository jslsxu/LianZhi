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
        [_cycleScrollView setPageControlStyle:SDCycleScrollViewPageContolStyleAnimated];
        [_cycleScrollView setAutoScrollTimeInterval:3.f];
        [self addSubview:_cycleScrollView];
    }
    return self;
}

- (void)updateWithHeight:(CGFloat)height{
    [_cycleScrollView setFrame:CGRectMake(0, self.height - height, self.width, height)];
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
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        [self setBackgroundColor:[UIColor colorWithHexString:@"dbdbdb"]];
        _appImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 56) / 2, 8, 56, 56)];
        [_appImageView setClipsToBounds:YES];
        [_appImageView  setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_appImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _appImageView.bottom, self.width, 15)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
        
        _indicator = [[NumIndicator alloc] initWithFrame:CGRectZero];
        [self addSubview:_indicator];
        
        NSInteger height = _appImageView.height + 15 + 6;
        [_appImageView setY:(self.height - height) / 2];
        [_nameLabel setY:_appImageView.bottom + 6];

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
    [flowLayout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    NSInteger itemSize = (self.view.width - 15 * 2 - 10 * 2) / 3;
    [flowLayout setItemSize:CGSizeMake(itemSize, itemSize)];
    [flowLayout setMinimumLineSpacing:10];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.width, self.view.width / 2)];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"app/list"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[UserCenter sharedInstance].curSchool.schoolID forKey:@"school_id"];
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

    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    [self.cycleScrollView setImageURLStringsGroup:imagesURLStrings];
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

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
        CGFloat imageWidth = [ApplicationItemCell imageWidth];
        _appImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - imageWidth) / 2, 20, imageWidth, imageWidth)];
        [_appImageView setClipsToBounds:YES];
        [_appImageView  setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_appImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _appImageView.bottom + 5, self.width, 25)];
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

+ (CGFloat)imageWidth{
    return kScreenWidth * 30 / 320;
}

+ (CGFloat)cellHeight{
    CGFloat height = 0;
    height += 20;
    height += [self imageWidth];
    height += 5 + 25;
    return height;
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

@interface ApplicationBoxVC ()
@property (nonatomic, strong)NSMutableArray *appItems;
@property (nonatomic, copy)NSString *classBadge;
@property (nonatomic, weak)ApplicationBoxHeaderView*    headerView;
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
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItems = [ApplicationDelegate.homeVC commonLeftBarButtonItems];
    [self requestData:REQUEST_REFRESH];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.leftBarButtonItems = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTitle];
//    self.title = [UserCenter sharedInstance].curSchool.schoolName;
    [self.collectionView registerClass:[ApplicationBoxHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ApplicationBoxHeaderView"];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
}

- (void)setupTitle{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"252525"]];
    [titleLabel setText:[UserCenter sharedInstance].curSchool.schoolName];
    [titleLabel setSize:CGSizeMake(kScreenWidth / 2, 30)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.navigationItem setTitleView:titleLabel];
}

- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 20, 0)];
    [flowLayout setItemSize:CGSizeMake(self.view.width / 4, [ApplicationItemCell cellHeight])];
    [flowLayout setMinimumInteritemSpacing:0];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setHeaderReferenceSize:CGSizeMake(self.view.width, kBannerHeight)];
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
    return @"applicationBox";
}

- (void)onSchoolChanged
{
    [self setupTitle];
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
//            ContactVC *contactListVC = [[ContactVC alloc] init];
//            [CurrentROOTNavigationVC pushViewController:contactListVC animated:YES];
            [ApplicationDelegate.homeVC selectAtIndex:1];
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
    NSArray *bannerArray = [(ApplicationModel *)self.collectionViewModel banner];
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
@end

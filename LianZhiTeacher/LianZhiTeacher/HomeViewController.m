//
//  HomeViewController.m
//  LianZhiTeacher
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "HomeViewController.h"
#import "ExchangeSchoolVC.h"
static NSArray *tabDatas = nil;

@interface HomeViewController ()
@property (nonatomic, assign)NSInteger curIndex;
@property (nonatomic, strong)SwitchSchoolButton *switchSchoolButton;
@end

@implementation HomeViewController

- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMsgNumChanged) name:kNewMsgNumNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFoundChanged) name:kFoundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitleView) name:kReachabilityChangedNotification object:nil];
        //监听学校变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialViewControllers) name:kUserCenterSchoolSchemeChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
        
        NSMutableArray *subVCs = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *subVCArray = @[@"MessageVC",@"ContactVC",@"ApplicationBoxVC",@"DiscoveryVC",@"MineVC"];
        
        for (NSInteger i = 0; i < subVCArray.count; i++)
        {
            NSString *className = subVCArray[i];
            TNBaseViewController *vc = [[NSClassFromString(className) alloc] init];
            vc.hidesBottomBarWhenPushed = NO;
            if(i == 0)
                self.messageVC = (MessageVC *)vc;
            TNBaseNavigationController *navVC = [[TNBaseNavigationController alloc] initWithRootViewController:vc];
            [subVCs addObject:navVC];
        }
        [self setViewControllers:subVCs];
        [self initialViewControllers];
    }
    return self;
}

- (void)updateTitleView
{
    Reachability* curReach = ApplicationDelegate.hostReach;
    NetworkStatus status = [curReach currentReachabilityStatus];
    if(status == NotReachable)
    {
        self.title = @"网络不可用";
    }
    else
        self.title = [UserCenter sharedInstance].curSchool.schoolName;
}

- (NSArray *)commonLeftBarButtonItems{
    //navigation
    if([UserCenter sharedInstance].userData.schools.count > 1)
    {
        if(!_switchSchoolButton){
            _switchSchoolButton = [[SwitchSchoolButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
            [_switchSchoolButton setImage:[UIImage imageNamed:@"SwitchSchool"] forState:UIControlStateNormal];
            [_switchSchoolButton addTarget:self action:@selector(switchSchool) forControlEvents:UIControlEventTouchUpInside];
        }
        UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
        flexibleSpaceBarButtonItem.width = -5;
        UIBarButtonItem *switchItem = [[UIBarButtonItem alloc] initWithCustomView:_switchSchoolButton];
        return @[flexibleSpaceBarButtonItem, switchItem];
    }
    else{
        return nil;
    }
}

- (void)switchSchool
{
    ExchangeSchoolVC *exchangeSchoolVC = [[ExchangeSchoolVC alloc] init];
    [CurrentROOTNavigationVC pushViewController:exchangeSchoolVC animated:YES];
}

- (void)onStatusChanged
{
    BOOL hasNew = NO;
    for (NoticeItem *notice in [UserCenter sharedInstance].statusManager.notice) {
        if(![notice.schoolID isEqualToString:[UserCenter sharedInstance].curSchool.schoolID])
            hasNew = YES;
    }
    [_switchSchoolButton setHasNew:hasNew];
    LZTabBarButton *discoveryButon = _tabbarButtons[3];
    DiscoveryVC *discoveryVC = [self discoveryVC];
    [discoveryButon setBadgeValue:discoveryVC.hasNew ? @"" : nil];
    
    LZTabBarButton *appTabButton = _tabbarButtons[2];
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
        [appTabButton setBadgeValue:kStringFromValue(commentNum)];
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
        num += [UserCenter sharedInstance].statusManager.leaveNum;
        if(num > 0)
            [appTabButton setBadgeValue:@""];
        else
            [appTabButton setBadgeValue:nil];
    }
}


- (void)onNewMsgNumChanged
{
    NSInteger newMsg = [UserCenter sharedInstance].statusManager.msgNum;
    LZTabBarButton *msgButton = (LZTabBarButton *)_tabbarButtons[0];
    NSString *badgeValue = nil;
    if(newMsg > 0){
        if(newMsg > 99){
            badgeValue = @"99+";
        }
        else{
            badgeValue = kStringFromValue(newMsg);
        }
    }
    [msgButton setBadgeValue:badgeValue];
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:newMsg];
}

- (void)onFoundChanged
{
//    BOOL foundNew = [UserCenter sharedInstance].statusManager.found;
//    LZTabBarButton *msgButton = [_tabbarButtons lastObject];
//    [msgButton setBadgeValue:(foundNew > 0 ? kStringFromValue(foundNew) : nil)];
}

- (void)onSchoolChanged
{
    [self updateTitleView];
}

- (MessageVC *)messageVC
{
    TNBaseNavigationController *firstNav = self.viewControllers[0];
    return [firstNav viewControllers][0];
}

- (DiscoveryVC *)discoveryVC {
    TNBaseNavigationController *firstNav = self.viewControllers[3];
    return [firstNav viewControllers][0];
}
- (void)initialViewControllers
{
    if(_tabbarButtons == nil)
        _tabbarButtons = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _tabbarButtons.count; i++) {
        LZTabBarButton *tabBarButton = _tabbarButtons[i];
        [tabBarButton removeFromSuperview];
    }
    [_tabbarButtons removeAllObjects];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    [self.tabBar.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (view.class == NSClassFromString([NSString stringWithFormat:@"%@%@",@"UITabBar",@"Button"]))
        {
            view.hidden = YES;
        }
    }];
    NSArray *tabItemTitleArray = @[@"信息",@"联系人",@"应用盒",@"发现",@"我"];
    CGFloat tabWidth = self.view.width / tabItemTitleArray.count;
    for (NSInteger i = 0; i < tabItemTitleArray.count; i++)
    {
        CGFloat spaceX = tabWidth * i;
        LZTabBarButton *barButton = [[LZTabBarButton alloc] initWithFrame:CGRectMake(spaceX, 0, tabWidth, self.tabBar.height)];
        [barButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [barButton setTitle:tabItemTitleArray[i] forState:UIControlStateNormal];
        [barButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [barButton addTarget:self action:@selector(onTabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarButtons addObject:barButton];
        [self.tabBar addSubview:barButton];
    }
    [self selectAtIndex:2];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self updateTitleView];
}

- (void)onTabButtonClicked:(UIButton *)button
{
    NSInteger index = [_tabbarButtons indexOfObject:button];
    [self selectAtIndex:index];
}

- (void)selectAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    NSArray *tabImageNameArray = @[@"HomeTabMessage",@"HomeTabContacts",@"HomeTabApplications",@"HomeTabDiscovery",@"HomeTabMine"];
    for (NSInteger i = 0; i < _tabbarButtons.count; i++)
    {
        LZTabBarButton *barButton = _tabbarButtons[i];
        BOOL selected = (i == self.selectedIndex);
        NSString *imageName = selected ? [NSString stringWithFormat:@"%@Highlighted",tabImageNameArray[i]] : [NSString stringWithFormat:@"%@Normal",tabImageNameArray[i]];
        UIColor *titleColor = selected ? kCommonTeacherTintColor : [UIColor grayColor];
        [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        [barButton setTitleColor:titleColor forState:UIControlStateNormal];
        [barButton setTitleColor:titleColor forState:UIControlStateHighlighted];
    }
}


@end

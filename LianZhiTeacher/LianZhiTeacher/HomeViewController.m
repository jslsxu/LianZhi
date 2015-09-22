//
//  HomeViewController.m
//  LianZhiTeacher
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "HomeViewController.h"
#import "ExchangeSchoolVC.h"

@implementation SwitchSchoolButton


- (void)layoutSubviews
{
    [super layoutSubviews];
    if(_redDot == nil)
    {
        _redDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"RedDot.png")]];
        [_redDot setHidden:YES];
        [self addSubview:_redDot];
    }
    [_redDot setCenter:CGPointMake(self.width - 7, 5)];
}

- (void)setHasNew:(BOOL)hasNew
{
    _hasNew = hasNew;
    [_redDot setHidden:!_hasNew];
}

@end

static NSArray *tabDatas = nil;

@interface HomeViewController ()
@property (nonatomic, assign)NSInteger curIndex;
@end

@implementation HomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.title = [UserCenter sharedInstance].curSchool.schoolName;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMsgNumChanged) name:kNewMsgNumNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFoundChanged) name:kFoundNotification object:nil];
        //监听学校变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initialViewControllers) name:kUserCenterSchoolSchemeChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSchoolChanged) name:kUserCenterChangedSchoolNotification object:nil];
    }
    return self;
}

- (void)onStatusChanged
{
    BOOL hasNew = NO;
    for (NoticeItem *notice in [UserCenter sharedInstance].statusManager.notice) {
        if(![notice.schoolID isEqualToString:[UserCenter sharedInstance].curSchool.schoolID])
            hasNew = YES;
    }
    [_switchButton setHasNew:hasNew];
}

- (void)onNewMsgNumChanged
{
    NSInteger newMsg = [UserCenter sharedInstance].statusManager.msgNum;
    LZTabBarButton *msgButton = (LZTabBarButton *)_tabbarButtons[0];
    [msgButton setBadgeValue:(newMsg > 0 ? kStringFromValue(newMsg) : nil)];
}

- (void)onFoundChanged
{
    BOOL foundNew = [UserCenter sharedInstance].statusManager.found;
    LZTabBarButton *msgButton = [_tabbarButtons lastObject];
    [msgButton setBadgeValue:(foundNew > 0 ? kStringFromValue(foundNew) : nil)];
}

- (void)onSchoolChanged
{
    self.title = [UserCenter sharedInstance].curSchool.schoolName;
}

- (MessageVC *)messageVC
{
    return self.viewControllers[0];
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
    NSArray *tabItemTitleArray = @[@"消息",@"应用盒",@"发现",@"我"];
    CGFloat tabWidth = self.view.width / tabItemTitleArray.count;
    for (NSInteger i = 0; i < tabItemTitleArray.count; i++)
    {
        CGFloat spaceX = tabWidth * i;
        LZTabBarButton *barButton = [[LZTabBarButton alloc] initWithFrame:CGRectMake(spaceX, 0, tabWidth, self.tabBar.height)];
        [barButton setTitle:tabItemTitleArray[i] forState:UIControlStateNormal];
        [barButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [barButton addTarget:self action:@selector(onTabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarButtons addObject:barButton];
        [self.tabBar addSubview:barButton];
    }
    
    [self selectAtIndex:0];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if([UserCenter sharedInstance].userData.schools.count > 1)
    {
         _switchButton = [[SwitchSchoolButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [_switchButton setImage:[UIImage imageNamed:@"SwitchSchool"] forState:UIControlStateNormal];
        [_switchButton addTarget:self action:@selector(switchSchool) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_switchButton];
    }
    
    NSMutableArray *subVCs = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *subVCArray = @[@"MessageVC",@"ApplicationBoxVC",@"DiscoveryVC",@"MineVC"];
    
    for (NSInteger i = 0; i < subVCArray.count; i++)
    {
        NSString *className = subVCArray[i];
        TNBaseViewController *vc = [[NSClassFromString(className) alloc] init];
        [subVCs addObject:vc];
    }
    [self setViewControllers:subVCs];
    [self initialViewControllers];
}

- (void)onTabButtonClicked:(UIButton *)button
{
    NSInteger index = [_tabbarButtons indexOfObject:button];
    [self selectAtIndex:index];
}

- (void)selectAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    NSArray *tabImageNameArray = @[@"HomeTabMessage",@"HomeTabApplications",@"HomeTabDiscovery",@"HomeTabMine"];
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


#pragma mark Actions

- (void)switchSchool
{
    ExchangeSchoolVC *exchangeSchoolVC = [[ExchangeSchoolVC alloc] init];
    [self.navigationController pushViewController:exchangeSchoolVC animated:YES];
}
- (void)onSettingClicked
{
    SettingsVC *settingVC = [[SettingsVC alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

@end

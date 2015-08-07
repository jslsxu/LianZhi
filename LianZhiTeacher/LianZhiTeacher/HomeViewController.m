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
        _redDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"RedDot.png")]];
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
        if(IS_IOS7_LATER)
            self.edgesForExtendedLayout = UIRectEdgeNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMsgNumChanged) name:kNewMsgNumNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFoundChanged) name:kFoundNotification object:nil];
        //监听用户信息变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoChanged) name:kUserInfoChangedNotification object:nil];
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
    [msgButton setHasNew:newMsg > 0];
}

- (void)onFoundChanged
{
    BOOL foundNew = [UserCenter sharedInstance].statusManager.found;
    LZTabBarButton *msgButton = [_tabbarButtons lastObject];
    [msgButton setHasNew:foundNew];
}

- (void)onSchoolChanged
{
    [self.schoolVC setUrl:[UserCenter sharedInstance].curSchool.schoolUrl];
}

- (void)onUserInfoChanged
{
    [self.avatar setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar] placeHolder:nil];
}


- (void)initialViewControllers
{
    self.tabBar.translucent = NO;
    if(_tabbarButtons == nil)
        _tabbarButtons = [[NSMutableArray alloc] initWithCapacity:0];
//    [self.tabBar.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
//        if (view.class != NSClassFromString([NSString stringWithFormat:@"%@%@",@"UITabBar",@"Button"]))
//        {
//            [view removeFromSuperview];
//        }
//    }];
    for (NSInteger i = 0; i < _tabbarButtons.count; i++) {
        LZTabBarButton *tabBarButton = _tabbarButtons[i];
        [tabBarButton removeFromSuperview];
    }
    [_tabbarButtons removeAllObjects];
    for (UIViewController *vc in self.viewControllers) {
        [vc.view removeFromSuperview];
    }
    self.viewControllers = nil;
    if([[UserCenter sharedInstance] teachAtCurSchool])
    {
        tabDatas = @[
                     @[@"HomeTabMessageNormal.png",@"HomeTabMessageHighlighted.png",@(NO),@"消息"],
                     @[@"HomeTabContactsNormal.png",@"HomeTabContactsHighlighted.png",@(NO),@"联系人"],
                     @[@"HomeTabHome.png",@"HomeTabHome.png",@(YES),@""],
                     @[@"HomeTabClassZoneNormal.png",@"HomeTabClassZoneHighlighted.png",@(NO),@"班空间"],
                     @[@"HomeTabDiscoveryNormal.png",@"HomeTabDiscoveryHighlighted.png",@(NO),@"发现"],
                     ];
        
        [tabDatas enumerateObjectsUsingBlock:^(NSArray *data, NSUInteger idx, BOOL *stop) {
            NSString *title = data[3];
            NSString *imageName = data[0];
            NSString *selectedImageName = data[1];
            BOOL presenting = [data[2] boolValue];
            LZTabBarButton *barButton = [[LZTabBarButton alloc] initWithFrame:CGRectZero];
            [barButton setPresenting:presenting];
            if ([title isKindOfClass:[NSString class]] && title.length) {
                [barButton setTitle:title forState:UIControlStateNormal];
            }
            [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [barButton setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
            [barButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [barButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateSelected];
            barButton.backgroundColor = [UIColor clearColor];
            [barButton setUserInteractionEnabled:NO];
            [_tabbarButtons addObject:barButton];
        }];
        
        self.tabBar.clipsToBounds = NO;
        for (LZTabBarButton *item in _tabbarButtons) {
            if(item.presenting == NO)
                [self.tabBar addSubview:item];
            else
                [self.view addSubview:item];
        }
        self.messageVC = [[MessageVC alloc] init];
        self.contactListVC = [[ContactListVC alloc] init];
        
        self.classOperationVC = [[ClassOperationVC alloc] init];
        
        self.classZoneVC = [[ClassZoneVC alloc] init];
        
        self.discoveryVC = [[DiscoveryVC alloc] init];
        
        self.viewControllers = @[self.messageVC,self.contactListVC,self.classOperationVC,self.classZoneVC,self.discoveryVC];
    }
    else
    {
        
        tabDatas = @[
                     @[@"HomeTabMessageNormal.png",@"HomeTabMessageHighlighted.png",@(NO),@"消息"],
                     @[@"HomeTabContactsNormal.png",@"HomeTabContactsHighlighted.png",@(NO),@"联系人"],
                     @[@"HomeTabHome.png",@"HomeTabHome.png",@(YES),@""],
                     @[@"HomeTabSchoolNormal.png",@"HomeTabSchoolHighlighted.png",@(NO),@"微主页"],
                     @[@"HomeTabDiscoveryNormal.png",@"HomeTabDiscoveryHighlighted.png",@(NO),@"发现"],
                     ];
        
        [tabDatas enumerateObjectsUsingBlock:^(NSArray *data, NSUInteger idx, BOOL *stop) {
            NSString *title = data[3];
            NSString *imageName = data[0];
            NSString *selectedImageName = data[1];
            BOOL presenting = [data[2] boolValue];
            LZTabBarButton *barButton = [[LZTabBarButton alloc] initWithFrame:CGRectZero];
            [barButton setPresenting:presenting];
            if ([title isKindOfClass:[NSString class]] && title.length) {
                [barButton setTitle:title forState:UIControlStateNormal];
            }
            [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [barButton setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
            [barButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [barButton setTitleColor:kCommonTeacherTintColor forState:UIControlStateSelected];
            barButton.backgroundColor = [UIColor clearColor];
            [barButton setUserInteractionEnabled:NO];
            [_tabbarButtons addObject:barButton];
            
            if(idx == 2)
            {
                    //中间头像
                [barButton setUserInteractionEnabled:YES];
                self.avatar = [[AvatarView alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
                [self.avatar setUserInteractionEnabled:YES];
                [self.avatar setBorderWidth:7];
                [self.avatar setBorderColor:[UIColor clearColor]];
                [self.avatar setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].userInfo.avatar]];
                [barButton addSubview:self.avatar];
            }
        }];
        
        self.tabBar.clipsToBounds = NO;
        for (LZTabBarButton *item in _tabbarButtons) {
            if(item.presenting == NO)
                [self.tabBar addSubview:item];
            else
                [self.view addSubview:item];
        }
        self.messageVC = [[MessageVC alloc] init];
        self.contactListVC = [[ContactListVC alloc] init];
        
        self.schoolVC = [[TNBaseWebViewController alloc] init];
        [self.schoolVC setUrl:[UserCenter sharedInstance].curSchool.schoolUrl];
        
        self.discoveryVC = [[DiscoveryVC alloc] init];
        
        self.viewControllers = @[self.messageVC,self.contactListVC,self.schoolVC,self.discoveryVC];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([UserCenter sharedInstance].userData.schools.count > 1)
    {
         _switchButton = [[SwitchSchoolButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [_switchButton setImage:[UIImage imageNamed:@"SwitchSchool.png"] forState:UIControlStateNormal];
        [_switchButton addTarget:self action:@selector(switchSchool) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_switchButton];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"Setting.png")] style:UIBarButtonItemStylePlain target:self action:@selector(onSettingClicked)];
    
    [self initialViewControllers];
    
    [self setDelegate:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat middleHeight = 63;
    CGFloat middleWidth = 72;
    CGFloat itemWidth = (self.tabBar.width - middleWidth) / (_tabbarButtons.count - 1);
    CGFloat itemHeight = self.tabBar.height;
    __block CGFloat spaceXStart = 0;
    [_tabbarButtons enumerateObjectsUsingBlock:^(UIView *item, NSUInteger idx, BOOL *stop) {
        LZTabBarButton *buttonItem = (LZTabBarButton *)item;
        if (buttonItem.presenting)
        {
            [buttonItem setFrame:(CGRect){spaceXStart, self.view.height - middleHeight,
                middleWidth, middleHeight}];
            spaceXStart += middleWidth;
        } else
        {
            [buttonItem setFrame:(CGRect){spaceXStart, 0, itemWidth, itemHeight}];
            spaceXStart += itemWidth;
        }
        
    }];

    [self switchToIndex:self.curIndex];
}


- (void)switchToIndex:(NSInteger)index
{
    self.selectedIndex = index;
    self.curIndex = index;
    if([[UserCenter sharedInstance] teachAtCurSchool])
    {
        for (NSInteger i = 0; i < _tabbarButtons.count; i++)
        {
            [_tabbarButtons[i] setSelected:i == self.curIndex];
        }
        if(self.curIndex == 4)
        {
            NSString *url = [UserCenter sharedInstance].userData.config.dicoveryUrl;
            if([url rangeOfString:@"?"].length != 0)
            {
                url = [NSString stringWithFormat:@"%@&school_id=%@",url,[UserCenter sharedInstance].curSchool.schoolID];
            }
            else
                url = [NSString stringWithFormat:@"%@?school_id=%@",url,[UserCenter sharedInstance].curSchool.schoolID];
            [self.discoveryVC setUrl:url];
        }
    }
    else
    {
        for (NSInteger i = 0; i < _tabbarButtons.count; i++)
        {
            NSInteger j = (self.curIndex >= 2) ? (self.curIndex + 1) : self.curIndex;
            if([_tabbarButtons[i] isKindOfClass:[LZTabBarButton class]])
                [_tabbarButtons[i] setSelected:i == j];
        }
        if(self.curIndex == 3)
        {
            NSString *url = [UserCenter sharedInstance].userData.config.dicoveryUrl;
            if([url rangeOfString:@"?"].length != 0)
            {
                url = [NSString stringWithFormat:@"%@&school_id=%@",url,[UserCenter sharedInstance].curSchool.schoolID];
            }
            else
                url = [NSString stringWithFormat:@"%@?school_id=%@",url,[UserCenter sharedInstance].curSchool.schoolID];
            [self.discoveryVC setUrl:url];
        }
    }
}


#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    [self switchToIndex:self.selectedIndex];
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

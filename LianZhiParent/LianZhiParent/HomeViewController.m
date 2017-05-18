//
//  ViewController.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "HomeViewController.h"
#import "PublishSelectionView.h"
#import "MineVC.h"

#define kReservedStretchButtonHeight                            60

NSString *const kCurrentChildInfoChangedNotification = @"CurrentChildInfoChangedNotification";

static NSArray *tabDatas = nil;

@interface HomeViewController ()
@property (nonatomic, strong)ChildrenSwitchView *childrenSelectView;
@property (nonatomic, strong)NSMutableArray *subVCArray;
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
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMsgNumChanged) name:kNewMsgNumNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFoundChanged) name:kFoundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onStatusChanged) name:kStatusChangedNotification object:nil];
        self.subVCArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *subVCNavArray  =[NSMutableArray array];
        NSArray *subVCArray = @[@"MessageVC",@"ContactListVC",@"ClassAppVC",@"DiscoveryVC",@"MineVC"];
        
        for (NSInteger i = 0; i < subVCArray.count; i++)
        {
            NSString *className = subVCArray[i];
            TNBaseViewController *vc = [[NSClassFromString(className) alloc] init];
            vc.hidesBottomBarWhenPushed = NO;
            [self.subVCArray addObject:vc];
            
            TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:vc];
            [subVCNavArray addObject:nav];
        }
        [self setViewControllers:subVCNavArray];
        [self initialViewControllers];
        
        self.messageVC = self.subVCArray[0];
        self.classAppVC = self.subVCArray[2];
    }
    return self;
}

- (void)showIMVC{
    [self.messageVC showIMVC];
}

- (NSArray *)commonLeftBarButtonItems{
    UIBarButtonItem *flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target: nil action: nil];
    flexibleSpaceBarButtonItem.width = -5;
    UIBarButtonItem *switchItem = [[UIBarButtonItem alloc] initWithCustomView:[self curChildrenSelectView]];
    return @[flexibleSpaceBarButtonItem, switchItem];
}

- (void)onStatusChanged
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
    
    LZTabBarButton *classAppButton = (LZTabBarButton *)_tabbarButtons[2];

    NSInteger classZoneNum = [[UserCenter sharedInstance].statusManager newCountForClassComment];
    if(classZoneNum > 0)
        [classAppButton setBadgeValue:kStringFromValue(classZoneNum)];
    else
    {
//        for (ClassFeedNotice *notice in [UserCenter sharedInstance].statusManager.feedClassesNew)//新班级博客
//        {
//            if([notice.childID isEqualToString:[UserCenter sharedInstance].curChild.uid]){
//                classZoneNum += notice.num;
//            }
//        }
        classZoneNum += [[UserCenter sharedInstance].statusManager newCountForClassFeed];
        
        //成长记录
//        for (ClassFeedNotice *notice in [UserCenter sharedInstance].statusManager.classRecordArray)//
//        {
//                classZoneNum += notice.num;
//        }
        classZoneNum += [[UserCenter sharedInstance].statusManager newCountForClassRecord];
        
        //练习
        classZoneNum += [[UserCenter sharedInstance].statusManager hasNewExerciseForChildID:[UserCenter sharedInstance] .curChild.uid];
        
        //考勤
        classZoneNum += [[UserCenter sharedInstance].statusManager hasNewAttendanceInfoForChildID:[UserCenter sharedInstance].curChild.uid];
        //树屋回复
//        NSArray *treeNewCommentArray = [UserCenter sharedInstance].statusManager.treeNewCommentArray;
//        NSInteger treeAlertNum = 0;
//        for (TimelineCommentItem *item in treeNewCommentArray)
//        {
//            if([item.objid isEqualToString:[UserCenter sharedInstance].curChild.uid])
//            {
//                treeAlertNum = item.alertInfo.num;
//                break;
//            }
//        }
        NSInteger treeAlertNum = [[UserCenter sharedInstance].statusManager newCountForTreeComment];
        classZoneNum += treeAlertNum;
        
        if(classZoneNum > 0){
            [classAppButton setBadgeValue:@""];
        }
        else
            [classAppButton setBadgeValue:nil];
    }
    
    LZTabBarButton *discoveryButton = _tabbarButtons[3];
    DiscoveryVC *discoveryVC = self.subVCArray[3];
    [discoveryButton setBadgeValue:discoveryVC.hasNew ? @"" : nil];
    
    LZTabBarButton *mineButton = _tabbarButtons[4];
    [mineButton setBadgeValue:ApplicationDelegate.needUpdate ? @"" : nil];
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

//- (void)onFoundChanged
//{
//    BOOL foundNew = [UserCenter sharedInstance].statusManager.found;
//    LZTabBarButton *msgButton = [_tabbarButtons lastObject];
//    [msgButton setBadgeValue:(foundNew ? @"" : nil)];
//}


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
        [barButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [barButton setSpacing:4];
        [barButton setTitle:tabItemTitleArray[i] forState:UIControlStateNormal];
        [barButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [barButton addTarget:self action:@selector(onTabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarButtons addObject:barButton];
        [self.tabBar addSubview:barButton];
    }
    
    [self selectAtIndex:2];
}

- (ChildrenSwitchView *)curChildrenSelectView{
    if(_childrenSelectView == nil){
        _childrenSelectView = [[ChildrenSwitchView alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    }
    return _childrenSelectView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)onTabButtonClicked:(UIButton *)button
{
    NSInteger index = [_tabbarButtons indexOfObject:button];
    [self selectAtIndex:index];
}

- (void)selectAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    NSArray *tabImageNameArray = @[@"HomeTabMessage",@"HomeTabContacts",@"HomeTabAppBox",@"HomeTabDiscovery",@"HomeTabMine"];
    for (NSInteger i = 0; i < _tabbarButtons.count; i++)
    {
        LZTabBarButton *barButton = _tabbarButtons[i];
        BOOL selected = (i == self.selectedIndex);
        NSString *imageName = selected ? [NSString stringWithFormat:@"%@Highlighted",tabImageNameArray[i]] : [NSString stringWithFormat:@"%@Normal",tabImageNameArray[i]];
        UIColor *titleColor = selected ? [UIColor colorWithHexString:@"02c994"] : [UIColor colorWithHexString:@"595959"];
        [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        [barButton setTitleColor:titleColor forState:UIControlStateNormal];
        [barButton setTitleColor:titleColor forState:UIControlStateHighlighted];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

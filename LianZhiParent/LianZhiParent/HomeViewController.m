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
@property (nonatomic, strong)ChildrenSelectView *childrenSelectView;
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
        NSArray *subVCArray = @[@"MessageVC",@"ContactListVC",@"TreeHouseVC",@"ClassAppVC",@"DiscoveryVC"];
        
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
        self.treeHouseVC = self.subVCArray[2];
        self.classAppVC = self.subVCArray[3];
    }
    return self;
}

- (void)onStatusChanged
{
    NSInteger newMsg = [UserCenter sharedInstance].statusManager.msgNum;
    LZTabBarButton *msgButton = (LZTabBarButton *)_tabbarButtons[0];
    [msgButton setBadgeValue:(newMsg > 0 ? kStringFromValue(newMsg) : nil)];
    
    NSArray *classNewCommentArray = [UserCenter sharedInstance].statusManager.classNewCommentArray;
    NSInteger classZoneNum = 0;
    LZTabBarButton *classTabButton = (LZTabBarButton *)_tabbarButtons[3];
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
        [classTabButton setBadgeValue:kStringFromValue(classZoneNum)];
    else
    {
        for (ClassFeedNotice *notice in [UserCenter sharedInstance].statusManager.feedClassesNew)
        {
                classZoneNum += notice.num;
        }
        
        //成长记录
        for (ClassFeedNotice *notice in [UserCenter sharedInstance].statusManager.classRecordArray)
        {
                classZoneNum += notice.num;
        }
        
        classZoneNum += [UserCenter sharedInstance].statusManager.practiceNum;
        
        if(classZoneNum > 0)
            [classTabButton setBadgeValue:@""];
        else
            [classTabButton setBadgeValue:nil];
    }
    
    
    NSArray *treeNewCommentArray = [UserCenter sharedInstance].statusManager.treeNewCommentArray;
    LZTabBarButton *treeTabButton = (LZTabBarButton *)_tabbarButtons[2];
    NSInteger treeAlertNum = 0;
    for (TimelineCommentItem *item in treeNewCommentArray)
    {
        if([item.objid isEqualToString:[UserCenter sharedInstance].curChild.uid])
        {
            treeAlertNum = item.alertInfo.num;
            break;
        }
    }
    [treeTabButton setBadgeValue:treeAlertNum > 0 ? kStringFromValue(treeAlertNum) : nil];
    
    LZTabBarButton *discoveryButton = _tabbarButtons[4];
    DiscoveryVC *discoveryVC = self.subVCArray[4];
    [discoveryButton setBadgeValue:discoveryVC.hasNew ? @"" : nil];
}

- (void)onNewMsgNumChanged
{
    NSInteger newMsg = [UserCenter sharedInstance].statusManager.msgNum;
    LZTabBarButton *msgButton = (LZTabBarButton *)_tabbarButtons[0];
    [msgButton setBadgeValue:(newMsg > 0 ? kStringFromValue(newMsg) : nil)];
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
    NSArray *tabItemTitleArray = @[@"消息",@"联系人",@"树屋",@"班应用",@"发现"];
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
    
    [self selectAtIndex:0];

}

- (ChildrenSelectView *)curChildrenSelectView{
    if(_childrenSelectView == nil){
        _childrenSelectView = [[ChildrenSelectView alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
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
    NSArray *tabImageNameArray = @[@"HomeTabMessage",@"HomeTabContacts",@"HomeTabHome",@"HomeTabClassZone",@"HomeTabDiscovery"];
    for (NSInteger i = 0; i < _tabbarButtons.count; i++)
    {
        LZTabBarButton *barButton = _tabbarButtons[i];
        BOOL selected = (i == self.selectedIndex);
        NSString *imageName = selected ? [NSString stringWithFormat:@"%@Highlighted",tabImageNameArray[i]] : [NSString stringWithFormat:@"%@Normal",tabImageNameArray[i]];
        UIColor *titleColor = selected ? kCommonParentTintColor : [UIColor grayColor];
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

//
//  ViewController.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "HomeViewController.h"
#import "PublishSelectionView.h"

#define kReservedStretchButtonHeight                            60

NSString *const kCurrentChildInfoChangedNotification = @"CurrentChildInfoChangedNotification";

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMsgNumChanged) name:kNewMsgNumNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFoundChanged) name:kFoundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChildInfoChanged) name:kChildInfoChangedNotification object:nil];
    }
    return self;
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

- (void)onChildInfoChanged
{
    [self.avatar setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar] placeHolder:nil];
}


- (void)initialViewControllers
{
    self.tabBar.translucent = NO;
    _tabbarButtons = [[NSMutableArray alloc] initWithCapacity:0];

    [self.tabBar.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        if (view.class != NSClassFromString([NSString stringWithFormat:@"%@%@",@"UITabBar",@"Button"]))
        {
            [view removeFromSuperview];
        }
    }];
    
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
        [barButton setTitleColor:kCommonParentTintColor forState:UIControlStateSelected];
        barButton.backgroundColor = [UIColor clearColor];
        [barButton setUserInteractionEnabled:NO];
        [_tabbarButtons addObject:barButton];
        
        if(idx == 2)
        {
            //中间头像
            self.avatar = [[AvatarView alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
            [self.avatar setBorderWidth:7];
            [self.avatar setBorderColor:[UIColor clearColor]];
            [self.avatar setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar]];
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
    
    self.treeHouseVC = [[TreeHouseVC alloc] init];
    
    self.classZoneVC = [[ClassZoneVC alloc] init];
    
    self.discoveryVC = [[DiscoveryVC alloc] init];
    
    self.viewControllers = @[self.messageVC,self.contactListVC,self.treeHouseVC,self.classZoneVC,self.discoveryVC];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    if([UserCenter sharedInstance].userData.children.count > 1)
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_childProfile];
    ChildrenSelectView *childrenView = [[ChildrenSelectView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [childrenView setDelegate:self];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:childrenView];
    
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
    [_tabbarButtons enumerateObjectsUsingBlock:^(LZTabBarButton *item, NSUInteger idx, BOOL *stop) {
        if (item.presenting) {
            [item setFrame:(CGRect){spaceXStart, self.view.height - middleHeight,
                middleWidth, middleHeight}];
            spaceXStart += middleWidth;
        } else {
            [item setFrame:(CGRect){spaceXStart, 0, itemWidth, itemHeight}];
            spaceXStart += itemWidth;
        }
    }];
    [self switchToIndex:self.selectedIndex];
}


- (void)switchToIndex:(NSInteger)index
{
    self.selectedIndex = index;
    self.curIndex = index;
    for (NSInteger i = 0; i < _tabbarButtons.count; i++)
    {
        [_tabbarButtons[i] setSelected:i == self.curIndex];
    }
    if(self.curIndex == 4)//发现页面
    {
        
    }
}


#pragma mark UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    [self switchToIndex:self.selectedIndex];
}

#pragma mark Actions
- (void)onSettingClicked
{
    SettingsVC *settingVC = [[SettingsVC alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - ChildIconAction
- (void)childrenSelectFinished:(ChildInfo *)childInfo
{
    [self.avatar setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar] placeHolder:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

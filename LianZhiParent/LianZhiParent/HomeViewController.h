//
//  ViewController.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassZoneVC.h"
#import "ContactListVC.h"
#import "DiscoveryVC.h"
#import "MessageVC.h"
#import "TreeHouseVC.h"
#import "SettingsVC.h"
#import "LZTabBarButton.h"
#import "ChildrenSelectView.h"
extern NSString *const kCurrentChildInfoChangedNotification;

@interface HomeViewController : UITabBarController<UITabBarControllerDelegate, ChildrenSelectDelegate>
{
    UIView*             _tabBarCover;
//    ChildProfileView *  _childProfile;
    NSArray *           _tabDatas;
    NSMutableArray *    _tabbarButtons;
}
@property (nonatomic, strong)AvatarView* avatar;
@property (nonatomic, strong)ClassZoneVC *classZoneVC;
@property (nonatomic, strong)ContactListVC *contactListVC;
@property (nonatomic, strong)DiscoveryVC *discoveryVC;
@property (nonatomic, strong)MessageVC *messageVC;
@property (nonatomic, strong)TreeHouseVC *treeHouseVC;

- (void)switchToIndex:(NSInteger)index;

@end


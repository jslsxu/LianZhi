//
//  ViewController.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassAppVC.h"
#import "ContactListVC.h"
#import "DiscoveryVC.h"
#import "MineVC.h"
#import "MessageVC.h"
#import "TreeHouseVC.h"
#import "SettingsVC.h"
#import "LZTabBarButton.h"
#import "ChildrenSwitchView.h"
extern NSString *const kCurrentChildInfoChangedNotification;

@interface HomeViewController : UITabBarController
{
    NSMutableArray* _tabbarButtons;
}
//@property (nonatomic, strong)AvatarView* avatar;
@property (nonatomic, strong)ClassAppVC *classAppVC;
@property (nonatomic, strong)ContactListVC *contactListVC;
@property (nonatomic, strong)DiscoveryVC *discoveryVC;
@property (nonatomic, strong)MessageVC *messageVC;
@property (nonatomic, strong)MineVC *mineVC;

- (void)selectAtIndex:(NSInteger)index;
- (NSArray *)commonLeftBarButtonItems;
- (void)showIMVC;
@end


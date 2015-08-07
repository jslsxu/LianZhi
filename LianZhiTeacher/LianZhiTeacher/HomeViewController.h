//
//  HomeViewController.h
//  LianZhiTeacher
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactListVC.h"
#import "ClassZoneVC.h"
#import "DiscoveryVC.h"
#import "MessageVC.h"
#import "ClassOperationVC.h"
#import "SettingsVC.h"
#import "LZTabBarButton.h"

@interface SwitchSchoolButton : UIButton
{
    UIImageView*    _redDot;
}
@property (nonatomic, assign)BOOL hasNew;

@end

@interface HomeViewController : UITabBarController<UITabBarControllerDelegate>
{
    SwitchSchoolButton *_switchButton;
    UIView*             _tabBarCover;
    NSArray *           _tabDatas;
    NSMutableArray *    _tabbarButtons;
}
@property (nonatomic, strong)AvatarView *avatar;
@property (nonatomic, strong)ClassZoneVC *classZoneVC;
@property (nonatomic, strong)ContactListVC *contactListVC;
@property (nonatomic, strong)TNBaseWebViewController* schoolVC;
@property (nonatomic, strong)DiscoveryVC *discoveryVC;
@property (nonatomic, strong)MessageVC *messageVC;
@property (nonatomic, strong)ClassOperationVC *classOperationVC;

- (void)switchToIndex:(NSInteger)index;


@end


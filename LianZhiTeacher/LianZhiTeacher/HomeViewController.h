//
//  HomeViewController.h
//  LianZhiTeacher
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationBoxVC.h"
#import "DiscoveryVC.h"
#import "MessageVC.h"
#import "MineVC.h"
#import "SettingsVC.h"
#import "LZTabBarButton.h"

@interface SwitchSchoolButton : UIButton
{
    UIImageView*    _redDot;
}
@property (nonatomic, assign)BOOL hasNew;

@end

@interface HomeViewController : UITabBarController
{
    SwitchSchoolButton *_switchButton;
    UIView*             _tabBarCover;
    NSArray *           _tabDatas;
    NSMutableArray *    _tabbarButtons;
}
@property (nonatomic, readonly)MessageVC *messageVC;
- (void)selectAtIndex:(NSInteger)index;


@end


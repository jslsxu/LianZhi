//
//  AppDelegate.h
//  LianZhiTeacher
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#define CurrentROOTNavigationVC            [(AppDelegate *)[[UIApplication sharedApplication] delegate] rootNavigation]
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong)Reachability *hostReach;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TNBaseNavigationController *rootNavigation;
@property (nonatomic, weak)HomeViewController *homeVC;
@property (nonatomic, assign)BOOL logouted;
@property (nonatomic, assign)BOOL needUpdate;
//屏幕方向
@property (nonatomic, assign) NSInteger allowRotation;
- (void)setupCommonAppearance;
- (void)playSound;
- (void)logout;
- (void)popAndPush:(UIViewController *)viewController;
- (NSString *)curAutoNaviKey;
@end


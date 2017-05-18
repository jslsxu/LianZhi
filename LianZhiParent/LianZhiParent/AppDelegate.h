//
//  AppDelegate.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeView.h"
#import "HomeViewController.h"
#define CurrentROOTNavigationVC            [(AppDelegate *)[[UIApplication sharedApplication] delegate] rootNavigation]
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong)Reachability* hostReach;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) TNBaseNavigationController *rootNavigation;
@property (nonatomic, strong)HomeViewController *homeVC;
@property (nonatomic, assign)BOOL logouted;
@property (nonatomic, assign) NSInteger allowRotation;
@property (nonatomic, assign)BOOL needUpdate;
- (void)setupCommonAppearance;
- (void)loginSuccess;
- (void)logout;
- (void)playSound;
- (void)popAndPush:(UIViewController *)vc;
- (NSString *)curAutoNaviKey;
@end


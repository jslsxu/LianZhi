//
//  AppDelegate.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import "HomeViewController.h"
#import "NewEditionPreview.h"
#import "MessageDetailVC.h"
#import "PasswordModificationVC.h"
#import "BaseInfoModifyVC.h"
static SystemSoundID shake_sound_male_id = 0;

#define kBaseInfoModifyKey                  @"BaseInfoModifyKey"
@interface AppDelegate ()
@end

@implementation AppDelegate
- (NSString *)curAutoNaviKey
{
    NSString *bundleID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    if([bundleID isEqualToString:@"cn.edugate.EdugateAppParent"])
        return kAutoNaviApiKey;
    else if([bundleID isEqualToString:@"cn.edugate.inhouse.EdugateAppParent"])
        return kAutoNaviApiInhouseKey;
    return nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupCommonAppearance];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:kCommonBackgroundColor];
    [[SVShareManager sharedInstance] initialize];
    [self setupCommonHandler];
    [self registerThirdParty];
    [self registerRemoteNotification];
    [self registerSound];
    
    if([self isNewVersion])
    {
        [self logout];
    }
    else
    {
        if([[UserCenter sharedInstance] hasLogin])
        {
            HomeViewController *homeVC = [[HomeViewController alloc] init];
            self.rootNavigation = [[TNBaseNavigationController alloc] initWithRootViewController:homeVC];
            [self.window setRootViewController:self.rootNavigation];
            self.homeVC = homeVC;
        }
        else
        {
            LoginVC *loginVC = [[LoginVC alloc] init];
            [loginVC setCompletion:^(BOOL loginSuccess, BOOL loginCancel) {
                if(loginSuccess)
                {
                    [self loginSuccess];
                }
            }];
            self.rootNavigation = [[TNBaseNavigationController alloc] initWithRootViewController:loginVC];
            [self.window setRootViewController:self.rootNavigation];
        }
    }
    
    NSDictionary *notificationInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if(notificationInfo)
        [self handleNotification:notificationInfo];
    [self.window makeKeyAndVisible];
    [WelcomeView showWelcome];
    [self startReachability];
    [[TaskUploadManager sharedInstance] start];
    [self expendOperationGuide];
    [self checkNewVersion];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    return YES;
}


- (void)setupCommonAppearance
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:kCommonParentTintColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
}

- (void)registerThirdParty
{
    [MAMapServices sharedServices].apiKey = [self curAutoNaviKey];
}

- (void)setupCommonHandler
{
    static BOOL showLogout = NO;
    [[HttpRequestEngine sharedInstance] setBaseUrl:kRootRequestUrl];
    if([UserCenter sharedInstance].hasLogin)
        [[HttpRequestEngine sharedInstance] setCommonCacheRoot:[NSString stringWithFormat:@"child_id_%@",[UserCenter sharedInstance].curChild.uid]];
    [[HttpRequestEngine sharedInstance] setCommonParamsBlk:^(NSMutableDictionary *commonParams){
        if([commonParams objectForKey:@"child_id"] == nil)
            [commonParams setValue:[UserCenter sharedInstance].curChild.uid forKey:@"child_id"];
        [commonParams setValue:[UserCenter sharedInstance].userData.accessToken forKey:@"verify"];
        [commonParams setValue:[UserCenter sharedInstance].deviceToken forKey:@"device_token"];
        [commonParams setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"version"];
        [commonParams setValue:@"1" forKey:@"platform"];
    }];

    [[HttpRequestEngine sharedInstance] setCommonHandleBlk:^BOOL(TNDataWrapper *responseWrapper){
        NSInteger errCode = [responseWrapper getIntegerForKey:@"err_code"];
        NSString *errMsg = [responseWrapper getStringForKey:@"err_msg"];
        
        if(errCode == 9003 || errCode == 9004 || errCode == 9005)//重新登录
        {
            if(errCode == 9004)
                errMsg = @"本账号已在其他地点登陆，如不是您本人操作，可能个人信息已泄露，请修改密码或联系客服";
            else if(errCode == 9005)
                errMsg = @"重要关联发生变化，请重新登录";
            self.logouted = YES;
            if([UserCenter sharedInstance].hasLogin && !showLogout)
            {
                showLogout = YES;
                TNButtonItem *item = [TNButtonItem itemWithTitle:@"立刻重新登录" action:^{
                    [ApplicationDelegate logout];
                    showLogout = NO;
                }];
                TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:errMsg buttonItems:@[item]];
                [alertView show];
            }

             return NO;
        }
        else if(errCode == 9009)
        {
            TNButtonItem *item = [TNButtonItem itemWithTitle:@"立即更新" action:^{
                [ApplicationDelegate logout];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kParentClientAppStoreUrl]];
            }];
            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:errMsg buttonItems:@[item]];
            [alertView show];
            return NO;
        }

        TNDataWrapper *statusWrapper = [responseWrapper getDataWrapperForKey:@"status"];
        [[UserCenter sharedInstance].statusManager parseData:statusWrapper];
        
        NSString *missionMsg = [UserCenter sharedInstance].statusManager.missionMsg;
        if(missionMsg.length > 0)
        {
//            [[[ProgressHUD alloc] init] hudMake:missionMsg];
            [ProgressHUD showHintText:missionMsg];
        }
        return YES;
    }];
}


- (void)registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationType types = (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:types categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge
                                                         | UIRemoteNotificationTypeSound
                                                         | UIRemoteNotificationTypeAlert)];
    }
}

- (void)handleNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSDictionary *action = [userInfo objectForKey:@"action"];
    if([action isKindOfClass:[NSDictionary class]])
    {
        NSString *childID = [action objectForKey:@"child_id"];
        if ([childID length] > 0) {
            // 根据app状态来处理
            BOOL contains = NO;
            for (ChildInfo *child in [UserCenter sharedInstance].children) {
                if([child.uid isEqualToString:childID])
                    contains = YES;
            }
            if(contains)
            {
                UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
                if (appState == UIApplicationStateInactive) // 后台切换到前台
                {
                    if([self.rootNavigation.viewControllers lastObject] == self.homeVC)
                    {
                        [self.homeVC selectAtIndex:0];
                        [self.homeVC.messageVC refreshData];
                    }
                }
                else if (appState == UIApplicationStateActive) // 程序在前台
                {
                    [self.homeVC.messageVC refreshData];
                }
            }

            
        }
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* token = [[deviceToken description] stringByTrimmingCharactersInSet:
                       [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    [UserCenter sharedInstance].deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleNotification:userInfo];
}

- (void)checkNewVersion
{
    NSString *urlBase = @"http://itunes.apple.com/lookup?country=%@&id=%@";
    NSString *urlStr = [NSString stringWithFormat:urlBase, [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode],kAppStoreID];
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    [operationManager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *result = [responseObject objectForKey:@"results"];
        if(result.count > 0)
        {
            NSDictionary *info = result[0];
            NSString *releaseNotes = info[@"releaseNotes"];
            NSString *version = info[@"version"];
            NSString *applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            if([applicationVersion compare:version] == NSOrderedAscending)
            {
                NewEditionPreview *preview = [[NewEditionPreview alloc] initWithVersion:version notes:releaseNotes];
                [preview show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)loginSuccess
{
    void (^callback)() = ^(){
        self.logouted = NO;
        [[HttpRequestEngine sharedInstance] setCommonCacheRoot:[NSString stringWithFormat:@"child_id_%@",[UserCenter sharedInstance].curChild.uid]];
        HomeViewController *homeVC = [[HomeViewController alloc] init];
        self.homeVC = homeVC;
        self.rootNavigation = [[TNBaseNavigationController alloc] initWithRootViewController:homeVC];
        if([UserCenter sharedInstance].userData.firstLogin)
        {
            RelatedInfoVC *relatedInfoVC = [[RelatedInfoVC alloc] init];
            [self.rootNavigation pushViewController:relatedInfoVC animated:NO];
        }
        if(![UserCenter sharedInstance].userData.confirmed)
        {
            BaseInfoModifyVC *baseInfoVC = [[BaseInfoModifyVC alloc] init];
            [self.rootNavigation pushViewController:baseInfoVC animated:NO];
        }
        [self.window setRootViewController:self.rootNavigation];
        [self.window makeKeyAndVisible];
    };
    
    if([UserCenter sharedInstance].userData.firstLogin)
    {
        PasswordModificationVC *passWordModificationVC = [[PasswordModificationVC alloc] init];
        [passWordModificationVC setCallback:callback];
        self.rootNavigation = [[TNBaseNavigationController alloc] initWithRootViewController:passWordModificationVC];
        [self.window setRootViewController:self.rootNavigation];
    }
    else
    {
        callback();
    }
}


- (void)logout
{
    self.logouted = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[TaskUploadManager sharedInstance] cleanTask];
        [[HttpRequestEngine sharedInstance] cancelAllTask];
    });
    [self.homeVC.messageVC invalidate];
    
    LoginVC *loginVC = [[LoginVC alloc] init];
    [loginVC setCompletion:^(BOOL loginSuccess, BOOL loginCancel) {
        if(loginSuccess)
        {
            [self loginSuccess];
        }
    }];
    self.rootNavigation = [[TNBaseNavigationController alloc] initWithRootViewController:loginVC];
    [self.window setRootViewController:self.rootNavigation];
    [[UserCenter sharedInstance] logout];
}

- (void)registerSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Noti" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
    }
}

- (void)playSound
{
        AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

- (void)popAndPush:(UIViewController *)vc
{
    NSArray *vcArray = [self.rootNavigation viewControllers];
    if(vcArray.count > 1)
    {
        [self.rootNavigation popToRootViewControllerAnimated:NO];
        [self.homeVC selectAtIndex:0];
    }
    [self.rootNavigation pushViewController:vc animated:YES];
}

- (void)expendOperationGuide
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *codeDatabase = [path stringByAppendingPathComponent:@"Guide"];
//        if(![[NSFileManager defaultManager] fileExistsAtPath:codeDatabase])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *originalPath = [[NSBundle mainBundle] pathForResource:@"Guide" ofType:@"zip"];
                //解压缩
                ZipArchive *za = [[ZipArchive alloc] init];
                if ([za UnzipOpenFile:originalPath])
                {
                    BOOL ret = [za UnzipFileTo: path overWrite: YES];
                    NSLog(@"unzip %d",ret);
                }
                
            });
        }
    });
}

- (BOOL)isNewVersion
{
    NSString *applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults boolForKey:applicationVersion])
    {
        [userDefaults setBool:YES forKey:applicationVersion];
        [userDefaults synchronize];
        return YES;
    }
    return NO;
}


#pragma mark - Reachability
- (void)startReachability
{
    self.hostReach = [Reachability reachabilityWithHostName:@"www.apple.com"];//可以以多种形式初始化
    [self.hostReach startNotifier];  //开始监听,会启动一个run loop
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"user/check_status" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        NSLog(@"%@",responseObject);
    } fail:^(NSString *errMsg) {
        
    }];
    [self.homeVC.messageVC refreshData];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

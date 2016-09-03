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
#import "ContactVC.h"
#import "MessageVC.h"
#import "MineVC.h"
#import "LZTabBarButton.h"

@interface HomeViewController : UITabBarController
{
    UIView*             _tabBarCover;
    NSArray *           _tabDatas;
    NSMutableArray *    _tabbarButtons;
}
@property (nonatomic, weak)MessageVC *messageVC;
- (void)selectAtIndex:(NSInteger)index;
- (NSArray *)commonLeftBarButtonItems;
- (void)showIMVC;
@end


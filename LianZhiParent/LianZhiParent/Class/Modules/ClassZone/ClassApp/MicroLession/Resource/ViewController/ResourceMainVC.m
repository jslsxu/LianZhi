//
//  ResourceMainVC.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/28.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ResourceMainVC.h"
#import "LZTabBarButton.h"
#import "ThroughTrainingVC.h"
#import "AcademicAnalysisVC.h"
#import "LearningTasksVC.h"
#import "ResourceDefine.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ParamUtil.h"
@interface ResourceMainVC ()

@end

@implementation ResourceMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hidesBottomBarWhenPushed = YES;
    
    
    self.fd_interactivePopDisabled = YES;
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = JXColor(0xf7,0xf7,0xf9,1);
    NSMutableArray *subVCs = [[NSMutableArray alloc] initWithCapacity:0];
//    NSArray *subVCArray = @[@"AcademicAnalysisVC",@"ThroughTrainingVC"]; //,@"LearningTasksVC"
    NSArray *subVCArray = @[@"ThroughTrainingVC" ,@"AcademicAnalysisVC"];
    for (NSInteger i = 0; i < subVCArray.count; i++)
    {
        NSString *className = subVCArray[i];
        ResourceBaseVC  *vc = [[NSClassFromString(className) alloc] init];
        vc.baseRootVC = self;
        [subVCs addObject:vc];
    }
    [self setViewControllers:subVCs];
    [self initialViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    NSArray *tabItemTitleArray = @[@"闯关训练",@"学情分析"]; //,@"学习任务"
//    NSArray *tabItemTitleArray = @[@"学情分析",@"闯关训练"];
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


- (void)onTabButtonClicked:(UIButton *)button
{
    NSInteger index = [_tabbarButtons indexOfObject:button];
    [self selectAtIndex:index];
}

- (void)selectAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    NSArray *tabImageNameArray = @[@"cgxl",@"xqfx"]; //,@"HomeTabHome"
//    NSArray *tabImageNameArray = @[@"xqfx",@"cgxl"]; //,@"HomeTabHome"
    for (NSInteger i = 0; i < _tabbarButtons.count; i++)
    {
        LZTabBarButton *barButton = _tabbarButtons[i];
        BOOL selected = (i == self.selectedIndex);
        NSString *imageName = selected ? [NSString stringWithFormat:@"%@_sel",tabImageNameArray[i]] : [NSString stringWithFormat:@"%@_nor",tabImageNameArray[i]];
        UIColor *titleColor = selected ? kCommonParentTintColor : [UIColor grayColor];
        [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        [barButton setTitleColor:titleColor forState:UIControlStateNormal];
        [barButton setTitleColor:titleColor forState:UIControlStateHighlighted];
  
    }
    self.title = (index == 0 ? @"闯关训练":@"学情分析");
}


- (void)setClassInfo:(ClassInfo *)classInfo
{
 
    [ParamUtil sharedInstance].classInfo = classInfo;

}
@end

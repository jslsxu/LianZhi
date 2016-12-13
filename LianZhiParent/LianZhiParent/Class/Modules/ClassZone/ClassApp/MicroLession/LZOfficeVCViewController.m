//
//  LZMicrolessonVCViewController.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LZOfficeVCViewController.h"

#import "ResourceDefine.h"



@interface LZOfficeVCViewController ()



@end

@implementation LZOfficeVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 1;
    

}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = 0;
    
    [CurrentROOTNavigationVC popViewControllerAnimated:YES];
}

-(void)customBackItemClicked
{
  
   [self back];
}
- (void)dismiss{
    
   [self back];
    
}
-(void)closeItemClicked{
   [self back];
}

- (BOOL)prefersStatusBarHidden
{
//    //iOS7前隐藏StatusBar
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    //iOS7以后隐藏StatusBar
    return YES;
}

@end

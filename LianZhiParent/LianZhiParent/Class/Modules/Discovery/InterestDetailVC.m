//
//  InterestDetailVC.m
//  LianZhiParent
//
//  Created by jslsxu on 16/1/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "InterestDetailVC.h"

@interface InterestDetailVC ()

@end

@implementation InterestDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
}

- (void)share
{
   
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

@end

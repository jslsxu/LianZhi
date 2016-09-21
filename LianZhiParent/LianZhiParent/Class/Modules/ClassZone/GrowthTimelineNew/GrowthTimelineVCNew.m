//
//  GrowthTimelineVCNew.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "GrowthTimelineVCNew.h"
#import "MonthPickerView.h"
@interface GrowthTimelineVCNew ()

@end

@implementation GrowthTimelineVCNew

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"eeeef4"]];
    self.title = @"成长手册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"日历" style:UIBarButtonItemStylePlain target:self action:@selector(showCalendar)];
}

- (void)showCalendar{
    [MonthPickerView showWithCompletion:^(NSDate *date) {
        
    }];
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

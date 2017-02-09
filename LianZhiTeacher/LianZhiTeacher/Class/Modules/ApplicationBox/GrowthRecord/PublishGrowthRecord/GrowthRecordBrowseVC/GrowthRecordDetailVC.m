//
//  PublishGrowthRecordVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthRecordDetailVC.h"
#import "Calendar.h"
@interface GrowthRecordDetailVC ()<CalendarDelegate>
@property (nonatomic, strong)Calendar* calendar;
@end

@implementation GrowthRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"家园手册";
    
    [self.view addSubview:[self calendar]];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

#pragma mark - CalendarDelegate
- (void)calendarDateDidChange:(NSDate *)selectedDate{
    
}

- (void)calendarHeightWillChange:(CGFloat)height{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

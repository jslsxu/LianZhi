//
//  PublishGrowthRecordVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthRecordDetailVC.h"
#import "Calendar.h"
#import "GrowthRecordChildSwitchView.h"
@interface GrowthRecordDetailVC ()<CalendarDelegate>
@property (nonatomic, strong)Calendar* calendar;
@property (nonatomic, strong)GrowthRecordChildSwitchView* switchView;
@end

@implementation GrowthRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title = @"家园手册";
    
    [self.view addSubview:[self calendar]];
    [self.view addSubview:[self switchView]];
    [self.switchView setY:self.calendar.bottom];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (GrowthRecordChildSwitchView *)switchView{
    if(nil == _switchView){
        _switchView = [[GrowthRecordChildSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
        [_switchView setIndexChanged:^(NSInteger selectedIndex) {
            
        }];
        [_switchView setGrowthRecordArray:self.studentArray];
        [_switchView setSelectedIndex:[self.studentArray indexOfObject:self.studentInfo]];
    }
    return _switchView;
}

#pragma mark - CalendarDelegate
- (void)calendarDateDidChange:(NSDate *)selectedDate{
    
}

- (void)calendarHeightWillChange:(CGFloat)height{
    [UIView animateWithDuration:0.3 animations:^{
        [self.switchView setY:height];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

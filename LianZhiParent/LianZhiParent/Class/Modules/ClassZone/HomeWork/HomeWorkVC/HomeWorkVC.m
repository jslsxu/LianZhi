//
//  HomeWorkVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkVC.h"
#import "HomeWorkListModel.h"
#import "Calendar.h"
#import "HomeworkDetailVC.h"
@interface HomeWorkVC ()<CalendarDelegate>
@property (nonatomic, strong)Calendar *calendar;
@end

@implementation HomeWorkVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.interactivePopDisabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"eeeef4"]];
    self.title = @"作业练习";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    
    [self.view addSubview:[self calendar]];
    
    [self.tableView setFrame:CGRectMake(0, self.calendar.bottom, self.view.width, self.view.height - self.calendar.bottom)];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self bindTableCell:@"HomeWorkCell" tableModel:@"HomeworkListModel"];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (void)clear{
    
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"exercises/lists"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"class_id"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [params setValue:[dateFormatter stringFromDate:self.calendar.currentSelectedDate] forKey:@"sdate"];
    [task setParams:params];
    return task;
}

//- (BOOL)supportCache{
//    return YES;
//}
//
//- (NSString *)cacheFileName{
//    return [NSString stringWithFormat:@"%@_%@",[self class],self.classID];
//}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    HomeworkItem *homeworkItem = (HomeworkItem *)modelItem;
    HomeworkDetailVC *detailVC = [[HomeworkDetailVC alloc] init];
    [detailVC setHomeworkId:homeworkItem.eid];
    [CurrentROOTNavigationVC pushViewController:detailVC animated:YES];
}

#pragma mark - CalendarDelegate
- (void)calendarHeightWillChange:(CGFloat)height{
    [self.tableView setFrame:CGRectMake(0, height, self.view.width, self.view.height - height)];
}

- (void)calendarDateDidChange:(NSDate *)selectedDate{
    [self requestData:REQUEST_REFRESH];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

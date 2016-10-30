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
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 10, 0)];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self bindTableCell:@"HomeWorkCell" tableModel:@"HomeworkListModel"];
    [self setSupportPullUp:YES];
    [self setSupportPullDown:YES];
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

- (void)requestData:(REQUEST_TYPE)requestType{
    [super requestData:requestType];
    HomeworkListModel *model = (HomeworkListModel *)self.tableViewModel;
    [model setDate:[self.calendar currentSelectedDate]];
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

- (void)deleteHomework:(NSString *)eid{
    for (HomeworkItem *item in self.tableViewModel.modelItemArray) {
        if([item.eid isEqualToString:eid]){
            [self.tableViewModel.modelItemArray removeObject:item];
            [self.tableView reloadData];
            return;
        }
    }
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    HomeworkItem *homeworkItem = (HomeworkItem *)modelItem;
    HomeworkDetailVC *detailVC = [[HomeworkDetailVC alloc] init];
    [detailVC setEid:homeworkItem.eid];
    [detailVC setDeleteCallback:^(NSString *eid) {
        [wself deleteHomework:eid];
    }];
    [CurrentROOTNavigationVC pushViewController:detailVC animated:YES];
}

#pragma mark - CalendarDelegate
- (void)calendarHeightWillChange:(CGFloat)height{
    [self.tableView setFrame:CGRectMake(0, height, self.view.width, self.view.height - height)];
}

- (void)calendarDateDidChange:(NSDate *)selectedDate{
    HomeworkListModel *model = (HomeworkListModel *)self.tableViewModel;
    [model clear];
    [self.tableView reloadData];
    [self requestData:REQUEST_REFRESH];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

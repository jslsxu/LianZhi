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
#import "HomeWorkCell.h"
@interface HomeWorkVC ()<CalendarDelegate>
@property (nonatomic, strong)Calendar *calendar;
@property (nonatomic, strong)MBProgressHUD* hud;
@property (nonatomic, strong)EmptyHintView* noHomeworkView;
@end

@implementation HomeWorkVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self.interactivePopDisabled = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData:REQUEST_REFRESH];
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
    [self loadCache];
}

- (Calendar *)calendar{
    if(_calendar == nil){
        _calendar = [[Calendar alloc] initWithDate:[NSDate date]];
        [_calendar setDelegate:self];
    }
    return _calendar;
}

- (EmptyHintView *)noHomeworkView{
    if(nil == _noHomeworkView){
        _noHomeworkView = [[EmptyHintView alloc] initWithImage:@"noHomework" title:@"暂时没有作业练习"];
        [_noHomeworkView setHidden:YES];
        [self.view addSubview:_noHomeworkView];
    }
    return _noHomeworkView;
}

- (void)clear{
    __weak typeof(self) wself = self;
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"确定要清除当天作业吗?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"清除"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        NSDate *date = [wself.calendar currentSelectedDate];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *sdate = [formatter stringFromDate:date];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:wself.classID forKey:@"class_id"];
        [params setValue:sdate forKey:@"sdate"];
        NSString *cachePath = [wself cacheFilePath];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:NO];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/pclear" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:wself completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:NO];
            [wself.tableViewModel clear];
            [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
            [wself.tableView reloadData];
            [wself requestData:REQUEST_REFRESH];
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)requestUnread{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"class_id"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [params setValue:[dateFormatter stringFromDate:self.calendar.currentSelectedDate] forKey:@"sdate"];
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [NSDate date];
    NSDate *startDate = [endDate dateByAddingDays:-90];
    NSString *fromDateStr = [dateFormatter stringFromDate:startDate];
    NSString *endDateStr = [dateFormatter stringFromDate:endDate];
    [params setValue:fromDateStr forKey:@"from_date"];
    [params setValue:endDateStr forKey:@"end_date"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/month_unread" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)requestData:(REQUEST_TYPE)requestType{
    [super requestData:requestType];
    HomeworkListModel *model = (HomeworkListModel *)self.tableViewModel;
    [model setDate:[self.calendar currentSelectedDate]];
    NSLog(@"date is %@",model.date);
//    [self requestUnread];
}

- (void)loadCache{
    if([self supportCache])//支持缓存，先出缓存中读取数据
    {
        NSData *data = [NSData dataWithContentsOfFile:[self cacheFilePath]];
        if(data.length > 0){
            self.tableViewModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self.tableView reloadData];
        }
    }
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"exercises/lists"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classID forKey:@"class_id"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [params setValue:[dateFormatter stringFromDate:self.calendar.currentSelectedDate] forKey:@"sdate"];
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:@"yyyy-MM-dd"];
    NSDate *endDate = [NSDate date];
    NSDate *startDate = [endDate dateByAddingDays:-90];
    NSString *fromDateStr = [dateFormatter stringFromDate:startDate];
    NSString *endDateStr = [dateFormatter stringFromDate:endDate];
    [params setValue:fromDateStr forKey:@"from_date"];
    [params setValue:endDateStr forKey:@"end_date"];
    [task setParams:params];
    return task;
}

- (void)deleteLocalHomework:(NSString *)eid{
    for (HomeworkItem *item in self.tableViewModel.modelItemArray) {
        if([item.eid isEqualToString:eid]){
            [self.tableViewModel.modelItemArray removeObject:item];
            [self.tableView reloadData];
            [self saveCache];
            return;
        }
    }
}

- (void)deleteHomework:(HomeworkItem *)homeworkItem{
    __weak typeof(self) wself = self;
    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:@"提醒" message:@"是否删除该作业?" style:LGAlertViewStyleAlert buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除"];
    [alertView setCancelButtonFont:[UIFont systemFontOfSize:18]];
    [alertView setDestructiveButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setDestructiveHandler:^(LGAlertView *alertView) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:homeworkItem.eid forKey:@"eid"];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/delete" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [wself.tableViewModel.modelItemArray removeObject:homeworkItem];
            [wself.tableView reloadData];
            [wself saveCache];
            [wself requestData:REQUEST_REFRESH];
        } fail:^(NSString *errMsg) {
            
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    HomeworkItem *homeworkItem = [self.tableViewModel.modelItemArray objectAtIndex:indexPath.row];
    HomeWorkCell *homeworkCell = (HomeWorkCell *)cell;
    [homeworkCell setDeleteCallback:^(NSString *eid){
        [wself deleteHomework:homeworkItem];
    }];
}

- (void)TNBaseTableViewControllerRequestStart{
    self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
}

- (void)TNBaseTableViewControllerRequestSuccess{
    [self.hud hide:NO];
    HomeworkListModel *listModel = (HomeworkListModel *)self.tableViewModel;
    [self.calendar setUnreadDays:listModel.unread_days];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = [super tableView:tableView numberOfRowsInSection:section];
    [self.noHomeworkView setHidden:count != 0];
    [self.noHomeworkView setCenter:CGPointMake(self.view.width / 2, (self.view.height + self.calendar.bottom) / 2)];
    return count;
}

- (void)TNBaseTableViewControllerRequestFailedWithError:(NSString *)errMsg{
    [self.hud hide:NO];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    HomeworkItem *homeworkItem = (HomeworkItem *)modelItem;
    HomeworkDetailVC *detailVC = [[HomeworkDetailVC alloc] init];
    [detailVC setEid:homeworkItem.eid];
    [detailVC setDeleteCallback:^(NSString *eid) {
        [wself deleteLocalHomework:eid];
    }];
    [detailVC setHomeworkStatusCallback:^(HomeworkStatus status) {
        [homeworkItem setUnread_s:NO];
        [homeworkItem setStatus:status];
        [wself.tableView reloadData];
    }];
    [CurrentROOTNavigationVC pushViewController:detailVC animated:YES];
}

- (BOOL)supportCache{
    return YES;
}

- (NSString* )cacheFileName{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateStr = [dateFormatter stringFromDate:self.calendar.currentSelectedDate];
    return [NSString stringWithFormat:@"%@_%@_%@",[self class],self.classID,dateStr];
}

#pragma mark - CalendarDelegate
- (void)calendarHeightWillChange:(CGFloat)height{
    [self.tableView setFrame:CGRectMake(0, height, self.view.width, self.view.height - height)];
    [self.noHomeworkView setCenter:CGPointMake(self.view.width / 2, (self.view.height + self.calendar.bottom) / 2)];
}

- (void)calendarDateDidChange:(NSDate *)selectedDate{
    HomeworkListModel *model = (HomeworkListModel *)self.tableViewModel;
    [model clear];
    [self loadCache];
    [self.tableView reloadData];
    [self requestData:REQUEST_REFRESH];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

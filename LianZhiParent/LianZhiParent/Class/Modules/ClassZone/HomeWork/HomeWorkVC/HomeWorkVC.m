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
        NSString *cachePath = [self cacheFilePath];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:NO];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/pclear" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:wself completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            [hud hide:NO];
            [wself.tableViewModel clear];
            [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
            [wself.tableView reloadData];
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
        }];
    }];
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)requestData:(REQUEST_TYPE)requestType{
    [super requestData:requestType];
    HomeworkListModel *model = (HomeworkListModel *)self.tableViewModel;
    [model setDate:[self.calendar currentSelectedDate]];
    NSLog(@"date is %@",model.date);
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

- (void)deleteHomework:(NSString *)eid{
    for (HomeworkItem *item in self.tableViewModel.modelItemArray) {
        if([item.eid isEqualToString:eid]){
            [self.tableViewModel.modelItemArray removeObject:item];
            [self.tableView reloadData];
            return;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeworkItem *homeworkItem = [self.tableViewModel.modelItemArray objectAtIndex:indexPath.row];
    HomeWorkCell *homeworkCell = (HomeWorkCell *)cell;
    [homeworkCell setDeleteCallback:^(NSString *eid){
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
                [wself.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
            } fail:^(NSString *errMsg) {
                
            }];
        }];
        [alertView showAnimated:YES completionHandler:nil];
    }];
}

- (void)TNBaseTableViewControllerItemSelected:(TNModelItem *)modelItem atIndex:(NSIndexPath *)indexPath{
    __weak typeof(self) wself = self;
    HomeworkItem *homeworkItem = (HomeworkItem *)modelItem;
    HomeworkDetailVC *detailVC = [[HomeworkDetailVC alloc] init];
    [detailVC setEid:homeworkItem.eid];
    [detailVC setDeleteCallback:^(NSString *eid) {
        [wself deleteHomework:eid];
    }];
    [detailVC setHomeworkReadCallback:^(NSString *eid) {
        [homeworkItem setUnread_s:NO];
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

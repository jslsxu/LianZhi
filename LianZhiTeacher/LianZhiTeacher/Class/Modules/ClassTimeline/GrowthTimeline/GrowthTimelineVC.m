//
//  GrowthTimelineVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelineVC.h"
#import "PublishSelectionView.h"
#import "ClassSelectionVC.h"
@implementation GrowthTimelineHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _curMonth = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 160) / 2, 0, 160, self.height)];
        [_curMonth setTextAlignment:NSTextAlignmentCenter];
        [_curMonth setBackgroundColor:[UIColor clearColor]];
        [_curMonth setFont:[UIFont systemFontOfSize:14]];
        [_curMonth setTextColor:kCommonTeacherTintColor];
        [self addSubview:_curMonth];
        
        CGFloat width = 30;
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setFrame:CGRectMake(_curMonth.right , (self.height - width) / 2, width, width)];
        [_nextButton setImage:[UIImage imageNamed:@"NextArrowNormal"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"NextArrowDisabled"] forState:UIControlStateDisabled];
        [_nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
    
        
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preButton setFrame:CGRectMake(_curMonth.x - width, (self.height - width) / 2, width, width)];
        [_preButton setImage:[UIImage imageNamed:(@"PreArrowNormal")] forState:UIControlStateNormal];
        [_preButton setImage:[UIImage imageNamed:(@"PreArrowDisabled")] forState:UIControlStateDisabled];
        [_preButton addTarget:self action:@selector(onPre) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_preButton];
        
        [self setDate:[NSDate date]];
        
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    [_curMonth setText:[NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:self.date], [self.date weekday]]];
    [_nextButton setEnabled:[self hasNext]];
}

- (BOOL)hasNext
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *thisStr = [formatter stringFromDate:self.date];
    NSString *curStr = [formatter stringFromDate:[NSDate date]];
    if([thisStr isEqualToString:curStr])
        return NO;
    return YES;
}

- (void)onPre
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.date];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    [adcomps setDay:-1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self.date options:0];
    [self setDate:newdate];
    if([self.delegate respondsToSelector:@selector(growthDatePickerFinished:)])
        [self.delegate growthDatePickerFinished:self.date];
}

- (void)onNext
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = nil;
    
    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.date];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    
    [adcomps setYear:0];
    
    [adcomps setMonth:0];
    
    [adcomps setDay:1];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:self.date options:0];
    if([newdate compare:[NSDate date]] == NSOrderedDescending)
        return;
    
    [self setDate:newdate];
    if([self.delegate respondsToSelector:@selector(growthDatePickerFinished:)])
        [self.delegate growthDatePickerFinished:self.date];
}

@end

@interface GrowthTimelineVC ()
@property (nonatomic, strong)NSDate *date;
@end

@implementation GrowthTimelineVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        ClassInfo *classInfo = [UserCenter sharedInstance].curSchool.classes[0];
        self.classID = classInfo.classID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"切换" style:UIBarButtonItemStylePlain target:self action:@selector(onSwitchClass)];
    self.date = [NSDate date];
    _headerView = [[GrowthTimelineHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 80)];
    [_headerView setDelegate:self];
    [self.tableView setTableHeaderView:_headerView];

    [self bindTableCell:@"GrowthTimelineCell" tableModel:@"GrowthTimelineModel"];
    [self setSupportPullUp:YES];
    [self setShouldShowEmptyHint:YES];
    [self requestData:REQUEST_REFRESH];
}

- (void)onSwitchClass
{
    __weak typeof(self) wself = self;
    ClassSelectionVC *classSelectionVC = [[ClassSelectionVC alloc] init];
    [classSelectionVC setOriginalClassID:self.classID];
    [classSelectionVC setSelection:^(ClassInfo *classInfo) {
        wself.classID = classInfo.classID;
        [wself requestData:REQUEST_REFRESH];
    }];
    [self.navigationController pushViewController:classSelectionVC animated:YES];
}

#pragma mark - GrowthDatePickerDelegate
- (void)growthDatePickerFinished:(NSDate *)date
{
    [self setDate:date];
    [self requestData:REQUEST_REFRESH];
}


- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:self.date];
    
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"class/record_list"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.classID forKey:@"class_id"];
    [params setValue:dateStr forKey:@"date"];
    [task setParams:params];
    [task setObserver:self];
    return task;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

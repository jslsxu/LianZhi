//
//  GrowthTimelineVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelineVC.h"

@implementation GrowthTimelineHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
        [_avatar sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar]];
        [self addSubview:_avatar];
        
        CGFloat width = 20;
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setFrame:CGRectMake(self.width - 10 - width, 36, width, width)];
        [_nextButton setImage:[UIImage imageNamed:@"DatePickerNextNormal"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"DatePickerNextDisabled"] forState:UIControlStateDisabled];
        [_nextButton addTarget:self action:@selector(onNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextButton];
        
        _curMonth = [[UILabel alloc] initWithFrame:CGRectMake(_nextButton.left - 90, 36, 90, 20)];
        [_curMonth setTextAlignment:NSTextAlignmentCenter];
        [_curMonth setBackgroundColor:[UIColor clearColor]];
        [_curMonth setFont:[UIFont systemFontOfSize:16]];
        [_curMonth setTextColor:kCommonParentTintColor];
        [self addSubview:_curMonth];
        
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preButton setFrame:CGRectMake(_curMonth.left - width, 36, width, width)];
        [_preButton setImage:[UIImage imageNamed:@"DatePickerPreNormal"] forState:UIControlStateNormal];
        [_preButton setImage:[UIImage imageNamed:@"DatePickerPreDisabled"] forState:UIControlStateDisabled];
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
    [formatter setDateFormat:@"yyyy年MM月"];
    [_curMonth setText:[formatter stringFromDate:self.date]];
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
    NSDate *newdate = [self.date dateByAddingMonths:-1];
    [self setDate:newdate];
    if([self.delegate respondsToSelector:@selector(growthDatePickerFinished:)])
        [self.delegate growthDatePickerFinished:self.date];
}

- (void)onNext
{
    NSDate *newdate = [self.date dateByAddingMonths:1];
    if([newdate compare:[NSDate date]] == NSOrderedDescending)
        return;
    
    [self setDate:newdate];
    if([self.delegate respondsToSelector:@selector(growthDatePickerFinished:)])
        [self.delegate growthDatePickerFinished:self.date];
}

@end

@interface GrowthTimelineVC ()

@end

@implementation GrowthTimelineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"成长手册";
    self.date = [NSDate date];
    
    _headerView = [[GrowthTimelineHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 70)];
    [_headerView setDelegate:self];
    [self.view addSubview:_headerView];
    
    _verLine = [[UIView alloc] initWithFrame:CGRectMake(50, _headerView.height, 2, self.view.height - 64 - _headerView.height)];
    [_verLine setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_verLine];
    
    [self.view bringSubviewToFront:self.tableView];
    [self.tableView setFrame:CGRectMake(0, _headerView.bottom, self.tableView.width, self.view.height - _headerView.bottom)];
    [self setShouldShowEmptyHint:YES];
    [self bindTableCell:@"GrowthTimelineCell" tableModel:@"GrowthTimelineModel"];
    [self setSupportPullUp:YES];
    [self requestData:REQUEST_REFRESH];
}

- (BOOL)supportCache
{
    return YES;
}

- (NSString *)cacheFileName
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *str = [formatter stringFromDate:self.date];
    return [NSString stringWithFormat:@"%@_%@_%@",[self class],[UserCenter sharedInstance].curChild.uid,str];
}

#pragma mark - GrowthDatePickerDelegate
- (void)growthDatePickerFinished:(NSDate *)date
{
    self.date = date;
    [self requestData:REQUEST_REFRESH];
}

- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType
{
    HttpRequestTask *task = [[HttpRequestTask alloc] init];
    [task setRequestUrl:@"class/record_list"];
    [task setRequestMethod:REQUEST_GET];
    [task setRequestType:requestType];
    
    ChildInfo *curChild = [UserCenter sharedInstance].curChild;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:curChild.uid forKey:@"child_id"];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [params setValue:self.classInfo.school.schoolID forKey:@"school_id"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *str = [formatter stringFromDate:self.date];
    [params setValue:str forKey:@"month"];
    [task setParams:params];
    [task setObserver:self];
    return task;
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint offset = scrollView.contentOffset;
//    CGFloat y = _headerView.height - offset.y;
//    [_verLine setFrame:CGRectMake(55, y, 2, self.view.height - y)];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

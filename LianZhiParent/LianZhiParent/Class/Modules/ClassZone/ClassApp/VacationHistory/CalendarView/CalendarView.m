//
//  CalendarView.m
//  YouYao
//
//  Created by jslsxu on 15/6/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "CalendarView.h"

#define kHMargin                20

@implementation CalendarGridCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 5, 5)];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setText:@"1"];
        [_dateLabel setFont:[UIFont systemFontOfSize:14]];
        [_dateLabel setTextColor:[UIColor grayColor]];
        [self addSubview:_dateLabel];
        
        _feelingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BadFaceHighlighted"]];
        [_feelingImageView setFrame:CGRectMake(self.width - 2 - 15, 2, 15, 15)];
        [self addSubview:_feelingImageView];
        
        _drugImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CalendarDrug"]];
        [_drugImageView setOrigin:CGPointMake(self.width - 2 - _drugImageView.width, self.height - 2 - _drugImageView.height)];
        [self addSubview:_drugImageView];

    }
    return self;
}

- (void)setVacationHistoryItem:(VacationHistoryItem *)vacationHistoryItem
{
    _vacationHistoryItem = vacationHistoryItem;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSDate date]];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSInteger dateNum = dateStr.integerValue;
    [_dateLabel setText:[NSString stringWithFormat:@"%ld",(long)dateNum]];
}

- (void)setCurMonth:(BOOL)curMonth
{
    _curMonth = curMonth;
    if(curMonth)
    {
        [_dateLabel setTextColor:[UIColor grayColor]];
    }
    else
    {
        [_dateLabel setTextColor:[UIColor colorWithHexString:@"D8D8D8"]];
    }
}
@end

@interface CalendarView ()
@property (nonatomic, strong)NSArray *dateArray;
@end

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _weekdayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 35)];
        [self setupWeekdayView:_weekdayView];
        [self addSubview:_weekdayView];
        
        NSInteger width = (self.width - kHMargin * 2) / 7;
        NSInteger height = width;
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [_flowLayout setItemSize:CGSizeMake(width, height)];
        [_flowLayout setMinimumInteritemSpacing:0];
        [_flowLayout setMinimumLineSpacing:0];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _weekdayView.bottom - 1, self.width, 100 + 2) collectionViewLayout:_flowLayout];
        [_collectionView setContentInset:UIEdgeInsetsMake(0, kHMargin, 0, kHMargin)];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView registerClass:[CalendarGridCell class] forCellWithReuseIdentifier:@"CalendarGridCell"];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [self addSubview:_collectionView];
        
        [self bringSubviewToFront:_weekdayView];
        
        self.curMonth = [NSDate date];
    }
    return self;
}

- (void)setupWeekdayView:(UIView *)viewParent
{
    [viewParent setBackgroundColor:[UIColor whiteColor]];
    
    NSInteger width = (viewParent.width - kHMargin * 2) / 7;
    for (NSInteger i = 0; i < 7; i++)
    {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHMargin + width * i, 0, width, viewParent.height)];
        [weekdayLabel setTextColor:[UIColor darkGrayColor]];
        [weekdayLabel setFont:[UIFont systemFontOfSize:14]];
        [weekdayLabel setTextAlignment:NSTextAlignmentCenter];
        [weekdayLabel setText:[Utility weekdayNameForIndex:i]];
        [viewParent addSubview:weekdayLabel];
    }
}

- (void)setCurMonth:(NSDate *)curMonth
{
    _curMonth = curMonth;
    
//    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
//    [formmater setDateFormat:@"yyyy/MM"];
//    NSString *str = [formmater stringFromDate:self.curMonth];
//    NSDate *beginDate = [formmater dateFromString:str];
//    
//    NSInteger numOfRows = [self numOfRows];
//    NSMutableArray *dateArrayTmp = [[NSMutableArray alloc] initWithCapacity:0];
//    NSInteger firstWeekday = [self.curMonth firstWeekDayInMonth];
//    for (NSInteger i = 0; i < numOfRows * 7; i++)
//    {
//        NSInteger offset = (i - firstWeekday + 1) * 3600 * 24;
//        NSDate *date  = [NSDate dateWithTimeInterval:offset sinceDate:beginDate];
//        [dateArrayTmp addObject:date];
//    }
//    self.dateArray = dateArrayTmp;

    [_collectionView setHeight:[self numOfRows] * _flowLayout.itemSize.height];
    [self setHeight:_collectionView.height + _weekdayView.height];
    if([self.delegate respondsToSelector:@selector(calendarViewFrameDidChanged)])
        [self.delegate calendarViewFrameDidChanged];
    [_collectionView reloadData];
}

- (NSInteger)numOfRows
{
    return  ([self.curMonth numDaysInMonth] + [self.curMonth firstWeekDayInMonth] + 6) / 7;
}

- (void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    [_collectionView reloadData];

//    if([self.delegate respondsToSelector:@selector(calendarViewSelectDate:item:)])
//        [self.delegate calendarViewSelectDate:selectedDate item:collection];
}

#pragma mark - UICOllectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return self.dateArray.count;
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"CalendarGridCell";
    CalendarGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
//    PlanCollection *collection = self.dateArray[indexPath.row];
//    [cell setPlanCollection:collection];
//    NSInteger selectedTimeInterval = [self.selectedDate timeIntervalSince1970];
//    [cell setFocused:selectedTimeInterval == collection.timeInterval];
//  
//    NSDate *curDate = [NSDate dateWithTimeIntervalSince1970:collection.timeInterval];
//    
//    [cell setCurMonth:([curDate month] == [self.curMonth month])];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarGridCell *cell = (CalendarGridCell *)[collectionView cellForItemAtIndexPath:indexPath];
}
@end

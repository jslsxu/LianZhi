//
//  Calendar.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "Calendar.h"
#import "NSDate+convenience.h"
#import "NSDate+WQCalendarLogic.h"
#import "CalendarMonthIndicator.h"

#define kCalendarItemHeight                 34
@implementation CalendarDayView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor clearColor]];
    
        _dayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dayLabel setFont:[UIFont systemFontOfSize:14]];
        [_dayLabel setTextColor:[UIColor colorWithHexString:@"222222"]];
        [_dayLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_dayLabel];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        [_redDot.layer setCornerRadius:2];
        [_redDot.layer setMasksToBounds:YES];
        [_redDot setBackgroundColor:[UIColor colorWithHexString:@"e00909"]];
        [_redDot setHidden:YES];
        [self addSubview:_redDot];
        
        _greenDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        [_greenDot.layer setCornerRadius:2];
        [_greenDot.layer setMasksToBounds:YES];
        [_greenDot setBackgroundColor:kCommonTeacherTintColor];
        [_greenDot setHidden:YES];
        [self addSubview:_greenDot];
        
        CGFloat itemWidth = MIN(self.width, self.height);
        _curDateIndicator = [[UIView alloc] initWithFrame:CGRectMake((self.width - itemWidth) / 2, (self.height - itemWidth) / 2, itemWidth, itemWidth)];
        [_curDateIndicator.layer setCornerRadius:_curDateIndicator.width / 2];
        [_curDateIndicator.layer setBorderWidth:1.5];
        [_curDateIndicator.layer setBorderColor:kCommonTeacherTintColor.CGColor];
        [_curDateIndicator.layer setMasksToBounds:YES];
        [_curDateIndicator setHidden:YES];
        [self addSubview:_curDateIndicator];
    }
    return self;
}

- (void)setDate:(NSDate *)date{
    _date = date;
    [_dayLabel setText:kStringFromValue(date.day)];
    [_dayLabel sizeToFit];
    [_dayLabel setCenter:CGPointMake(self.width / 2, self.height / 2)];
    [_greenDot setHidden:![date isToday]];
    [_greenDot setCenter:CGPointMake(_dayLabel.centerX, _dayLabel.bottom + 2)];
}

- (void)setIsChosen:(BOOL)isChosen{
    _isChosen = isChosen;
    [_curDateIndicator setHidden:!_isChosen];
}

- (void)setIsCurMonth:(BOOL)isCurMonth{
    _isCurMonth = isCurMonth;
    [_dayLabel setTextColor:_isCurMonth ? [UIColor colorWithHexString:@"222222"] : [UIColor colorWithHexString:@"cccccc"]];
}

- (void)setHighlightedRed:(BOOL)highlightedRed{
    _highlightedRed = highlightedRed;
    if(_highlightedRed){
        [_dayLabel setTextColor:kRedColor];
    }
    else{
        [_dayLabel setTextColor:_isCurMonth ? [UIColor colorWithHexString:@"222222"] : [UIColor colorWithHexString:@"cccccc"]];
    }
}

- (void)setHasNew:(BOOL)hasNew{
    _hasNew = hasNew;
    [_redDot setHidden:!_hasNew];
    [_redDot setOrigin:CGPointMake(_dayLabel.right, _dayLabel.top)];
}

@end

@interface Calendar ()<UICollectionViewDelegate, UICollectionViewDataSource, CalendarMonthDelegate>
@property (nonatomic, strong)NSMutableArray*    dateArray;
@property (nonatomic, strong)CalendarMonthIndicator*    monthIndicator;
@property (nonatomic, strong)UIView*            weekdayHeader;
@property (nonatomic, strong)UICollectionView*  collectionView;
@property (nonatomic, strong)NSDate*            selectedDate;
@end

@implementation Calendar

- (instancetype)initWithDate:(NSDate *)date{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    if(self){
        self.calendarType = CalendarTypeWeek;
        _date = date;
        _selectedDate = date;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.monthIndicator];
        [self addSubview:self.weekdayHeader];
        [self.weekdayHeader setY:self.monthIndicator.bottom];
        [self addSubview:self.collectionView];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:sepLine];
        
        [self updateSubviews:NO];
        
        [self addGestures];
    }
    return self;
}

- (void)addGestures{
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:swipeGestureUp];
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self addGestureRecognizer:swipeGestureDown];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipGesture{
    UISwipeGestureRecognizerDirection direction = swipGesture.direction;
    if(direction == UISwipeGestureRecognizerDirectionUp){
        if(self.calendarType == CalendarTypeMonth){
            self.calendarType = CalendarTypeWeek;
        }
    }
    else if(direction == UISwipeGestureRecognizerDirectionDown){
        if(self.calendarType == CalendarTypeWeek){
            self.calendarType = CalendarTypeMonth;
        }
    }
}

- (NSDate *)currentSelectedDate{
    return self.selectedDate;
}

- (void)updateSubviews:(BOOL)animated{
    [self.monthIndicator setDate:self.date];
    NSInteger numOfRows = [self numOfWeek];
    NSMutableArray *dateArrayTmp = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger firstWeekday = 0;
    if(self.calendarType == CalendarTypeMonth){
        firstWeekday = [self.date firstWeekDayInMonth];
    }
    else{
        firstWeekday = [self.date weekday];
    }
    NSDate *beginDate;
    if(self.calendarType == CalendarTypeMonth){
        beginDate = [self.date firstDayOfCurrentMonth];
    }
    else{
        beginDate = self.date;
    }
    for (NSInteger i = 0; i < numOfRows * 7; i++)
    {
        NSInteger offset = (i - firstWeekday + 1) * 3600 * 24;
        NSDate *date  = [NSDate dateWithTimeInterval:offset sinceDate:beginDate];
        [dateArrayTmp addObject:date];
    }
    self.dateArray = dateArrayTmp;
    
    [_collectionView reloadData];
    NSInteger itemHeight = kCalendarItemHeight;
    NSInteger collectionHeight = [self numOfWeek] * itemHeight;
    NSInteger height = self.weekdayHeader.bottom + collectionHeight + 10;
    void (^heightChange)() = ^{
        [_collectionView setHeight:collectionHeight];
        [self setHeight:height];
        if([self.delegate respondsToSelector:@selector(calendarHeightWillChange:)]){
            [self.delegate calendarHeightWillChange:height];
        }
    };
    if(animated){
        [UIView animateWithDuration:0.3 animations:^{
            heightChange();
        }];
    }
    else{
        heightChange();
    }
}


- (void)setDate:(NSDate *)date{
    _date = date;
    [self updateSubviews:YES];
}

- (void)setHighlightedDate:(NSArray *)highlightedDate{
    _highlightedDate = highlightedDate;
    [self.collectionView reloadData];
}

- (void)setCalendarType:(CalendarType)calendarType{
    _calendarType = calendarType;
    [self updateSubviews:YES];
}

- (void)setUnreadDays:(NSArray *)unreadDays{
    _unreadDays = unreadDays;
    [self.collectionView reloadData];
}

- (NSInteger)numOfWeek{
    if(self.calendarType == CalendarTypeWeek){
        return 1;
    }
    else{
        return [self.date numberOfWeeksInCurrentMonth];
    }
}

- (CalendarMonthIndicator *)monthIndicator{
    if(_monthIndicator == nil){
        _monthIndicator = [[CalendarMonthIndicator alloc] initWithFrame:CGRectZero];
        [_monthIndicator setOrigin:CGPointMake((self.width - _monthIndicator.width) / 2, 0)];
        [_monthIndicator setDelegate:self];
    }
    return _monthIndicator;
}

- (UIView *)weekdayHeader{
    if(_weekdayHeader == nil){
        static NSString *weekdayArray[] = {@"日", @"一", @"二", @"三", @"四", @"五", @"六"};
        _weekdayHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 24)];
        NSInteger hMargin = 10;
        CGFloat itemWidth = (self.width - 10 * 2) / 7;
        for (NSInteger i = 0; i < 7; i++) {
            UILabel* weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(hMargin + itemWidth * i, 0, itemWidth, _weekdayHeader.height)];
            [weekdayLabel setTextAlignment:NSTextAlignmentCenter];
            [weekdayLabel setFont:[UIFont systemFontOfSize:13]];
            [weekdayLabel setTextColor:(i >= 1 && i <= 5) ? [UIColor colorWithHexString:@"333333"] : [UIColor colorWithHexString:@"F0003A"]];
            [weekdayLabel setText:weekdayArray[i]];
            [_weekdayHeader addSubview:weekdayLabel];
        }
    }
    return _weekdayHeader;
}

- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        NSInteger hMargin = 10;
        NSInteger itemWidth = (self.width - hMargin * 2) / 7;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [layout setMinimumLineSpacing:0];
        [layout setMinimumInteritemSpacing:0];
        [layout setItemSize:CGSizeMake(itemWidth, kCalendarItemHeight)];
        [layout setSectionInset:UIEdgeInsetsMake(0, hMargin, 0, hMargin)];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.weekdayHeader.bottom, self.width, 0) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[CalendarDayView class] forCellWithReuseIdentifier:@"CalendarDayView"];
    }
    return _collectionView;
}

#pragma mark - CalendarMonthDelegate
- (void)calendarNext{
    if(self.calendarType == CalendarTypeMonth){
        NSDate *date = [self.date offsetMonth:1];
        self.date = date;
    }
    else{
        NSDate *date = [self.date offsetDay:7];
//        NSInteger weekday = [date weekday];
//        self.selectedDate = [date dateByAddingDays:(0 - weekday + 1)];
        self.date = date;
    }

}

- (void)calendarPre{
    if(self.calendarType == CalendarTypeMonth){
        NSDate *date = [self.date offsetMonth:-1];
//        self.selectedDate = [date firstDayOfCurrentMonth];
        self.date = date;
    }
    else{
        NSDate *date = [self.date offsetDay:-7];
//        NSInteger weekday = [date weekday];
//        self.selectedDate = [date dateByAddingDays:(0 - weekday + 1)];
        self.date = date;
    }
}

- (BOOL)hasNewForDate:(NSDate *)date{
    if([self.unreadDays count] > 0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        for (NSString *dayStr in self.unreadDays) {
            if([dateStr isEqualToString:dayStr]){
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.calendarType == CalendarTypeWeek){
        return 7;
    }
    else{
        NSInteger weekNum = [self.date numberOfWeeksInCurrentMonth];
        return weekNum * 7;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CalendarDayView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarDayView" forIndexPath:indexPath];
    NSDate *date = self.dateArray[indexPath.row];
    [cell setDate:date];
    [cell setIsChosen:date.month == self.selectedDate.month && date.day == self.selectedDate.day && date.year == self.selectedDate.year];
    [cell setIsCurMonth:date.year == self.date.year && date.month == self.date.month];
    [cell setHasNew:[self hasNewForDate:date]];
    NSString* dateString = [date stringWithFormat:@"yyyy-MM-dd"];
    BOOL isIn = NO;
    for (NSString* leaveString in self.highlightedDate) {
        if([dateString isEqualToString:leaveString]){
            isIn = YES;
        }
    }
    [cell setHighlightedRed:isIn];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDate *selectDate = self.dateArray[indexPath.row];
    if(!(selectDate.month == self.selectedDate.month && selectDate.year == self.selectedDate.year && selectDate.day == self.selectedDate.day)){
        if(selectDate.month == self.date.month){
            self.selectedDate = selectDate;
            [self.collectionView reloadData];
        }
        else{
            self.selectedDate = selectDate;
            [self setDate:selectDate];
        }
        if([self.delegate respondsToSelector:@selector(calendarDateDidChange:)]){
            [self.delegate calendarDateDidChange:self.selectedDate];
        }
    }
}

@end

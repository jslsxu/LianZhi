//
//  Calendar.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "Calendar.h"
#import "NSDate+convenience.h"
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
        
        _curDateIndicator = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 5, 5)];
        [_curDateIndicator.layer setCornerRadius:_curDateIndicator.width / 2];
        [_curDateIndicator.layer setBorderWidth:2];
        [_curDateIndicator.layer setBorderColor:kCommonParentTintColor.CGColor];
        [_curDateIndicator.layer setMasksToBounds:YES];
        [_curDateIndicator setHidden:YES];
        [self addSubview:_curDateIndicator];
    }
    return self;
}

- (void)setDate:(NSDate *)date{
    _date = date;
    [_dayLabel setText:kStringFromValue(date.day)];
}

- (void)setIsChosen:(BOOL)isChosen{
    _isChosen = isChosen;
    [_curDateIndicator setHidden:!_isChosen];
}

- (void)setIsCurMonth:(BOOL)isCurMonth{
    _isCurMonth = isCurMonth;
    [_dayLabel setTextColor:_isCurMonth ? [UIColor colorWithHexString:@"222222"] : [UIColor colorWithHexString:@"cccccc"]];
}

@end

@interface Calendar ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)NSMutableArray*    dateArray;
@property (nonatomic, strong)UIView*            weekdayHeader;
@property (nonatomic, strong)UICollectionView*  collectionView;
@property (nonatomic, strong)NSDate*            selectedDate;
@end

@implementation Calendar

- (instancetype)initWithDate:(NSDate *)date{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    if(self){
        _date = date;
        _selectedDate = date;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.weekdayHeader];
        [self addSubview:self.collectionView];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - kLineHeight, self.width, kLineHeight)];
        [sepLine setBackgroundColor:kSepLineColor];
        [sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        [self addSubview:sepLine];
        
        [self updateSubviews];
        
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
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeGestureLeft];
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipeGestureRight];
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
    else if(direction == UISwipeGestureRecognizerDirectionLeft){
        if(self.calendarType == CalendarTypeMonth){
            NSDate *date = [self.date offsetMonth:1];
            self.selectedDate = [date firstDayOfCurrentMonth];
            self.date = date;
        }
        else{
            NSDate *date = [self.date offsetDay:7];
            NSInteger weekday = [date weekday];
            self.selectedDate = [date dateByAddingDays:(0 - weekday + 1)];
            self.date = date;
        }
    }
    else if(direction == UISwipeGestureRecognizerDirectionRight){
        if(self.calendarType == CalendarTypeMonth){
            NSDate *date = [self.date offsetMonth:-1];
            self.selectedDate = [date firstDayOfCurrentMonth];
            self.date = date;
        }
        else{
            NSDate *date = [self.date offsetDay:-7];
            NSInteger weekday = [date weekday];
            self.selectedDate = [date dateByAddingDays:(0 - weekday + 1)];
            self.date = date;
        }
    }
}

- (NSDate *)currentSelectedDate{
    return self.selectedDate;
}

- (void)updateSubviews{
    NSInteger numOfRows = [self numOfWeek];
    NSMutableArray *dateArrayTmp = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger firstWeekday = 0;
    if(self.calendarType == CalendarTypeMonth){
        firstWeekday = [self.selectedDate firstWeekDayInMonth];
    }
    else{
        firstWeekday = [self.selectedDate weekday];
    }
    NSDate *beginDate;
    if(self.calendarType == CalendarTypeMonth){
        beginDate = [self.selectedDate firstDayOfCurrentMonth];
    }
    else{
        beginDate = self.selectedDate;
    }
    for (NSInteger i = 0; i < numOfRows * 7; i++)
    {
        NSInteger offset = (i - firstWeekday + 1) * 3600 * 24;
        NSDate *date  = [NSDate dateWithTimeInterval:offset sinceDate:beginDate];
        [dateArrayTmp addObject:date];
    }
    self.dateArray = dateArrayTmp;
    
    [_collectionView reloadData];
    NSInteger hMargin = 10;
    NSInteger itemWidth = (self.width - hMargin * 2) / 7;
    NSInteger collectionHeight = [self numOfWeek] * itemWidth;
    NSInteger height = self.weekdayHeader.height + collectionHeight;
    [UIView animateWithDuration:0.3 animations:^{
        [_collectionView setHeight:collectionHeight];
        [self setHeight:height];
    }];
    if([self.delegate respondsToSelector:@selector(calendarHeightWillChange:)]){
        [self.delegate calendarHeightWillChange:height];
    }
}

- (void)setDate:(NSDate *)date{
    _date = date;
    [self updateSubviews];
}

- (void)setCalendarType:(CalendarType)calendarType{
    _calendarType = calendarType;
    [self updateSubviews];
}

- (NSInteger)numOfWeek{
    if(self.calendarType == CalendarTypeWeek){
        return 1;
    }
    else{
        return [self.date numberOfWeeksInCurrentMonth];
    }
}

- (UIView *)weekdayHeader{
    if(_weekdayHeader == nil){
        static NSString *weekdayArray[] = {@"日", @"一", @"二", @"三", @"四", @"五", @"六"};
        _weekdayHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 28)];
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
        [layout setItemSize:CGSizeMake(itemWidth, itemWidth)];
        [layout setSectionInset:UIEdgeInsetsMake(0, hMargin, 0, hMargin)];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.weekdayHeader.height, self.width, 0) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[CalendarDayView class] forCellWithReuseIdentifier:@"CalendarDayView"];
    }
    return _collectionView;
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
    [cell setIsChosen:date.month == self.selectedDate.month && date.day == self.selectedDate.day];
    if(self.calendarType == CalendarTypeMonth){
        [cell setIsCurMonth:date.month == self.date.month];
    }
    else{
        [cell setIsCurMonth:YES];
    }
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

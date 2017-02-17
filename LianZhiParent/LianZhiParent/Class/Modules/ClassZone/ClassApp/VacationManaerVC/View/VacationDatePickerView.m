//
//  DatePickerVC.m
//  RentCar
//
//  Created by jslsxu on 15/3/18.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "VacationDatePickerView.h"
#import "STPickerView.h"
@interface VacationDatePickerView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSDate *startDate;
@property (nonatomic, strong)UITableView* dateTableView;
@property (nonatomic, strong)UITableView* timeTableView;
@property (nonatomic, assign)NSInteger dateIndex;
@property (nonatomic, assign)NSInteger timeIndex;
@end

@implementation VacationDatePickerView

- (instancetype)initWithFrame:(CGRect)frame andDate:(NSDate *)date minimumDate:(NSDate *)minDate
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSString* format = @"yyyy-MM-dd";
        NSString* startDateString = [minDate stringWithFormat:format];
        self.startDate = [NSDate dateWithString:startDateString format:format];
        NSString* dateString = [date stringWithFormat:format];
        self.timeIndex = date.hour - 7;
        NSDate* formatStartDate = [NSDate dateWithString:startDateString format:format];
        for (NSInteger i = 0; i < 31; i++) {
            NSDate *curDate = [formatStartDate dateByAddingDays:i];
            NSString* string = [curDate stringWithFormat:format];
            if([string isEqualToString:dateString]){
                self.dateIndex = i;
                break;
            }
        }
        
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backgroundButton setFrame:self.bounds];
        [_backgroundButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [_backgroundButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backgroundButton];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        [_contentView setBackgroundColor:[UIColor colorWithHexString:@"dddddd"]];
        [self setupContentView:_contentView];
        [self addSubview:_contentView];
        
    }
    return self;
}

- (void)setupContentView:(UIView *)viewParent
{
    CGFloat margin = 5;
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton addTarget:self action:@selector(onConfirmClicked) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"2790D4"] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [viewParent addSubview:confirmButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:self action:@selector(onCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"2790D4"] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [viewParent addSubview:cancelButton];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewParent.width, 0.5)];
    [sepLine setBackgroundColor:[UIColor colorWithHexString:@"E0E0E0"]];
    [viewParent addSubview:sepLine];
    
    UIView* selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 50 + 60, viewParent.width, 30)];
    [selectionView setBackgroundColor:kColor_99];
    [viewParent addSubview:selectionView];
    
    self.dateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, viewParent.width * 2 / 3 - 20, 150) style:UITableViewStylePlain];
    [self.dateTableView setShowsVerticalScrollIndicator:NO];
    [self.dateTableView setBackgroundColor:[UIColor clearColor]];
    [self.dateTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.dateTableView setDelegate:self];
    [self.dateTableView setDataSource:self];
    [self.dateTableView setContentInset:UIEdgeInsetsMake(60, 0, 60, 0)];
    [viewParent addSubview:self.dateTableView];
    
    [self.dateTableView scrollToRow:self.dateIndex inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    self.timeTableView = [[UITableView alloc] initWithFrame:CGRectMake(viewParent.width * 2 / 3+ 20, 50, viewParent.width / 3 - 20, 150) style:UITableViewStylePlain];
    [self.timeTableView setShowsVerticalScrollIndicator:NO];
    [self.timeTableView setBackgroundColor:[UIColor clearColor]];
    [self.timeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.timeTableView setDelegate:self];
    [self.timeTableView setDataSource:self];
    [self.timeTableView setContentInset:UIEdgeInsetsMake(60, 0, 60, 0)];
    [viewParent addSubview:self.timeTableView];
    
    
    [self.timeTableView scrollToRow:self.timeIndex inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    [viewParent setHeight:210];
    [cancelButton setFrame:CGRectMake(margin, margin, 50, 30)];
    [confirmButton setFrame:CGRectMake(viewParent.width - margin - 50,margin, 50, 30)];
}

- (void)show
{
    [_backgroundButton setAlpha:0.f];
    [_contentView setY:self.height];
    [[UIApplication sharedApplication].windows[0] addSubview:self];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_contentView setY:self.height - _contentView.height];
        [_backgroundButton setAlpha:1.f];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)dismiss
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.3f animations:^{
        [_contentView setY:self.height];
        [_backgroundButton setAlpha:0.f];
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self removeFromSuperview];
    }];
}

- (void)onCancelClicked
{
    [self dismiss];
}

- (void)onConfirmClicked
{
    NSDate* selectedDate = [self.startDate dateByAddingDays:self.dateIndex];
    selectedDate = [selectedDate dateByAddingHours:7 + self.timeIndex];
    if(self.callBack){
        self.callBack(selectedDate);
    }
    [self dismiss];
}

- (void)handleScrollView:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y + 60;
    NSInteger row = (offsetY + 15) / 30;
    row = MAX(0, row);
    UITableView* tableView = (UITableView *)scrollView;
    if(tableView == self.dateTableView){
        row = MIN(30, row);
        self.dateIndex = row;
    }
    else {
        row = MIN(14, row);
        self.timeIndex = row;
    }
    [tableView scrollToRow:row inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.dateTableView){
        return 31;
    }
    else{
        return 15;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = nil;
    NSString* reuseID = nil;
    if(tableView == self.dateTableView){
        reuseID = @"DateCell";
    }
    else{
        reuseID = @"TimeCell";
    }
    cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        if(tableView == self.dateTableView){
            [cell.textLabel setTextAlignment:NSTextAlignmentRight];
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        [cell.textLabel setTextColor:kColor_66];
    }
    NSInteger row = indexPath.row;
    if(tableView == self.dateTableView){
        NSDate *date = [self.startDate dateByAddingDays:row];
        [cell.textLabel setText:[date stringWithFormat:@"yyyy年  MM月  dd日"]];
    }
    else{
        NSString *time = [NSString stringWithFormat:@"%zd:00", 7 + row];
        [cell.textLabel setText:time];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    if(tableView == self.dateTableView){
        self.dateIndex = indexPath.row;
    }
    else{
        self.timeIndex = indexPath.row;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self handleScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self handleScrollView:scrollView];
}
@end

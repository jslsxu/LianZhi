//
//  CalanderView.m
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "CalanderView.h"
#import "NSDate+convenience.h"
#define kCalanderHMargin            10
#define kCalanderVMargin            5

@interface CalanderViewCell()
@property (nonatomic, strong)UILabel*   dateLabel;
@end

@implementation CalanderViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:14]];
        [_dateLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [self addSubview:_dateLabel];
    }
    return self;
}

- (void)setDate:(NSDate *)date{
    _date = date;
    [_dateLabel setText:[NSString stringWithFormat:@"%zd",[_date day]]];
}

@end

@interface CalanderView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UIView*    headerView;
@property (nonatomic, strong)UICollectionView*  collectionView;
@end

@implementation CalanderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:[self headerView]];
        [self addSubview:[self collectionView]];
    }
    return self;
}

- (void)setCalanderStyle:(CalanderViewStyle)calanderStyle{
    _calanderStyle = calanderStyle;
    
}

- (void)setSelectedDate:(NSDate *)selectedDate{
    _selectedDate = selectedDate;
}

- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(kCalanderHMargin, kCalanderVMargin, self.width - kCalanderHMargin, 35)];
        NSInteger itemWidth = _headerView.width / 7;
        NSArray *weekdayArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        for (NSInteger i = 0; i < 7; i++) {
            UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, _headerView.height)];
            [weekdayLabel setTextAlignment:NSTextAlignmentCenter];
            [weekdayLabel setFont:[UIFont systemFontOfSize:14]];
            [weekdayLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
            [weekdayLabel setText:weekdayArray[i]];
            [_headerView addSubview:weekdayLabel];
        }
    }
    return _headerView;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        NSInteger itemWidth = (self.width - kCalanderHMargin * 2) / 7;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置item的宽高
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        //设置行间距
        layout.minimumLineSpacing = 0.0f;
        //每列的最小间距
        layout.minimumInteritemSpacing = 0.0f;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kCalanderHMargin, [self headerView].bottom, self.width - kCalanderHMargin * 2, itemWidth) collectionViewLayout:layout];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setScrollEnabled:NO];
        [_collectionView registerClass:[CalanderViewCell class] forCellWithReuseIdentifier:@"CalanderViewCell"];
    }
    return _collectionView;
}

- (NSInteger)numOfRows
{
    return  ([self.curMonth numDaysInMonth] + ([self.curMonth firstWeekDayInMonth] - 1) + 6) / 7;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(self.calanderStyle == CalanderViewStyleWeek){
        return 7;
    }
    else{
        return [self numOfRows] * 7;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    CalanderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalanderViewCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CalanderViewCell *cell = (CalanderViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSDate *date = [cell date];
    if(self.calanderDateCallback){
        self.calanderDateCallback(date);
    }
}

@end

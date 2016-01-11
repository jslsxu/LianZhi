//
//  MyAttendanceCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MyAttendanceCell.h"
#import "MyAttendanceItem.h"


@implementation MyAttendanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _verLine = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 1, 45)];
        [_verLine setBackgroundColor:[UIColor colorWithHexString:@"d7d7d7"]];
        [self addSubview:_verLine];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, (45 - 14) / 2, 36, 14)];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel.layer setCornerRadius:7];
        [_dateLabel.layer setMasksToBounds:YES];
        [_dateLabel setTextColor:[UIColor whiteColor]];
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        [_dateLabel setBackgroundColor:[UIColor colorWithHexString:@"5ed016"]];
        [self addSubview:_dateLabel];
        
        _startlabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 45)];
        [_startlabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_startlabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_startlabel];
        
        _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(_startlabel.right, 0, 100, 45)];
        [_endLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_endLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_endLabel];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    MyAttendanceItem *attendanceItem = (MyAttendanceItem *)modelItem;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:attendanceItem.timeStamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd日"];
    NSString *day = [formatter stringFromDate:date];
    [_dateLabel setText:day];
    [_startlabel setText:[NSString stringWithFormat:@"%@ %@",attendanceItem.startRegion, attendanceItem.startTime]];
    [_endLabel setText:[NSString stringWithFormat:@"%@ %@",attendanceItem.endRegion, attendanceItem.endTime]];
}

- (void)setIsDark:(BOOL)isDark
{
    _isDark = isDark;
    [self setBackgroundColor:_isDark ? [UIColor colorWithHexString:@"ebebeb"] : [UIColor whiteColor]];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(45);
}

@end

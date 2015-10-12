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
        _verLine = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 1, self.height)];
        [_verLine setBackgroundColor:[UIColor colorWithHexString:@"d7d7d7"]];
        [self addSubview:_verLine];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, (self.height - 14) / 2, 36, 14)];
        [_dateLabel setTextColor:[UIColor whiteColor]];
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        [_dateLabel setBackgroundColor:[UIColor colorWithHexString:@"5ed016"]];
        [self addSubview:_dateLabel];
        
        _startlabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 90, self.height)];
        [_startlabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_startlabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_startlabel];
        
        _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(_startlabel.right, 0, 90, self.height)];
        [_endLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_endLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_endLabel];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    MyAttendanceItem *attendanceItem = (MyAttendanceItem *)modelItem;
    
}

- (void)setIsDark:(BOOL)isDark
{
    _isDark = isDark;
    [self setBackgroundColor:_isDark ? [UIColor colorWithHexString:@"ebebeb"] : [UIColor whiteColor]];
}

@end

//
//  StudentAttendanceCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StudentAttendanceCell.h"

NSString *const kStudentAttendanceStatusChanged = @"StudentAttendanceStatusChanged";

@implementation StudentAttendanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.width = kScreenWidth;
        NSInteger itemWidth = self.width / 4;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 50)];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
        [_sepLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [self addSubview:_sepLine];
        
        for (NSInteger i = 0; i < 3; i++)
        {
            UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * (i + 1), 0, 0.5, 50)];
            [sepLine setBackgroundColor:[UIColor colorWithHexString:@"e0e0e0"]];
            [self addSubview:sepLine];
        }
        
        _statusArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(itemWidth * (i + 1), 0, itemWidth, 50)];
            [button addTarget:self action:@selector(onStatusClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [_statusArray addObject:button];
        }
    }
    return self;
}

- (void)onStatusClicked:(UIButton *)button
{
    NSInteger index = [_statusArray indexOfObject:button];
    StudentAttendanceItem *attendanceItem = (StudentAttendanceItem *)self.modelItem;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:attendanceItem.studentID forKey:@"child_id"];
    [params setValue:kStringFromValue(LeaveTypeNormal - index) forKey:@"status"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kStudentAttendanceStatusChanged object:nil userInfo:params];
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    StudentAttendanceItem *attendanceItem = (StudentAttendanceItem *)modelItem;
    LeaveType leaveType = attendanceItem.leaveType;
    [_nameLabel setText:attendanceItem.studentName];
    for (NSInteger i = 0; i < _statusArray.count ; i++)
    {
        UIButton *button = _statusArray[i];
        if(leaveType == LeaveTypeNormal - i)
        {
            [button setImage:[UIImage imageNamed:@"StudentAttendanceCheck"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"StudentAttendanceCheck"] forState:UIControlStateHighlighted];
        }
        else
        {
            [button setImage:nil forState:UIControlStateNormal];
            [button setImage:nil forState:UIControlStateHighlighted];
        }
    }
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(50);
}

@end

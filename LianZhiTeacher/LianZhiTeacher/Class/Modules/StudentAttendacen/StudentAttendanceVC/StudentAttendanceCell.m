//
//  StudentAttendanceCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StudentAttendanceCell.h"

@implementation StudentAttendanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
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
        
        _statusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [self addSubview:_statusImageView];
        
        for (NSInteger i = 0; i < 3; i++)
        {
            UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * (i + 1), 0, 0.5, 50)];
            [sepLine setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
            [self addSubview:sepLine];
        }
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    StudentAttendanceItem *attendanceItem = (StudentAttendanceItem *)modelItem;
    
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(50);
}

@end

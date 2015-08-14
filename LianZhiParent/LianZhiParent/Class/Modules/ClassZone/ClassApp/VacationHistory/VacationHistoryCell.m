//
//  VacationHistoryCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "VacationHistoryCell.h"

@implementation VacationHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self addSubview:_avatar];
        
        _redDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RedDot.png"]];
        [self addSubview:_redDot];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_nameLabel];
        
        _vacationTypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_vacationTypeLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_vacationTypeLabel];
        
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_durationLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_durationLabel];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_stateLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_stateLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_timeLabel];
    }
    return self;
}

@end

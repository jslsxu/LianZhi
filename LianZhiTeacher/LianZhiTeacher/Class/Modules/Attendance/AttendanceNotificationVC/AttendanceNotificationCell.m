//
//  AttendanceNotificationCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "AttendanceNotificationCell.h"
#import "AttendanceNotificationItem.h"
#define kContentFont            [UIFont systemFontOfSize:14]

#define kBGTopMargin            12
#define kOperationHeight        32
#define kBGViewHMargin          10
#define kContentHMargin         10
#define kInnerMargin            8
#define kExtraInfoHeight        48
@implementation AttendanceNotificationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(kBGViewHMargin, kBGTopMargin, self.width - kBGViewHMargin * 2, 0)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:10];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
        [_bgView addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 25, 100, kOperationHeight)];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_bgView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_bgView addSubview:_timeLabel];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setFrame:CGRectMake(_bgView.width - 50, 0, 50, 50)];
        [_deleteButton setImage:[UIImage imageNamed:@"MessageDetailTrash"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(onMessageDeleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_deleteButton];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentHMargin, 0, _bgView.width - kContentHMargin * 2, 0)];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:kContentFont];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_bgView addSubview:_contentLabel];
        
        _extraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, kExtraInfoHeight)];
        [_bgView addSubview:_extraView];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [_extraView addSubview:_sepLine];
        
        _attendanceTimeLabel = [[UILabel alloc] initWithFrame:CGRectInset(_extraView.bounds, kContentHMargin, 0)];
        [_attendanceTimeLabel setTextColor:kCommonTeacherTintColor];
        [_attendanceTimeLabel setFont:kContentFont];
        [_extraView addSubview:_attendanceTimeLabel];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    AttendanceNotificationItem *item = (AttendanceNotificationItem *)modelItem;
    if(item.is_new){
        [_bgView setBackgroundColor:[UIColor colorWithHexString:@"f4f9fa"]];
    }
    else{
        [_bgView setBackgroundColor:[UIColor whiteColor]];
    }
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:item.words.child_info.avatar]];
    [_nameLabel setText:item.words.child_info.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, _avatarView.centerY - 3 - _nameLabel.height)];
    [_timeLabel setText:item.time];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_avatarView.right + 10, _avatarView.centerY + 3 )];
    CGFloat height = _avatarView.bottom + 15;
    NSString *content = item.words.index_words;
    [_contentLabel setWidth:_bgView.width - kContentHMargin * 2];
    if(content.length > 0){
        [_contentLabel setHidden:NO];
        [_contentLabel setText:content];
        [_contentLabel sizeToFit];
        [_contentLabel setY:height];
        height += _contentLabel.height + 10;
    }
    else{
        [_contentLabel setHidden:YES];
    }
    
    [_extraView setHidden:NO];
    [_extraView setY:height];
    
    [_attendanceTimeLabel setText:[NSString stringWithFormat:@"请假时间:%@ - %@",item.words.from_date, item.words.to_date]];
    
    height += kExtraInfoHeight;
    [_bgView setHeight:height];
    
}

- (void)onMessageDeleteButtonClicked
{
    if(self.deleteCallback){
        self.deleteCallback();
    }
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    AttendanceNotificationItem *item = (AttendanceNotificationItem *)modelItem;
    NSInteger height = kBGTopMargin + 10 + 46 + 15;
    NSString *content = item.words.index_words;
    if(content.length > 0){
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentHMargin, 0, width - kBGViewHMargin * 2 - kContentHMargin * 2, 0)];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [contentLabel setNumberOfLines:0];
        [contentLabel setFont:kContentFont];
        [contentLabel setText:content];
        [contentLabel sizeToFit];

        height += contentLabel.height + 10;
    }
    height += kExtraInfoHeight;
    
    return @(height);
}

@end

//
//  GrowthTimelineCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelineCell.h"

@implementation GrowthTimelineCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _statusArray = [NSMutableArray array];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.width = kScreenWidth;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, self.width - 15 * 2, 0)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:10];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(35, 8, _bgView.width - 8 - 35, 80)];
        [_statusView setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
        [_statusView.layer setCornerRadius:10];
        [_statusView.layer setMasksToBounds:YES];
        [_bgView addSubview:_statusView];
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, 3, 50, 50)];
        [_bgView addSubview:_avatarView];
        
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, _statusView.width - 35 - 10, 30)];
        [_nickNameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nickNameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_statusView addSubview:_nickNameLabel];
        
        NSArray *imageArray = @[@"Mood",@"Toilet",@"Temperature",@"Drink",@"Sleep"];
        NSInteger itemWidth = 38;
        NSInteger spaceXStart = 30;
        NSInteger spaceYStart = 30;
        NSInteger innerMargin = (_statusView.width - spaceXStart - 10 - itemWidth * 5) / 4;
        for (NSInteger i = 0; i < 5; i++)
        {
            UIButton *statusButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            [statusButton setFrame:CGRectMake(spaceXStart + (itemWidth + innerMargin) * i, spaceYStart, itemWidth, itemWidth)];
            [statusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Normal",imageArray[i]]] forState:UIControlStateNormal];
            [statusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Abnormal",imageArray[i]]] forState:UIControlStateSelected];
            [_statusView addSubview:statusButton];
            [_statusArray addObject:statusButton];
        }
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(35, _statusView.bottom + 8, _statusView.width, 0)];
        [_contentView setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
        [_contentView.layer setCornerRadius:10];
        [_contentView.layer setMasksToBounds:YES];
        [_bgView addSubview:_contentView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, _contentView.width - 5 * 2, 0)];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentView addSubview:_contentLabel];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    GrowthTimelineItem *timelineItem = (GrowthTimelineItem *)modelItem;
    StudentInfo *userInfo = timelineItem.student;
    [_avatarView setImageWithUrl:[NSURL URLWithString:userInfo.avatar]];
    [_nickNameLabel setText:userInfo.name];
    
    for (NSInteger i = 0; i < 5; i++)
    {
        UIButton *button = _statusArray[i];
        if(i== 0)
            [button setSelected:timelineItem.emotion];
        if(i == 1)
            [button setSelected:timelineItem.stool];
        if(i == 2)
            [button setSelected:timelineItem.temparature];
        if(i == 3)
            [button setSelected:timelineItem.water];
        if(i == 4)
            [button setSelected:timelineItem.sleep];
    }
    
    NSString *content = timelineItem.content;
    if(content.length > 0)
    {
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 15 * 2 - 35 - 8 - 5 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setText:content];
        [_contentLabel setSize:contentSize];
        [_contentView setHeight:contentSize.height + 10 * 2];
        [_bgView setHeight:96 + contentSize.height + 10 * 2 + 8];
    }
    else
    {
        _contentView.height = 0;
        _contentLabel.height = 0;
        [_bgView setHeight:96 ];
    }
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    GrowthTimelineItem *item = (GrowthTimelineItem *)modelItem;
    NSString *content = item.content;
    NSInteger contentHeight = 0;
    if([content length] > 0)
    {
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(width - 15 * 2 - 35 - 8 - 5 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        contentHeight = contentSize.height;
        return @(96 + contentHeight + 10 * 2 + 8 + 10);
    }
    return @(96 + 10);
}
@end

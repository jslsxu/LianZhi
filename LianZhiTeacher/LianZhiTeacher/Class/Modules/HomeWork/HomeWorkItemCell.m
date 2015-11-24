//
//  HomeWorkItemCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkItemCell.h"

@implementation HomeWorkItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setFont:[UIFont systemFontOfSize:12]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
        
        _photoView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_photoView setClipsToBounds:YES];
        [_photoView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_photoView];
        
        _voiceButton = [MessageVoiceButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_voiceButton];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setFont:[UIFont systemFontOfSize:9]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"cccccc"]];
        [self addSubview:_timeLabel];
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, kLineHeight)];
        [_bottomLine setBackgroundColor:kSepLineColor];
        [self addSubview:_bottomLine];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton addTarget:self action:@selector(onDeleteClicked) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setHidden:YES];
        [_deleteButton setImage:[UIImage imageNamed:@"HomeWorkPhotoDel"] forState:UIControlStateNormal];
        [self addSubview:_deleteButton];

    }
    return self;
}

- (void)setHomeWorkItem:(HomeWorkItem *)homeWorkItem
{
    NSInteger height = 15;
    _homeWorkItem = homeWorkItem;
    if(_homeWorkItem.content.length > 0)
    {
        [_contentLabel setHidden:NO];
        CGSize contentSize = [homeWorkItem.content boundingRectWithSize:CGSizeMake(self.width - 16 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
        [_contentLabel setText:_homeWorkItem.content];
        [_contentLabel setFrame:CGRectMake(16, 15, contentSize.width, contentSize.height)];
        height += contentSize.height + 10;
    }
    else
    {
        [_contentLabel setHidden:YES];
    }
    [_photoView setHidden:YES];
    [_voiceButton setHidden:YES];
    [_timeLabel setHidden:YES];
    if(_homeWorkItem.image)
    {
        [_photoView setHidden:NO];
        [_photoView setFrame:CGRectMake(16, height, self.width - 16 * 2, 100)];
        [_photoView setImage:_homeWorkItem.image];
        height += 100 + 10;
    }
    else if(homeWorkItem.audioData && homeWorkItem.timeSpan > 0)
    {
        [_voiceButton setHidden:NO];
        [_timeLabel setHidden:NO];
        [_voiceButton setFrame:CGRectMake(16, height, 200, 34)];
        height += 34 + 10;
    }
    height += 5;
    [_bottomLine setFrame:CGRectMake(0, height - kLineHeight, self.width, kLineHeight)];
    [_deleteButton setFrame:CGRectMake(self.width - 40, 0, 40, 40)];
}

+ (CGFloat)cellHeightForItem:(HomeWorkItem *)homeWorkItem forWidth:(NSInteger)width
{
    NSInteger height = 15;
    if(homeWorkItem.content.length > 0)
    {
        CGSize contentSize = [homeWorkItem.content boundingRectWithSize:CGSizeMake(width - 16 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
        height += contentSize.height + 10;
    }
    
    if(homeWorkItem.image)
        height += 100 + 10;
    else if(homeWorkItem.audioData && homeWorkItem.timeSpan > 0)
        height += 34 + 10;
    height += 5;
    return height;
}

- (void)onVoiceButtonClicked
{
    
}

- (void)onDeleteClicked
{
    if([self.delegate respondsToSelector:@selector(homeWorkCellDidDelete:)])
        [self.delegate homeWorkCellDidDelete:self];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCurSelected:(BOOL)curSelected
{
    _curSelected = curSelected;
    [_deleteButton setHidden:!_curSelected];
    if(_curSelected)
    {
        UIView *bgView = [[UIView alloc] init];
        [bgView setBackgroundColor:[UIColor colorWithHexString:@"d8d8d8"]];
        [self setSelectedBackgroundView:bgView];
    }
    else
        [self setSelectedBackgroundView:nil];
}

@end

//
//  HomeWorkCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkCell.h"
#import "HomeWorkListModel.h"
@implementation HomeWorkCell
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

    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    HomeWorkItem *homeWorkItem = (HomeWorkItem *)modelItem;
    NSInteger height = 15;
    if(homeWorkItem.content.length > 0)
    {
        [_contentLabel setHidden:NO];
        CGSize contentSize = [homeWorkItem.content boundingRectWithSize:CGSizeMake(self.width - 16 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
        [_contentLabel setText:homeWorkItem.content];
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
    if(homeWorkItem.photoItem)
    {
        [_photoView setHidden:NO];
        [_photoView setFrame:CGRectMake(16, height, self.width - 16 * 2, 100)];
        [_photoView sd_setImageWithURL:[NSURL URLWithString:homeWorkItem.photoItem.originalUrl] placeholderImage:nil];
        height += 100 + 10;
    }
    else if(homeWorkItem.audioItem)
    {
        [_voiceButton setHidden:NO];
        [_timeLabel setHidden:NO];
        [_voiceButton setFrame:CGRectMake(16, height, 200, 34)];
        height += 34 + 10;
    }
    height += 5;
    [_bottomLine setFrame:CGRectMake(0, height - kLineHeight, self.width, kLineHeight)];
    
}

- (void)onVoiceButtonClicked
{
    
}


+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    HomeWorkItem *homeWorkItem = (HomeWorkItem *)modelItem;
    NSInteger height = 15;
    if(homeWorkItem.content.length > 0)
    {
        CGSize contentSize = [homeWorkItem.content boundingRectWithSize:CGSizeMake(width - 16 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
        height += contentSize.height + 10;
    }
    
    if(homeWorkItem.photoItem)
        height += 100 + 10;
    else if(homeWorkItem.audioItem)
        height += 34 + 10;
    height += 5;
    return @(height);
}
@end

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
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _dateLabel  =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
        [_dateLabel setTextAlignment:NSTextAlignmentRight];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setFont:[UIFont systemFontOfSize:16]];
        [_dateLabel setNumberOfLines:0];
        [_dateLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_dateLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_dateLabel];
        
        _dot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TimelinePoint.png"]];
        [_dot setCenter:CGPointMake(56, _dateLabel.centerY)];
        [self addSubview:_dot];
        
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"WhiteBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [self addSubview:_bgImageView];
        
        CGFloat width = 36;
        _feeling = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, width, width)];
        [_bgImageView addSubview:_feeling];
        
        _toilet = [[UIImageView alloc] initWithFrame:CGRectMake(_feeling.right + 8, 20, width, width)];
        [_bgImageView addSubview:_toilet];
        
        _temparature = [[UIImageView alloc] initWithFrame:CGRectMake(_toilet.right + 8, 20, width, width)];
        [_bgImageView addSubview:_temparature];
        
        CGFloat labelStart = _temparature.right  +10;
        _waterLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelStart, _temparature.top, _bgImageView.width - labelStart, 15)];
        [_waterLabel setBackgroundColor:[UIColor clearColor]];
        [_bgImageView addSubview:_waterLabel];
        
        _sleepLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelStart, _temparature.bottom - 15, _bgImageView.width - labelStart, 15)];
        [_sleepLabel setBackgroundColor:[UIColor clearColor]];
        [_bgImageView addSubview:_sleepLabel];
        
        _contentBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"GrayBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView addSubview:_contentBG];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setFont:[UIFont systemFontOfSize:15]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentBG addSubview:_contentLabel];
        
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_authorLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_authorLabel setFont:[UIFont systemFontOfSize:14]];
        [_authorLabel setBackgroundColor:[UIColor clearColor]];
        [_bgImageView addSubview:_authorLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_bgImageView addSubview:_timeLabel];
        
    }
    return self;
}

- (NSString *)formatterDateStr:(NSString *)date
{
    NSString *result = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *formatterDateArray = @[@"今天",@"昨天",@"前天"];
    for (NSInteger i = 0; i < 3; i++)
    {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDateComponents *comps = nil;
        
        comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
        
        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
        
        [adcomps setYear:0];
        
        [adcomps setMonth:0];
        
        [adcomps setDay:-i];
        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
        if([date isEqualToString:[formatter stringFromDate:newdate]])
            result = formatterDateArray[i];
    }
    return result;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    GrowthTimelineItem *timelineItem = (GrowthTimelineItem *)modelItem;
    if([timelineItem.date length] > 0)
    {
        [_dateLabel setHidden:NO];
        NSString *formmaterStr = [self formatterDateStr:timelineItem.date];
        if(formmaterStr)
        {
            [_dateLabel setFont:[UIFont systemFontOfSize:14]];
            [_dateLabel setText:formmaterStr];
        }
        else
        {
            NSString *date = [timelineItem.date substringWithRange:NSMakeRange(8, 2)];
            NSInteger month = [[timelineItem.date substringWithRange:NSMakeRange(5, 2)] integerValue];
//            NSInteger year = [[timelineItem.date substringToIndex:4] integerValue];
            
            NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)month];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",date,monthStr]];
            [attrStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, 3)];
            [attrStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} range:NSMakeRange(3, attrStr.length - 3)];
            [_dateLabel setAttributedText:attrStr];

        }
        [_dateLabel sizeToFit];
        [_dateLabel setOrigin:CGPointMake(20, 6)];
    }
    else
        [_dateLabel setHidden:YES];

    
    
    [_bgImageView setFrame:CGRectMake(80, 0, self.width - 80 - 10, 100)];

    
    NSString *temp = timelineItem.temparature;
    if([temp isEqualToString:@"正常"])
        [_temparature setImage:[UIImage imageNamed:@"TempNormal.png"]];
    else if([temp isEqualToString:@"发烧"])
        [_temparature setImage:[UIImage imageNamed:@"TempHigh.png"]];
    
    NSInteger stoolNum = timelineItem.stoolNum;
    if(stoolNum == 0)
        [_toilet setImage:[UIImage imageNamed:@"ToiletNo.png"]];
    else if(stoolNum == 1)
        [_toilet setImage:[UIImage imageNamed:@"ToiletOnce.png"]];
    else if (stoolNum == 2)
        [_toilet setImage:[UIImage imageNamed:@"ToiletTwice.png"]];
    
    NSString *emotion = timelineItem.emotion;
    if([emotion isEqualToString:@"高兴"])
        [_feeling setImage:[UIImage imageNamed:@"ExpressionHappy.png"]];
    else if ([emotion isEqualToString:@"哭闹"])
        [_feeling setImage:[UIImage imageNamed:@"ExpressionCry.png"]];
    else
        [_feeling setImage:[UIImage imageNamed:@"ExpressionSimple.png"]];
    
    NSInteger water = timelineItem.water;
    CGFloat sleep = timelineItem.sleep;
    NSString *drinkStr = [NSString stringWithFormat:@"喝了%ld杯水",(long)water];
    NSString *sleepStr = [NSString stringWithFormat:@"睡了%.1fhr",sleep];
    NSMutableAttributedString *drinkAttrStr = [[NSMutableAttributedString alloc] initWithString:drinkStr];
    [drinkAttrStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]} range:NSMakeRange(0, 2)];
    [drinkAttrStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"59b6e2"]} range:NSMakeRange(2, drinkStr.length - 2)];
    NSMutableAttributedString *sleepAttrStr = [[NSMutableAttributedString alloc] initWithString:sleepStr];
    [sleepAttrStr setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, 2)];
    [sleepAttrStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"c5927d"]} range:NSMakeRange(2, sleepStr.length - 2)];
    [_waterLabel setAttributedText:drinkAttrStr];
    [_waterLabel sizeToFit];
    [_sleepLabel setAttributedText:sleepAttrStr];
    [_sleepLabel sizeToFit];
    
    [_waterLabel setOrigin:CGPointMake(_bgImageView.width - 12 - _waterLabel.width, 20)];
    [_sleepLabel setOrigin:CGPointMake(_bgImageView.width - 12 - _sleepLabel.width, _temparature.bottom - 20)];
    
    
    NSString *content = timelineItem.content;
    if([content length] > 0)
    {
        _contentBG.hidden = NO;
        _contentLabel.hidden = NO;
        [_contentLabel setText:content];
        CGSize contentSize = [_contentLabel.text boundingRectWithSize:CGSizeMake(_bgImageView.width - (12 + 10) * 2, 0) andFont:[UIFont systemFontOfSize:15]];
        [_contentBG setFrame:CGRectMake(12, _temparature.bottom + 12, _bgImageView.width - 12 * 2, contentSize.height + 24)];
        [_contentLabel setFrame:CGRectMake(10,10, contentSize.width, contentSize.height)];
    }
    else
    {
        _contentLabel.hidden = YES;
        _contentBG.hidden = YES;
        [_contentBG setFrame:CGRectMake(12, _temparature.bottom, _bgImageView.width - 12 * 2, 0)];
    }
    
    NSString *author = [NSString stringWithFormat:@"来自%@老师",timelineItem.teacherInfo.teacherName];
    [_authorLabel setText:author];
    [_authorLabel sizeToFit];
    [_authorLabel setOrigin:CGPointMake(12, _contentBG.bottom + (30 - _authorLabel.height) / 2)];
    
    [_timeLabel setText:timelineItem.formatTime];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_contentBG.right - _timeLabel.width, _contentBG.bottom + (30 - _authorLabel.height) / 2)];
    [_bgImageView setHeight:_contentBG.bottom + 30];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    GrowthTimelineItem *item = (GrowthTimelineItem *)modelItem;
    NSString *content = item.content;
    if([content length] > 0)
    {
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(width - 80 - 10 - (12 + 10) * 2, 0) andFont:[UIFont systemFontOfSize:15]];
        return @(20 + 36 + (12 + 12 + contentSize.height + 12) + 30 + 15);
    }
    else
    {
        return @(20 + 36 + 30 + 15);
    }
}
@end

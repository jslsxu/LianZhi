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
        
        _statusArray = [NSMutableArray array];
        self.width = kScreenWidth;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(65, 0, self.width - 15 - 65, 0)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:10];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _statusView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, _bgView.width - 10 * 2, 40)];
        [_bgView addSubview:_statusView];
        
        NSArray *imageArray = @[@"Mood",@"Toilet",@"Temperature",@"Drink",@"Sleep"];
        NSInteger itemWidth = 38;
        NSInteger innerMargin = (_statusView.width - itemWidth * 5) / 4;
        for (NSInteger i = 0; i < 5; i++)
        {
            UIButton *statusButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            [statusButton setFrame:CGRectMake((itemWidth + innerMargin) * i, 1, itemWidth, itemWidth)];
            [statusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Normal",imageArray[i]]] forState:UIControlStateNormal];
            [statusButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Abnormal",imageArray[i]]] forState:UIControlStateSelected];
            [_statusView addSubview:statusButton];
            [_statusArray addObject:statusButton];
        }
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, _bgView.width - 10 * 2, 0)];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel.layer setCornerRadius:10];
        [_contentLabel.layer setMasksToBounds:YES];
        [_bgView addSubview:_contentLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [_bgView addSubview:_sepLine];
        
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_authorLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_authorLabel setFont:[UIFont systemFontOfSize:14]];
        [_authorLabel setBackgroundColor:[UIColor clearColor]];
        [_bgView addSubview:_authorLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_bgView addSubview:_timeLabel];
        
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
    
    UIButton *feelingButton = _statusArray[0];
    NSString *emotion = timelineItem.emotion;
    if([emotion isEqualToString:@"高兴"])
        [feelingButton setImage:[UIImage imageNamed:(@"ExpressionHappy")] forState:UIControlStateNormal];
    else if ([emotion isEqualToString:@"哭闹"])
        [feelingButton setImage:[UIImage imageNamed:(@"ExpressionCry")] forState:UIControlStateNormal];
    else
        [feelingButton setImage:[UIImage imageNamed:(@"ExpressionSimple")] forState:UIControlStateNormal];
    
    UIButton *toiletButton = _statusArray[1];
    NSInteger stoolNum = timelineItem.stoolNum;
    if(stoolNum == 0)
        [toiletButton setImage:[UIImage imageNamed:(@"ToiletNo")] forState:UIControlStateNormal];
    else if(stoolNum == 1)
        [toiletButton setImage:[UIImage imageNamed:(@"ToiletOnce")] forState:UIControlStateNormal];
    else if (stoolNum == 2)
        [toiletButton setImage:[UIImage imageNamed:(@"ToiletTwice")] forState:UIControlStateNormal];
    
    UIButton *temparatureButton = _statusArray[2];
    NSString *temp = timelineItem.temparature;
    if([temp isEqualToString:@"正常"])
        [temparatureButton setImage:[UIImage imageNamed:(@"TempNormal.png")] forState:UIControlStateNormal];
    else if([temp isEqualToString:@"发烧"])
        [temparatureButton setImage:[UIImage imageNamed:(@"TempHigh.png")] forState:UIControlStateNormal];
    
    UIButton *waterButton = _statusArray[3];
    [waterButton setImage:[UIImage imageNamed:timelineItem.water ? @"DrinkAbnormal" : @"DrinkNormal"] forState:UIControlStateNormal];
    
    UIButton *sleepButton = _statusArray[4];
    [sleepButton setImage:[UIImage imageNamed:timelineItem.sleep ? @"SleepAbnormal" : @"SleepNormal"] forState:UIControlStateNormal];
    
    
    NSInteger spaceYStart = 60;
    NSString *content = timelineItem.content;
    if(content.length > 0)
    {
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(kScreenWidth - 15 - 65 - 15 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        contentSize.height = contentSize.height + 20;
        contentSize.width = kScreenWidth - 15 - 65 - 10 * 2;
        [_contentLabel setText:content];
        [_contentLabel setSize:contentSize];
        spaceYStart += _contentLabel.height + 10;
    }
    else
    {
        _contentLabel.height = 0;
    }
    _sepLine.y = spaceYStart;
    
    NSString *author = [NSString stringWithFormat:@"来自%@老师",timelineItem.teacherInfo.teacherName];
    [_authorLabel setText:author];
    [_authorLabel sizeToFit];
    [_authorLabel setOrigin:CGPointMake(12, _sepLine.bottom + (30 - _authorLabel.height) / 2)];
    
    [_timeLabel setText:timelineItem.formatTime];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_bgView.width - _timeLabel.width, _sepLine.bottom + (30 - _authorLabel.height) / 2)];
    [_bgView setHeight:spaceYStart + 30];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    GrowthTimelineItem *item = (GrowthTimelineItem *)modelItem;
    NSString *content = item.content;
    NSInteger contentHeight = 60;
    if([content length] > 0)
    {
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(width - 15 - 65 - 15 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        contentHeight += contentSize.height + 20 + 10;
    }
    contentHeight += 30 + 20;
    return @(contentHeight);
}
@end

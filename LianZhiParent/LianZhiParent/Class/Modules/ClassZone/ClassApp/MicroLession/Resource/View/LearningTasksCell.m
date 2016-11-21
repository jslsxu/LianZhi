//
//  GrowthTimelineCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "LearningTasksCell.h"

#define kBottomViewHeight               26

@implementation LearningTasksCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    UILabel*        _dateLabel;
//    UILabel*        _titleLabel;
//    UIButton*        _statusBtn;
//    UIButton*        _totalBtn;
//    
//    UILabel*        _contentLabel;
//    
//    UIView*         _sepLine;
//    UIButton*        startTest;
    
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _titleLabel  =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 140, 20)];
        [_titleLabel setTextAlignment:NSTextAlignmentRight];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_titleLabel];
        
        _titleLabel.text = @"3月20日语文作业";
        
        _dateLabel  =[[UILabel alloc] initWithFrame:CGRectMake(160, 10, 45, 20)];
        [_dateLabel setTextAlignment:NSTextAlignmentRight];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setFont:[UIFont systemFontOfSize:16]];
        [_dateLabel setNumberOfLines:0];
        [_dateLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_dateLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_dateLabel];
        
        _dateLabel.text = @"10:00";
        
        _statusBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _statusBtn.frame=CGRectMake(self.width - 80, 10, 60, 25);
        
        [_statusBtn setTitle:@"未完成" forState:UIControlStateNormal];
        _statusBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
        _statusBtn.titleLabel.font=[UIFont systemFontOfSize:15.0f];
        [_statusBtn setBackgroundColor:[UIColor blueColor]];
//        [_statusBtn setBackgroundColor:[UIColor blueColor]];
        [_statusBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [_statusBtn setUserInteractionEnabled:NO];
        
        [_statusBtn.layer setCornerRadius:2.0]; //设置矩形四个圆角半径
        [_statusBtn.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorStatusBtnSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorStatusBtnref = CGColorCreate(colorStatusBtnSpace,(CGFloat[]){ 1, 0, 0, 1 });
        
        [startTest.layer setBorderColor:colorStatusBtnref];//边框颜色

        
        [_statusBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_statusBtn];
        
   
        
        _totalView = [[UIView alloc] initWithFrame:CGRectMake(20, 40, 80, 20)];
        [self addSubview:_totalView];
 
        [_totalView.layer setCornerRadius:2.0]; //设置矩形四个圆角半径
        [_totalView.layer setBorderWidth:1.0]; //边框宽度
        
        _totalLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        [_totalLbl setFont:[UIFont systemFontOfSize:12]];
        [_totalLbl setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_totalLbl setNumberOfLines:0];
        [_totalLbl setLineBreakMode:NSLineBreakByWordWrapping];
        [_totalView addSubview:_totalLbl];
        _totalLbl.text = @"共15道题";
        
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 40, 180, 20)];
        [_contentLabel setFont:[UIFont systemFontOfSize:12]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
        _contentLabel.text = @"已有36人完成";
        
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 65, self.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
//        [_sepLine setBackgroundColor:[UIColor grayColor]];
        [self addSubview:_sepLine];
        
        startTest =[UIButton buttonWithType:UIButtonTypeCustom];
        startTest.frame=CGRectMake(self.width - 100, 70, 80, 25);
        [startTest setTitle:@"开始答题" forState:UIControlStateNormal];
        startTest.titleLabel.textAlignment=NSTextAlignmentCenter;
        startTest.titleLabel.font=[UIFont systemFontOfSize:18.0f];
//        [startTest setBackgroundColor:[UIColor blueColor]];
        //        [_statusBtn setBackgroundColor:[UIColor blueColor]];
        [startTest setTitleColor:[UIColor colorWithHexString:@"999999"]  forState:UIControlStateNormal];
        [startTest.layer setMasksToBounds:YES];
        
        [startTest.layer setCornerRadius:2.0]; //设置矩形四个圆角半径
        [startTest.layer setBorderWidth:1.0]; //边框宽度
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
        
        [startTest.layer setBorderColor:colorref];//边框颜色
        
        [startTest addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startTest];
        
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
   
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
//    GrowthTimelineItem *item = (GrowthTimelineItem *)modelItem;
//    NSString *content = item.content;
    NSInteger contentHeight = 60;
//    if([content length] > 0)
//    {
//        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(width - 15 - 60 - 20 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
//        contentHeight += contentSize.height + 20 + 10;
//    }
//    contentHeight += kBottomViewHeight + 10;
    return @(contentHeight);
}
@end

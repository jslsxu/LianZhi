//
//  GrowthTimelinePublishCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelinePublishCell.h"

@implementation GrowthTimelinePublishCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setFrame:CGRectMake(12, 10, self.width - 12 * 2, 230 - 10 * 2)];
        [_bgImageView setUserInteractionEnabled:YES];
        [self addSubview:_bgImageView];
        
        _grayBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_grayBG setUserInteractionEnabled:YES];
        [_grayBG setFrame:CGRectMake(40, 15, _bgImageView.width - 40 - 12, 45)];
        [_bgImageView addSubview:_grayBG];
        
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(12, 8, 60, 60)];
        [_bgImageView addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatar.right + 8, 20, 55, 16)];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [_bgImageView addSubview:_nameLabel];
        
        _genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatar.right + 8, _nameLabel.bottom + 5, 55, 13)];
        [_genderLabel setFont:[UIFont systemFontOfSize:12]];
        [_genderLabel setTextColor:[UIColor lightGrayColor]];
        [_bgImageView addSubview:_genderLabel];
        
        _temperatureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_temperatureButton addTarget:self action:@selector(onTemperatureButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_temperatureButton setFrame:CGRectMake(_grayBG.width - 10 - 40, (_grayBG.height - 40) / 2, 40, 40)];
        [_temperatureButton setImage:[UIImage imageNamed:(@"TempNormal.png")] forState:UIControlStateNormal];
        [_grayBG addSubview:_temperatureButton];
        
        _toiletButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toiletButton addTarget:self action:@selector(onToiletButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_toiletButton setFrame:CGRectMake(_temperatureButton.left - 5 - 40, (_grayBG.height - 40) / 2, 40, 40)];
        [_toiletButton setImage:[UIImage imageNamed:(@"ToiletNo.png")] forState:UIControlStateNormal];
        [_grayBG addSubview:_toiletButton];
        
        _emotionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emotionButton addTarget:self action:@selector(onEmotionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_emotionButton setFrame:CGRectMake(_toiletButton.left - 5 - 40, (_grayBG.height - 40) / 2, 40, 40)];
        [_emotionButton setImage:[UIImage imageNamed:(@"ExpressionHappy.png")] forState:UIControlStateNormal];
        [_grayBG addSubview:_emotionButton];
        
        
        CGFloat spaceYStart = _grayBG.bottom + 15;
        UIColor *waterColor = [UIColor colorWithRed:73 / 255.0 green:169 / 255.0 blue:215 / 255.0 alpha:1.f];
        _waterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, spaceYStart, 45, 15)];
        [_waterLabel setFont:[UIFont systemFontOfSize:14]];
        [_waterLabel setTextColor:waterColor];
        [_waterLabel setText:@"饮水量"];
        [_bgImageView addSubview:_waterLabel];
        
        
        _waterSlider = [[UISlider alloc] initWithFrame:CGRectMake(65, _waterLabel.y, 160, 15)];
        [_waterSlider setMaximumValue:8];
        [_waterSlider setMinimumValue:1];
        [_waterSlider addTarget:self action:@selector(onWaterValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_waterSlider setTintColor:waterColor];
        [_bgImageView addSubview:_waterSlider];
        

        _waterValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(_waterSlider.right + 5, spaceYStart, 55, 15)];
        [_waterValueLabel setFont:[UIFont systemFontOfSize:14]];
        [_waterValueLabel setTextColor:waterColor];
        [_waterValueLabel setTextAlignment:NSTextAlignmentRight];
        [_waterValueLabel setText:@"8杯"];
        [_bgImageView addSubview:_waterValueLabel];
        
        [_waterSlider setValue:8];
        spaceYStart += _waterSlider.height + 15;
        
        UIColor *sleepColor = [UIColor colorWithRed:182 / 255.0 green:127 / 255.0 blue:106 / 255.0 alpha:1.f];
        _sleepLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, spaceYStart, 45, 15)];
        [_sleepLabel setFont:[UIFont systemFontOfSize:14]];
        [_sleepLabel setTextColor:sleepColor];
        [_sleepLabel setText:@"睡    眠"];
        [_bgImageView addSubview:_sleepLabel];
        
        
        _sleepSlider = [[UISlider alloc] initWithFrame:CGRectMake(65, _sleepLabel.y, 160, 15)];
        [_sleepSlider setMinimumValue:0];
        [_sleepSlider setMaximumValue:3];
        [_sleepSlider addTarget:self action:@selector(onSleepSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_sleepSlider setTintColor:sleepColor];
        [_bgImageView addSubview:_sleepSlider];
        
        
        _sleepTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sleepSlider.right + 5, spaceYStart, 55, 15)];
        [_sleepTimeLabel setFont:[UIFont systemFontOfSize:14]];
        [_sleepTimeLabel setTextColor:sleepColor];
        [_sleepTimeLabel setTextAlignment:NSTextAlignmentRight];
        [_sleepTimeLabel setText:@"2小时"];
        [_bgImageView addSubview:_sleepTimeLabel];
        
        [_sleepSlider setValue:2];
        spaceYStart += 15 + 15;
        
        UIImageView *textBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [textBG setFrame:CGRectMake(15, spaceYStart, _bgImageView.width - 15 * 2, 60)];
        [textBG setUserInteractionEnabled:YES];
        [_bgImageView addSubview:textBG];
        
        
        _textView = [[UTPlaceholderTextView alloc] initWithFrame:textBG.bounds];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [_textView setScrollsToTop:NO];
        [_textView setFont:[UIFont systemFontOfSize:14]];
        [_textView setTextColor:[UIColor grayColor]];
        [_textView setReturnKeyType:UIReturnKeyDone];
        [_textView setDelegate:self];
        [_textView setPlaceholder:@"写点什么"];
        [textBG addSubview:_textView];
        
    }
    return self;
}

- (void)setModelItem:(GrowthTimelineModelItem *)modelItem
{
    _modelItem = modelItem;
    StudentInfo *student = _modelItem.studentInfo;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:student.avatar]];
    [_nameLabel setText:student.name];
    if(student.sex == GenderFemale)
        [_genderLabel setText:@"小美女"];
    else
        [_genderLabel setText:@"小帅哥"];
    NSString *temp = [_modelItem temprature];
    if([temp isEqualToString:@"正常"])
        [_temperatureButton setImage:[UIImage imageNamed:(@"TempNormal.png")] forState:UIControlStateNormal];
    else if([temp isEqualToString:@"发烧"])
        [_temperatureButton setImage:[UIImage imageNamed:(@"TempHigh.png")] forState:UIControlStateNormal];
    
    NSInteger stoolNum = [_modelItem stoolNum];
    if(stoolNum == 0)
        [_toiletButton setImage:[UIImage imageNamed:(@"ToiletNo.png")] forState:UIControlStateNormal];
    else if(stoolNum == 1)
        [_toiletButton setImage:[UIImage imageNamed:(@"ToiletOnce.png")] forState:UIControlStateNormal];
    else if(stoolNum == 2)
        [_toiletButton setImage:[UIImage imageNamed:(@"ToiletTwice.png")] forState:UIControlStateNormal];
    
    NSString *emotion = [_modelItem emotion];
    if([emotion isEqualToString:@"高兴"])
        [_emotionButton setImage:[UIImage imageNamed:(@"ExpressionHappy.png")] forState:UIControlStateNormal];
    else if ([emotion isEqualToString:@"哭闹"])
        [_emotionButton setImage:[UIImage imageNamed:(@"ExpressionCry.png")] forState:UIControlStateNormal];
    else
        [_emotionButton setImage:[UIImage imageNamed:(@"ExpressionSimple.png")] forState:UIControlStateNormal];

    [_waterSlider setValue:_modelItem.water];
    [_waterValueLabel setText:[NSString stringWithFormat:@"%ld杯",(long)_modelItem.water]];
    
    [_sleepSlider setValue:_modelItem.sleep];
    [_sleepTimeLabel setText:[NSString stringWithFormat:@"%.1f小时",_modelItem.sleep]];
    [_textView setText:_modelItem.comment];
}

- (void)onTemperatureButtonClicked
{
    GrowthTimelineModelItem *timelineItem = (GrowthTimelineModelItem *)self.modelItem;
    NSString *temp = [timelineItem temprature];
    NSString *next = nil;
    if([temp isEqualToString:@"正常"])
    {
        [_temperatureButton setImage:[UIImage imageNamed:(@"TempHigh.png")] forState:UIControlStateNormal];
        next = @"发烧";
    }
    else if([temp isEqualToString:@"发烧"])
    {
        [_temperatureButton setImage:[UIImage imageNamed:(@"TempNormal.png")] forState:UIControlStateNormal];
        next = @"正常";
    }
    [timelineItem setTemprature:next];
}

- (void)onToiletButtonClicked
{
    GrowthTimelineModelItem *timelineItem = (GrowthTimelineModelItem *)self.modelItem;
    NSInteger stoolNum = [timelineItem stoolNum];
    NSInteger next = 0;
    if(stoolNum == 0)
    {
        next = 1;
        [_toiletButton setImage:[UIImage imageNamed:(@"ToiletOnce.png")] forState:UIControlStateNormal];
    }
    else if(stoolNum == 1)
    {
        next = 2;
        [_toiletButton setImage:[UIImage imageNamed:(@"ToiletTwice.png")] forState:UIControlStateNormal];
    }
    else
    {
        next = 0;
        [_toiletButton setImage:[UIImage imageNamed:(@"ToiletNo.png")] forState:UIControlStateNormal];
    }
    [timelineItem setStoolNum:next];
}

- (void)onEmotionButtonClicked
{
    GrowthTimelineModelItem *timelineItem = (GrowthTimelineModelItem *)self.modelItem;
    NSString *emotion = [timelineItem emotion];
    NSString *next = nil;
    if([emotion isEqualToString:@"高兴"])
    {
        next = @"哭闹";
        [_emotionButton setImage:[UIImage imageNamed:(@"ExpressionCry.png")] forState:UIControlStateNormal];
    }
    else if ([emotion isEqualToString:@"哭闹"])
    {
        next = @"一般";
        [_emotionButton setImage:[UIImage imageNamed:(@"ExpressionSimple.png")] forState:UIControlStateNormal];
    }
    else
    {
        next = @"高兴";
        [_emotionButton setImage:[UIImage imageNamed:(@"ExpressionHappy.png")] forState:UIControlStateNormal];
    }
    [timelineItem setEmotion:next];
}

+ (CGFloat)cellHeight
{
    return 230;
}

- (void)onWaterValueChanged:(id)sender
{
    NSInteger waterValue = _waterSlider.value;
    [_waterValueLabel setText:[NSString stringWithFormat:@"%ld杯",(long)waterValue]];
    [self.modelItem setWater:waterValue];
}

- (void)onSleepSliderValueChanged:(id)sender
{
    CGFloat sleepTime = _sleepSlider.value;
    for (NSInteger i = 0; i <= _sleepSlider.maximumValue / 0.5; i++) {
        CGFloat curValue = 0.5 * i;
        if(fabs(curValue - sleepTime) < 0.25)
        {
            sleepTime = curValue;
            break;
        }
    }
    [_sleepTimeLabel setText:[NSString stringWithFormat:@"%.1f小时",sleepTime]];
    [self.modelItem setSleep:sleepTime];
}

#pragma mark - UITextViewdelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
//    [self.modelItem setComment:textView.text];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self.modelItem setComment:textView.text];
}
@end

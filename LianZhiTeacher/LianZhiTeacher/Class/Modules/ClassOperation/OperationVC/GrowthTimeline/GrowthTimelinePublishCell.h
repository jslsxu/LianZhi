//
//  GrowthTimelinePublishCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowthTimelineModelItem.h"
@interface GrowthTimelinePublishCell : UITableViewCell<UITextViewDelegate>
{
    UIImageView*    _bgImageView;
    UIImageView*    _grayBG;
    AvatarView*     _avatar;
    UILabel*        _nameLabel;
    UILabel*        _genderLabel;
    UIButton*       _emotionButton;
    UIButton*       _toiletButton;
    UIButton*       _temperatureButton;
    UILabel*        _waterLabel;
    UISlider*       _waterSlider;
    UILabel*        _waterValueLabel;
    UILabel*        _sleepLabel;
    UISlider*       _sleepSlider;
    UILabel*        _sleepTimeLabel;
    UTPlaceholderTextView*     _textView;
}

@property (nonatomic, strong)GrowthTimelineModelItem *modelItem;
+ (CGFloat)cellHeight;
@end

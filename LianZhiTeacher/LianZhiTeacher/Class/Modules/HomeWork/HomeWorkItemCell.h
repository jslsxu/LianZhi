//
//  HomeWorkItemCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeWorkItem.h"
@interface HomeWorkItemCell : UITableViewCell
{
    UILabel*        _contentLabel;
    UIImageView*    _photoView;
    MessageVoiceButton* _voiceButton;
    UILabel*        _timeLabel;
    UIView*         _bottomLine;
}
@property (nonatomic, strong)HomeWorkItem *homeWorkItem;

+ (CGFloat)cellHeightForItem:(HomeWorkItem *)homeWorkItem forWidth:(NSInteger)width;
@end

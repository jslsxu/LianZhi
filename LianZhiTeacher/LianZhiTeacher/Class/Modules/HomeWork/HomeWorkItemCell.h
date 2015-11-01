//
//  HomeWorkItemCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeWorkItem.h"
@class HomeWorkItemCell;
@protocol HomeWorkItemCellDelegate <NSObject>

- (void)homeWorkCellDidDelete:(HomeWorkItemCell *)cell;
- (void)homeWorkCellDidShare:(HomeWorkItemCell *)cell;
@end

@interface HomeWorkItemCell : TNTableViewCell
{
    UILabel*        _contentLabel;
    UIImageView*    _photoView;
    MessageVoiceButton* _voiceButton;
    UILabel*        _timeLabel;
    UIView*         _bottomLine;
    UIButton*       _deleteButton;
}
@property (nonatomic, strong)HomeWorkItem *homeWorkItem;
@property (nonatomic, assign)BOOL focused;
@property (nonatomic, weak)id<HomeWorkItemCellDelegate> delegate;
+ (CGFloat)cellHeightForItem:(HomeWorkItem *)homeWorkItem forWidth:(NSInteger)width;
@end

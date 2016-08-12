//
//  NotificationDetailVoiceView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatVoiceButton.h"
@interface AudioContentView : UIView
{
    ChatVoiceButton*        _voiceButton;
    UILabel*                _durationLabel;
    UIButton*               _removeButton;
}
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, copy)void (^deleteCallback)();
- (instancetype)initWithMaxWidth:(CGFloat)maxWidth;
@end

@interface NotificationDetailVoiceView : UIView
@property (nonatomic, strong)NSArray *voiceArray;
@end

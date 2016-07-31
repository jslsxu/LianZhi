//
//  NotificationVoiceView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatVoiceButton.h"
@interface AudioContentView : UIView
{
    ChatVoiceButton*        _voiceButton;
    UIButton*               _removeButton;
}
- (instancetype)initWithAudioItem:(AudioItem *)audioItem;
@end

@interface NotificationVoiceView : UIView
@property (nonatomic, strong)NSArray *voiceArray;
@end

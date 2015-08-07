//
//  MessageVoiceButton.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/23.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MessageVoiceButton : MLPlayVoiceButton
{
    UIImageView*    _audioIcon;
    UILabel*        _spanLabel;
}
@property (nonatomic, weak)AudioItem *audioItem;
@end
//
//  RecordPublishVoiceView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/9.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordPublishBaseView.h"
#import "NotificationVoiceView.h"
@interface RecordPublishVoiceView : RecordPublishBaseView
@property (nonatomic, strong)NSArray *voiceArray;
@property (nonatomic, assign)BOOL    editDisable;
@end

//
//  RecordReplyVoiceView.h
//  LianZhiParent
//
//  Created by jslsxu on 17/2/9.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordReplyContentBaseView.h"
#import "NotificationDetailVoiceView.h"

@interface RecordReplyVoiceView : RecordReplyContentBaseView
@property (nonatomic, strong)NSArray *voiceArray;
@property (nonatomic, assign)BOOL    editDisable;
@end

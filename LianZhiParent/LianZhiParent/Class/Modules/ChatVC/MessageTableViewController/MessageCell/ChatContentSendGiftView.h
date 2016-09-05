//
//  ChatGiftCell.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatBubbleContentView.h"
extern NSString* const ReceiveGiftNotification;
extern NSString* const ReceiveGiftMessageKey;
@interface ChatContentSendGiftView : ChatBubbleContentView
{
    UIImageView*                _giftView;
    UILabel*                    _giftDetailLabel;
}
@property (nonatomic, copy)void (^receiveGiftCallback)(MessageItem *messageItem);
@end

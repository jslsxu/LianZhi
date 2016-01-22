//
//  MessageItem.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"

typedef NS_ENUM(NSInteger, MessageStatus)
{
    MessageStatusSuccess = 0,
    MessageStatusFailed,
    MessageStatusSending
};

typedef NS_ENUM(NSInteger, MessageType) {
    UUMessageTypeText     = 1 , // 文字
    UUMessageTypeVoice    = 2 ,  // 语音
    UUMessageTypePicture  = 3 , // 图片
    UUMessageTypeFace     = 4 ,    // 表情
    UUMessageTypeDeleted  = 8,      //消息被删除
    UUMessageTypeRevoked  = 9,      //消息被撤销
    UUMessageTypeGift = 10,         //
};

typedef NS_ENUM(NSInteger, ChatType)
{
    ChatTypeTeacher = 21,
    ChatTypeParents = 22,
    ChatTypeClass = 23,
    ChatTypeGroup = 24,
    ChatTypePractice = 25,  //作业通知
    ChatTypeAttendance = 26,    //请假
};

typedef NS_ENUM(NSInteger, MessageFrom) {
    UUMessageFromMe    = 0,   // 自己发的
    UUMessageFromOther = 1    // 别人发得
};

@interface MessageContent : TNModelItem
@property (nonatomic, copy)NSString *mid;
@property (nonatomic, assign)MessageType messageType;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, strong)PhotoItem *photoItem;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, assign)NSInteger timeInterval;
@property (nonatomic, copy)NSString *ctime;
@property (nonatomic, assign)BOOL hideTime;
@end

@interface MessageItem : TNModelItem
@property (nonatomic, assign)MessageStatus messageStatus;
@property (nonatomic, assign)BOOL isTmp;
@property (nonatomic, copy)NSString *client_send_id;
@property (nonatomic, assign)MessageFrom from;
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, strong)MessageContent *messageContent;

//
@property (nonatomic, strong)NSDictionary *params;
- (CGFloat)cellHeight;
@end

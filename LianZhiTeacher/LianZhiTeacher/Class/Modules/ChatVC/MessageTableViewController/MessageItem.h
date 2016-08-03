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
    UUMessageTypeGift     = 5,    //礼物
    UUMessageTypeReceiveGift    = 6,    //收礼物
    UUMessageTypeDeleted  = 8,      //消息被删除
    UUMessageTypeRevoked  = 9,      //消息被撤销
    UUMessageTypeVideo,             //视频消息
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

@interface Exinfo : TNBaseObject
@property (nonatomic, copy)NSString *presnetId;
@property (nonatomic, copy)NSString *presentName;
@property (nonatomic, strong)PhotoItem *imgs;
@property (nonatomic, strong)AudioItem *voice;
@end

@interface MessageContent : TNBaseObject
@property (nonatomic, copy)NSString *mid;
@property (nonatomic, assign)BOOL unread;
@property (nonatomic, assign)MessageType type;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, assign)NSString * timeStr;
@property (nonatomic, assign)NSInteger ctime;
@property (nonatomic, assign)BOOL hideTime;
@property (nonatomic, strong)Exinfo* exinfo;
@end

@interface MessageItem : TNBaseObject
@property (nonatomic, copy)NSString *targetUser;
@property (nonatomic, assign)MessageStatus messageStatus;
@property (nonatomic, assign)BOOL isTmp;
@property (nonatomic, copy)NSString *client_send_id;
@property (nonatomic, assign)MessageFrom from;
@property (nonatomic, strong)UserInfo *user;
@property (nonatomic, strong)MessageContent *content;
@property (nonatomic, assign)NSInteger createTime;
//
@property (nonatomic, strong)NSDictionary *params;
- (BOOL)isMyMessage;
- (void)makeClientSendID;
- (NSString *)reuseID;
@end

//
//  MessageItem.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"
#import "VideoItem.h"
#import "GiftItem.h"
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
    UUMessageTypeVideo      = 7,          //视频消息
    UUMessageTypeDeleted  = 8,      //消息被删除
    UUMessageTypeRevoked  = 9,      //消息被撤销
};

typedef NS_ENUM(NSInteger, ChatType)
{
    ChatTypeLianZhiBroadcast = 1,   //连职广播电台
    ChatTypePhotoShare = 2,         //照片分享
    ChatTypeGrowthRecord = 3,       //成长手册
    ChatTypeSchoolyardNotification = 4, //校园通知
    ChatTypeSchoolNotification = 10,             //学校
    ChatTypeClassNotification = 11,             //班级
    ChatTypeGradeNotification = 12,             //年级
    ChatTypeTeacherNotification = 13,   //老师
    ChatTypeParentsNotification = 14,   //家长
    ChatTypeChildrenNotificaiton = 15,  //孩子
    ChatTypeTeacher = 21,
    ChatTypeParents = 22,
    ChatTypeClass = 23,
    ChatTypeGroup = 24,
    ChatTypePractice = 25,  //作业通知
    ChatTypeAttendance = 26,    //请假
    ChatTypeNotification = 27,  //普通通知
    ChatTypeDoorEntrance = 28,  //门禁通知
    ChatTypeHomeworkNotification = 29,  //新作业通知
};

typedef NS_ENUM(NSInteger, MessageFrom) {
    UUMessageFromMe    = 0,   // 自己发的
    UUMessageFromOther = 1    // 别人发得
};

@interface AtItem : TNBaseObject
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *uid;
@end

@interface Exinfo : TNBaseObject
@property (nonatomic, copy)NSString *presentId;
@property (nonatomic, copy)NSString *presentName;
@property (nonatomic, strong)PhotoItem *imgs;
@property (nonatomic, strong)AudioItem *voice;
@property (nonatomic, strong)VideoItem *video;
@property (nonatomic, strong)NSArray* im_at;
@end

@interface MessageContent : TNBaseObject
@property (nonatomic, copy)NSString *uniqueId;
@property (nonatomic, copy)NSString *mid;
@property (nonatomic, assign)BOOL unread;
@property (nonatomic, assign)MessageType type;
@property (nonatomic, copy)NSString *text;
@property (nonatomic, assign)NSInteger ctime;
@property (nonatomic, assign)BOOL hideTime;
@property (nonatomic, strong)Exinfo* exinfo;
- (NSString *)timeStr;
@end

@interface MessageItem : TNBaseObject
@property (nonatomic, copy)NSString *targetUser;
@property (nonatomic, assign)MessageStatus messageStatus;
@property (nonatomic, assign)BOOL isTmp;
@property (nonatomic, copy)NSString *client_send_id;
@property (nonatomic, strong)UserInfo *user;
@property (nonatomic, strong)MessageContent *content;
@property (nonatomic, assign)NSInteger createTime;
@property (nonatomic, assign)BOOL isRead;

- (BOOL)isLocalMessage;
- (MessageFrom)from;
+ (MessageItem *)messageItemWithText:(NSString *)text atArray:(NSArray *)atList;
+ (MessageItem *)messageItemWithAudio:(AudioItem *)audioItem;
+ (MessageItem *)messageItemWithVideo:(VideoItem *)videoItem;
+ (MessageItem *)messageItemWithImage:(PhotoItem *)photoItem;
+ (MessageItem *)messageItemWithGift:(GiftItem *)giftItem;
+ (MessageItem *)messageItemWithFace:(NSString *)face;
+ (MessageItem *)messageItemWithReceiveGift:(NSString *)giftName;
- (BOOL)isAtMe;
- (void)sendWithCommonParams:(NSDictionary *)commonParams progress:(void (^)(CGFloat progress))progressBlk success:(void (^)(MessageItem *messageItem))success fail:(void (^)(NSString *errMsg))failure;
- (BOOL)isMyMessage;
- (void)makeClientSendID;
- (NSString *)reuseID;
@end

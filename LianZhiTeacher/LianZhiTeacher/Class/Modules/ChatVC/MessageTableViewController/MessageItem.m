//
//  MessageItem.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageItem.h"
#define kPhotoMaxHeight         120

@implementation AtItem

@end

@implementation Exinfo
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"imgs" : [PhotoItem class],
             @"voice" : [AudioItem class],
             @"video" : [VideoItem class],
             @"im_at" : [AtItem class]};
}
@end

@implementation MessageContent
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"exinfo" : [Exinfo class]};
}

- (NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.ctime];
    return [formatter stringFromDate:date];
}

@end

@implementation MessageItem

- (instancetype)init{
    self = [super init];
    if(self){
        [self makeClientSendID];
        self.user = [UserCenter sharedInstance].userInfo;
        self.createTime = [[NSDate date] timeIntervalSince1970];
        self.isTmp = YES;
        self.messageStatus = MessageStatusSending;
        Exinfo *exinfo = [[Exinfo alloc] init];
        MessageContent *messageContent = [[MessageContent alloc] init];
        [messageContent setCtime:[[NSDate date] timeIntervalSince1970]];
        [messageContent setExinfo:exinfo];
        self.content = messageContent;
    }
    return self;
}

- (void)makeClientSendID{
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970];
    static long messageIndex = 1;
    
    NSString *client_send_id = [NSString stringWithFormat:@"%@_%ld_%05ld",[UserCenter sharedInstance].userInfo.uid, timeInterval, messageIndex];
    messageIndex++;
    self.client_send_id = client_send_id;
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"user": [UserInfo class],
             @"content" : [MessageContent class]};
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"params"];
}


- (MessageFrom)from{
    MessageFrom fromType;
    if([self.user.uid isEqualToString:[UserCenter sharedInstance].userInfo.uid])
        fromType = UUMessageFromMe;
    else
        fromType = UUMessageFromOther;
    return fromType;
}

- (BOOL)isMyMessage{
    return self.from == UUMessageFromMe;
}


- (NSString *)reuseID{
    NSString *reuseIdentifier = @"text";
    switch (self.content.type) {
        case UUMessageTypeText:
            reuseIdentifier = @"text";
            break;
        case UUMessageTypePicture:
            reuseIdentifier = @"image";
            break;
        case UUMessageTypeFace:
            reuseIdentifier = @"face";
            break;
        case UUMessageTypeGift:
            reuseIdentifier = @"gift";
            break;
        case UUMessageTypeReceiveGift:
            reuseIdentifier = @"receiveGift";
            break;
        case UUMessageTypeVoice:
            reuseIdentifier = [NSString stringWithFormat:@"audio_%@",self.client_send_id];
            break;
        case UUMessageTypeVideo:
            reuseIdentifier = [NSString stringWithFormat:@"video_%@",self.client_send_id];
            break;
        case UUMessageTypeRevoked:
            reuseIdentifier = @"revoked";
            break;
        default:
            break;
    }
    return reuseIdentifier;
}

+ (MessageItem *)messageItemWithText:(NSString *)text atArray:(NSArray *)atList{
    MessageItem *messageItem = [[MessageItem alloc] init];
    if(atList.count > 0){
        NSMutableArray *atList = [NSMutableArray array];
        for (UserInfo *userInfo in atList) {
            NSString *type;
            if([userInfo isKindOfClass:[TeacherInfo class]]){
                type = @"t";
            }
            else{
                type = @"p";
            }
            [atList addObject:@{@"type" : type, @"uid" : userInfo.uid}];
        }
        
        [messageItem.content.exinfo setIm_at:atList];
    }
    [messageItem.content setText:text];
    [messageItem.content setType:UUMessageTypeText];
    return messageItem;
}
+ (MessageItem *)messageItemWithAudio:(AudioItem *)audioItem{
    MessageItem *messageItem = [[MessageItem alloc] init];
    [messageItem.content.exinfo setVoice:audioItem];
    [messageItem.content setType:UUMessageTypeVoice];
    return messageItem;
}
+ (MessageItem *)messageItemWithVideo:(VideoItem *)videoItem{
    MessageItem *messageItem = [[MessageItem alloc] init];
    [messageItem.content.exinfo setVideo:videoItem];
    [messageItem.content setType:UUMessageTypeVideo];
    return messageItem;
}
+ (MessageItem *)messageItemWithImage:(PhotoItem *)photoItem{
    MessageItem *messageItem = [[MessageItem alloc] init];
    [messageItem.content.exinfo setImgs:photoItem];
    [messageItem.content setType:UUMessageTypePicture];
    return messageItem;
}
+ (MessageItem *)messageItemWithGift:(GiftItem *)giftItem{
    MessageItem *messageItem = [[MessageItem alloc] init];
    [messageItem.content.exinfo setPresnetId:giftItem.giftID];
    [messageItem.content.exinfo setPresentName:giftItem.giftName];
    [messageItem.content setType:UUMessageTypeGift];
    return messageItem;
}
+ (MessageItem *)messageItemWithFace:(NSString *)face{
    MessageItem *messageItem = [[MessageItem alloc] init];
    [messageItem.content setText:face];
    [messageItem.content setType:UUMessageTypeFace];
    return messageItem;
}

- (void)sendWithProgress:(void (^)(CGFloat progress))progressBlk success:(void (^)(MessageItem *messageItem))success fail:(void (^)(NSString *errMsg))failure{
    
}
@end

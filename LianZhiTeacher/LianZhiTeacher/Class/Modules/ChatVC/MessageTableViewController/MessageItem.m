//
//  MessageItem.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageItem.h"
#import "LZVideoCacheManager.h"
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

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"uniqueId" : @"id"};
}

- (NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.ctime];
    return [formatter stringFromDate:date];
}

@end

@implementation MessageItem
+ (NSArray <NSString *> *)modelPropertyBlacklist{
    return @[@"isRead"];
}

- (void)makeClientSendID{
    NSInteger timeInterval = [[NSDate date] timeIntervalSince1970];
    static long messageIndex = 1;
    
    NSString *client_send_id = [NSString stringWithFormat:@"%@_%ld_%05ld",[UserCenter sharedInstance].userInfo.uid, timeInterval, messageIndex];
    messageIndex++;
    self.client_send_id = client_send_id;
}

- (BOOL)isLocalMessage{
    return self.content.mid.length == 0;
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
- (BOOL)isAtMe{
    NSArray *atList = self.content.exinfo.im_at;
    if(atList.count > 0){
        for (AtItem *atItem in atList) {
            if([atItem.uid isEqualToString:[UserCenter sharedInstance].userInfo.uid]){
                return YES;
            }
        }
    }
    return NO;
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

+ (MessageItem *)createSendMessageItem{
    MessageItem *messageItem = [[MessageItem alloc] init];
    [messageItem makeClientSendID];
    messageItem.user = [UserCenter sharedInstance].userInfo;
    messageItem.createTime = [[NSDate date] timeIntervalSince1970];
    messageItem.isTmp = YES;
    messageItem.messageStatus = MessageStatusSending;
    Exinfo *exinfo = [[Exinfo alloc] init];
    MessageContent *messageContent = [[MessageContent alloc] init];
    [messageContent setCtime:[[NSDate date] timeIntervalSince1970]];
    [messageContent setExinfo:exinfo];
    messageItem.content = messageContent;
    return messageItem;
}

+ (MessageItem *)messageItemWithText:(NSString *)text atArray:(NSArray *)atList{
    MessageItem *messageItem = [MessageItem createSendMessageItem];
    if(atList.count > 0){
        NSMutableArray *atArray = [NSMutableArray array];
        for (UserInfo *userInfo in atList) {
            NSString *type;
            if([userInfo isKindOfClass:[TeacherInfo class]]){
                type = @"t";
            }
            else{
                type = @"p";
            }
            [atArray addObject:@{@"type" : type, @"uid" : userInfo.uid}];
        }
        if(atArray.count > 0)
        [messageItem.content.exinfo setIm_at:atArray];
    }
    [messageItem.content setText:text];
    [messageItem.content setType:UUMessageTypeText];
    return messageItem;
}

+ (MessageItem *)messageItemWithAudio:(AudioItem *)audioItem{
    MessageItem *messageItem = [MessageItem createSendMessageItem];
    [messageItem.content.exinfo setVoice:audioItem];
    [messageItem.content setType:UUMessageTypeVoice];
    return messageItem;
}
+ (MessageItem *)messageItemWithVideo:(VideoItem *)videoItem{
    MessageItem *messageItem = [MessageItem createSendMessageItem];
    [messageItem.content.exinfo setVideo:videoItem];
    [messageItem.content setType:UUMessageTypeVideo];
    return messageItem;
}
+ (MessageItem *)messageItemWithImage:(PhotoItem *)photoItem{
    MessageItem *messageItem = [MessageItem createSendMessageItem];
    [messageItem.content.exinfo setImgs:photoItem];
    [messageItem.content setType:UUMessageTypePicture];
    return messageItem;
}
+ (MessageItem *)messageItemWithGift:(GiftItem *)giftItem{
    MessageItem *messageItem = [MessageItem createSendMessageItem];
    [messageItem.content.exinfo setPresentId:giftItem.giftID];
    [messageItem.content.exinfo setPresentName:giftItem.giftName];
    [messageItem.content setType:UUMessageTypeGift];
    return messageItem;
}
+ (MessageItem *)messageItemWithFace:(NSString *)face{
    MessageItem *messageItem = [MessageItem createSendMessageItem];
    [messageItem.content setText:face];
    [messageItem.content setType:UUMessageTypeFace];
    return messageItem;
}

+ (MessageItem *)messageItemWithReceiveGift:(NSString *)giftName{
    MessageItem *messageItem = [MessageItem createSendMessageItem];
    [messageItem.content.exinfo setPresentName:giftName];
    [messageItem.content setType:UUMessageTypeReceiveGift];
    return messageItem;

}

- (NSDictionary *)sendParams{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    MessageType messageType = self.content.type;
    switch (messageType) {
        case UUMessageTypeText:
            [params setValue:self.content.text forKey:@"content"];
            if(self.content.exinfo.im_at.count > 0){
                NSString *atStr = [NSString stringWithJSONObject:self.content.exinfo.im_at];
                [params setValue:atStr forKey:@"im_at"];
            }
            break;
        case UUMessageTypeFace:
            [params setValue:self.content.text forKey:@"content"];
            break;
        case UUMessageTypeGift:
            [params setValue:self.content.exinfo.presentId forKey:@"present_id"];
            break;
        case UUMessageTypeVoice:
            [params setValue:kStringFromValue(self.content.exinfo.voice.timeSpan) forKey:@"voice_time"];
            break;
        case UUMessageTypeVideo:
            [params setValue:kStringFromValue(self.content.exinfo.video.videoTime) forKey:@"video_time"];
            break;
        case UUMessageTypeReceiveGift:
            [params setValue:self.content.exinfo.presentName forKey:@"content"];
            break;
        default:
            break;
    }
    [params setValue:kStringFromValue(messageType) forKey:@"content_type"];
    [params setValue:self.client_send_id forKey:@"client_send_id"];
    return params;
}

- (void)sendWithCommonParams:(NSDictionary *)commonParams progress:(void (^)(CGFloat progress))progressBlk success:(void (^)(MessageItem *messageItem))success fail:(void (^)(NSString *errMsg))failure{
    if(self.messageStatus != MessageStatusSending){
        return;
    }
    self.messageStatus = MessageStatusSending;
    NSMutableDictionary *sendParams = [NSMutableDictionary dictionaryWithDictionary:commonParams];
    NSDictionary *params = [self sendParams];
    for (NSString *key in params.allKeys) {
        [sendParams setValue:params[key] forKey:key];
    }
    NSString* targetname = commonParams[@"target_name"];
    if(self.content.type == UUMessageTypeGift && [targetname length] > 0){
        [sendParams setValue:targetname forKey:@"content"];
    }
    @weakify(self)
    MessageType messageType = self.content.type;
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"sms/send" withParams:sendParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        @strongify(self)
        if(messageType == UUMessageTypeVoice){
            AudioItem *audioItem = self.content.exinfo.voice;
            NSData *voiceData = [NSData dataWithContentsOfFile:audioItem.audioUrl];
            if(voiceData.length > 0){
                [formData appendPartWithFileData:voiceData name:@"file" fileName:@"file" mimeType:@"audio/AMR"];
            }
        }
        else if(messageType == UUMessageTypePicture){
            PhotoItem *photoItem = self.content.exinfo.imgs;
            NSData *data = [NSData dataWithContentsOfFile:photoItem.big];
            if(data.length > 0){
                [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"image/jpeg"];
            }
        }
        else if(messageType == UUMessageTypeVideo){
            VideoItem *videoitem = self.content.exinfo.video;
            NSData *videoData = [NSData dataWithContentsOfFile:videoitem.videoUrl];
            NSData *coverImageData = [NSData dataWithContentsOfFile:videoitem.coverUrl];
            if(videoData.length > 0 && coverImageData.length > 0){
                 [formData appendPartWithFileData:videoData name:@"video" fileName:@"video" mimeType:@"application/octet-stream"];
                [formData appendPartWithFileData:coverImageData name:@"video_cover" fileName:@"video_cover" mimeType:@"image/jpeg"];
            }
        }
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self)
        if(responseObject.count > 0){
            TNDataWrapper *messageWrapper = [responseObject getDataWrapperForIndex:0];
            MessageItem *messageItem = [MessageItem modelWithJSON:messageWrapper.data];
            messageItem.messageStatus = MessageStatusSuccess;
            messageItem.targetUser = self.targetUser;
            messageItem.isTmp = NO;
            if(messageType == UUMessageTypeVideo){
                VideoItem *originalVideoItem = [self.content.exinfo video];
                VideoItem *videoItem = messageItem.content.exinfo.video;
                [NHFileManager moveItemAtPath:originalVideoItem.videoUrl toPath:[LZVideoCacheManager videoPathForKey:videoItem.videoUrl]];
                NSData *imageData = [NSData dataWithContentsOfFile:originalVideoItem.coverUrl];
                UIImage *coverImage = [UIImage imageWithData:imageData];
                [[SDImageCache sharedImageCache] storeImage:coverImage forKey:videoItem.coverUrl];
                [[NSFileManager defaultManager] removeItemAtPath:originalVideoItem.coverUrl error:nil];
            }
            else if(messageType == UUMessageTypePicture){
                PhotoItem *originalPhotoItem = self.content.exinfo.imgs;
                PhotoItem *photoItem = messageItem.content.exinfo.imgs;
                NSData *data = [NSData dataWithContentsOfFile:originalPhotoItem.big];
                UIImage *image = [UIImage imageWithData:data];
                [[SDImageCache sharedImageCache] storeImage:image forKey:photoItem.big];
                [[SDImageCache sharedImageCache] storeImage:image forKey:photoItem.small];
                [[NSFileManager defaultManager] removeItemAtPath:originalPhotoItem.big error:nil];
            }
            if(success){
                success(messageItem);
            }
        }
    } fail:^(NSString *errMsg) {
        @strongify(self)
        self.messageStatus = MessageStatusFailed;
        if(failure){
            failure(errMsg);
        }
    }];

}
@end

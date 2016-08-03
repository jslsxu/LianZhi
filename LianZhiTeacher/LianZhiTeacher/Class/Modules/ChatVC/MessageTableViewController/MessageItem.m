//
//  MessageItem.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageItem.h"
#define kPhotoMaxHeight         120

@implementation Exinfo
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"imgs" : [PhotoItem class],
             @"voice" : [AudioItem class]};
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
        case UUMessageTypeRevoked:
            reuseIdentifier = @"revoked";
            break;
        default:
            break;
    }
    return reuseIdentifier;
}
@end

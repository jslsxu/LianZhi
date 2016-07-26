//
//  MessageItem.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageItem.h"
#import "MessageCell.h"
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

- (CGFloat)cellHeight
{
    NSInteger height = 0;
    if(self.content.type == UUMessageTypeText)
    {
        CGSize contentSize = [self.content.text boundingRectWithSize:CGSizeMake(kScreenWidth - 50 * 2 - 10 - 15, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        height = contentSize.height + 10 * 2;
    }
    else if(self.content.type == UUMessageTypeVoice)
        height = 32;
    else if(self.content.type == UUMessageTypePicture)
    {
        PhotoItem *photoItem = self.content.exinfo.imgs;
        if(photoItem.width > photoItem.height)//以宽为准
            height = kPhotoMaxHeight * photoItem.height / photoItem.width;
        else
            height = kPhotoMaxHeight;
    }
    else if(self.content.type == UUMessageTypeFace)
    {
        height = kFaceHeight;
    }
    else if(self.content.type == UUMessageTypeRevoked || self.content.type == UUMessageTypeReceiveGift)
        height = 32;
    else if (self.content.type == UUMessageTypeGift)
        height = 60;
    else
        height = 32;
    if(self.content.hideTime)
        return height + 10 + 10 + 5;
    else
        return height + 10 + 10 + 10 + 5 + kTimeLabelHeight;
}
@end

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

@implementation MessageContent

- (id)init
{
    self = [super init];
    if(self)
    {
        NSInteger timeInterval = [[NSDate date] timeIntervalSince1970];
        self.mid = kStringFromValue(timeInterval);
    }
    return self;
}

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.mid = [dataWrapper getStringForKey:@"mid"];
    self.messageType = [dataWrapper getIntegerForKey:@"type"];
    self.text = [dataWrapper getStringForKey:@"text"];
    TNDataWrapper *exinfoWrapper = [dataWrapper getDataWrapperForKey:@"exinfo"];
    TNDataWrapper *photoWrapper = [exinfoWrapper getDataWrapperForKey:@"imgs"];
    PhotoItem *photoItem = [[PhotoItem alloc] init];
    [photoItem parseData:photoWrapper];
    self.photoItem = photoItem;
    
    TNDataWrapper *audioWrapper = [exinfoWrapper getDataWrapperForKey:@"voice"];
    AudioItem *audioItem = [[AudioItem alloc] init];
    [audioItem parseData:audioWrapper];
    self.audioItem = audioItem;
    
    self.timeInterval = [dataWrapper getIntegerForKey:@"ctime"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.timeInterval];
    self.ctime = [formatter stringFromDate:date];
    
}

@end

@implementation MessageItem

- (id)init
{
    self = [super init];
    if(self)
    {
        NSInteger timeInterval = [[NSDate date] timeIntervalSince1970];
        self.client_send_id = [NSString stringWithFormat:@"%@_%ld_%ld",[UserCenter sharedInstance].userInfo.uid, timeInterval, (long)arc4random() % 100000];
    }
    return self;
}

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.client_send_id = [dataWrapper getStringForKey:@"client_send_id"];
    TNDataWrapper *userWrapper = [dataWrapper getDataWrapperForKey:@"user"];
    UserInfo *userInfo = [[UserInfo alloc] init];
    [userInfo parseData:userWrapper];
    self.userInfo = userInfo;
    
    if([self.userInfo.uid isEqualToString:[UserCenter sharedInstance].userInfo.uid])
        self.from = UUMessageFromMe;
    else
        self.from = UUMessageFromOther;
    
    TNDataWrapper *messageContentWrapper = [dataWrapper getDataWrapperForKey:@"content"];
    MessageContent *content = [[MessageContent alloc] init];
    [content parseData:messageContentWrapper];
    self.messageContent = content;
}

- (CGFloat)cellHeight
{
    NSInteger height = 0;
    if(self.messageContent.messageType == UUMessageTypeText)
    {
        CGSize contentSize = [self.messageContent.text boundingRectWithSize:CGSizeMake(kScreenWidth - 50 * 2 - 10 - 15, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        height = contentSize.height + 10 * 2;
    }
    else if(self.messageContent.messageType == UUMessageTypeVoice)
        height = 32;
    else if(self.messageContent.messageType == UUMessageTypePicture)
    {
        PhotoItem *photoItem = self.messageContent.photoItem;
        if(photoItem.width > photoItem.height)//以宽为准
            height = kPhotoMaxHeight * photoItem.height / photoItem.width;
        else
            height = kPhotoMaxHeight;
    }
    else if(self.messageContent.messageType == UUMessageTypeFace)
    {
        height = kFaceHeight;
    }
    else if(self.messageContent.messageType == UUMessageTypeRevoked)
        height = 32;
    if(self.messageContent.hideTime)
        return height + 10 + 10 + 5;
    else
        return height + 10 + 10 + 10 + 5 + kTimeLabelHeight;
}
@end

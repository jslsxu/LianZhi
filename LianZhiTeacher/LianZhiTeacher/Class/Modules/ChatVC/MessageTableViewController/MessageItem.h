//
//  MessageItem.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"
typedef NS_ENUM(NSInteger, MessageType) {
    UUMessageTypeText     = 1 , // 文字
    UUMessageTypeVoice    = 2 ,  // 语音
    UUMessageTypePicture  = 3 , // 图片
    UUMessageTypeFace     = 4     // 表情
};

typedef NS_ENUM(NSInteger, ChatType)
{
    ChatTypeTeacher = 21,
    ChatTypeParents = 22,
    ChatTypeClass = 23,
    ChatTypeGroup = 24,
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
@end

@interface MessageItem : TNModelItem
@property (nonatomic, assign)MessageFrom from;
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, strong)MessageContent *messageContent;
- (CGFloat)cellHeight;
@end

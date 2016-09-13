//
//  ChatMessageModel.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "MessageItem.h"
typedef NS_ENUM(NSInteger, RequestMessageType) {
    RequestMessageTypeLatest,
    RequestMessageTypeOld
};

@interface UpdateItem : TNBaseObject
@property (nonatomic, copy)NSString *mid;
@property (nonatomic, assign)MessageType mtype;
@property (nonatomic, assign)NSInteger ctime;
@end

@interface ChatMessageModel : TNBaseObject
@property (nonatomic, copy)NSString *targetUser;
@property (nonatomic, copy)NSString *oldId;
@property (nonatomic, copy)NSString *latestId;
@property (nonatomic, assign)BOOL quietModeOn;
@property (nonatomic, assign)BOOL needScrollBottom;
@property (nonatomic, assign)NSInteger numOfNew;

- (NSInteger)checkStatusTime;
- (NSArray *)messageArray;
- (instancetype)initWithUid:(NSString *)uid type:(ChatType)type;
- (BOOL)canInsert:(MessageItem *)messageItem;
- (NSInteger)loadOldData;
- (NSInteger)parseData:(NSDictionary *)data type:(RequestMessageType)type;
- (void)sendNewMessage:(MessageItem *)message;
- (void)updateMessage:(MessageItem *)message;
- (void)deleteMessage:(MessageItem *)message;
- (NSArray *)searchMessageWithKeyword:(NSString *)keyword from:(NSInteger)from;
- (void)loadForSearchItem:(NSString *)mid;
- (void)clearChatRecord;
+ (void)removeConversasionForUid:(NSString *)uid type:(ChatType)chatType;
@end

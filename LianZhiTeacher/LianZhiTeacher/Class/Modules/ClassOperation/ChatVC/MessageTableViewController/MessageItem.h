//
//  MessageItem.h
//  MFWIOS
//
//  Created by jslsxu on 9/24/13.
//  Copyright (c) 2013 mafengwo. All rights reserved.
//

typedef enum {
    MessageStateNormal = 0,
    MessageStateSending,
    MessageStateSendSuccess,
    MessageStateSendFail
}MessageState;

typedef enum {
    MessageTypeIncoming = 0,
    MessageTypeOutgoing
} MessageType;
@interface MessageItem : TNModelItem
{
    MessageType         _messageType;
    NSString*           _content;
    NSString*           _ctime;
    UserInfo*           _userInfo;
    MessageState        _messageState;
}
@property (nonatomic, assign)MessageType messageType;
@property (nonatomic, copy)NSString* content;
@property (nonatomic, copy)NSString* ctime;
@property (nonatomic, retain)UserInfo* userInfo;
@property (nonatomic, assign)MessageState messageState;
@end

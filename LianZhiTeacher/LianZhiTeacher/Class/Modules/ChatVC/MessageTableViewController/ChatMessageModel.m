//
//  ChatMessageModel.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ChatMessageModel.h"
#import "NHFileManager.h"
@interface ChatMessageModel ()
@property (nonatomic, assign)BOOL firstRequestNewMessage;
@property (nonatomic, strong)NSMutableArray* modelItemArray;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, assign)ChatType type;
@property (nonatomic, strong)FMDatabase *database;
@end

@implementation ChatMessageModel
- (void)dealloc{
    [_database close];
}
- (instancetype)initWithUid:(NSString *)uid type:(ChatType)type{
    self = [super init];
    if(self){
        self.uid = uid;
        self.type = type;
        self.firstRequestNewMessage = YES;
        NSString *tableName = [self tableName];
        BOOL tableExist = [self.database tableExists:tableName];
        if(!tableExist){
            [self.database executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@ (message_id bigint, client_send_id varchar(64), content text, message_json text)",tableName]];
        }
        else{
            [self loadOldData];
        }
    }
    return self;
}

- (NSArray *)messageArray{
    return self.modelItemArray;
}

- (FMDatabase *)database{
    if(!_database){
        _database = [FMDatabase databaseWithPath:[self chatPath]];
        [_database open];
    }
    return _database;
}

- (BOOL)loadOldData{
    NSString *sql = nil;
    FMResultSet *rs = nil;
    
    NSString *oldID = [self oldId];
    if(oldID.length > 0){
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE message_id < %@ order by message_id desc limit 20", [self tableName], oldID];
    }
    else{
        sql = [NSString stringWithFormat:@"select * from %@ order by message_id desc limit 20 ", [self tableName]];
    }
    rs = [self.database executeQuery:sql];
    BOOL loadFromDB = NO;
    while ([rs next]){
        loadFromDB = YES;
        NSString *messageJson = [rs stringForColumn:@"message_json"];
        MessageItem *item = [MessageItem nh_modelWithJson:messageJson];
        [self.modelItemArray addObject:item];
    }
    if(loadFromDB){
        [self sortMessage];
    }
    return loadFromDB;
}

- (NSMutableArray *)modelItemArray{
    if(!_modelItemArray){
        _modelItemArray = [NSMutableArray array];
    }
    return _modelItemArray;
}

- (NSString *)tableName{
    return [NSString stringWithFormat:@"conversation_%@_%zd",self.uid, self.type];
}

- (NSString *)chatPath{
    return [[NHFileManager chatDirectoryPathForUid:[UserCenter sharedInstance].userInfo.uid] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%zd",self.uid, self.type]];
}

- (NSString *)latestId{
    MessageItem *lastItem = self.modelItemArray.lastObject;
    return lastItem.content.mid;
}

- (NSString *)oldId{
    MessageItem *firstItem = self.modelItemArray.firstObject;
    return firstItem.content.mid;
}

- (void)sortMessage{
    [self.modelItemArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        MessageItem *first = (MessageItem *)obj1;
        MessageItem *second = (MessageItem *)obj2;
        long long mid1 = [first.content.mid longLongValue];
        long long mid2 = [second.content.mid longLongValue];
        NSString* clientSendID1 = first.client_send_id;
        NSString* clientSendID2 = second.client_send_id;
        if(mid1 == 0 && mid2 == 0){
            return [clientSendID1 compare:clientSendID2];
        }
        else{
            if(mid1 < mid2 || mid2 == 0){
                return NSOrderedAscending;
            }
            else if(mid1 > mid2 || mid1 == 0)
            {
                return NSOrderedDescending;
            }
            else
                return NSOrderedSame;
        }
        
    }];
    MessageItem *preItem = nil;
    for (MessageItem *messageItem in self.modelItemArray) {
        if(messageItem.content.ctime - preItem.content.ctime <= 60 * 3){
            messageItem.content.hideTime = YES;
        }
//        if([messageItem.content.timeStr isEqualToString:preItem.content.timeStr]){
//            messageItem.content.hideTime = YES;
//        }
        preItem = messageItem;
    }
}

- (BOOL)parseData:(NSDictionary *)data type:(RequestMessageType)type
{
    if(type == RequestMessageTypeLatest){
        if(self.firstRequestNewMessage){
            self.firstRequestNewMessage = NO;
        }
    }
    NSInteger originalNum = self.modelItemArray.count;
    NSArray *newMessageArray = [MessageItem nh_modelArrayWithJson:data[@"items"]];
    
    //获取原来消息列表别人发的最新的消息的id
    NSString *originalLatestID = nil;
    for (NSInteger i = self.modelItemArray.count - 1; i >=0; i--)
    {
        MessageItem *messageItem = self.modelItemArray[i];
        if(messageItem.from == UUMessageFromOther)
        {
            originalLatestID = messageItem.content.mid;
            break;
        }
    }
    BOOL add = NO;
    if(newMessageArray.count > 0){
        //添加到前面
        for (NSInteger i = newMessageArray.count - 1; i >= 0; i--) {
            MessageItem *messageItem = newMessageArray[i];
            
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where client_send_id = '%@'",[self tableName], messageItem.client_send_id];
            FMResultSet *rs = [self.database executeQuery:sql];
            if(![rs next]){
                add = YES;
                [self.modelItemArray addObject:messageItem];
                 sql = [NSString stringWithFormat:@"insert into %@ values(%@,'%@','%@','%@') ",[self tableName],messageItem.content.mid, messageItem.client_send_id, messageItem.content.text, [messageItem modelToJSONString]];
                [self.database executeUpdate:sql];
            }
        }
        
        if(add){
            [self sortMessage];
            if(type == RequestMessageTypeLatest && !self.firstRequestNewMessage){
                //有新消息，播放声音
                if([UserCenter sharedInstance].personalSetting.soundOn)
                    [ApplicationDelegate playSound];
                if([UserCenter sharedInstance].personalSetting.shakeOn)
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
        }
    }
    return type == RequestMessageTypeLatest && add;
}

- (BOOL)canInsert:(MessageItem *)messageItem
{
    for (MessageItem *item in self.modelItemArray)
    {
        if([item.content.mid isEqualToString:messageItem.content.mid])
            return NO;
        NSString *clientID = messageItem.client_send_id;
        if(clientID.length > 0 && ![clientID isEqualToString:@"0"] && [clientID isEqualToString:item.client_send_id])
            return NO;
    }
    return YES;
}

- (void)sendNewMessage:(MessageItem *)message{
    [self.modelItemArray addObject:message];
    [self sortMessage];
    NSString *sql = [NSString stringWithFormat:@"insert into %@ values(%@,'%@','%@','%@') ",[self tableName],message.content.mid, message.client_send_id, message.content.text, [message modelToJSONString]];
    [self.database executeUpdate:sql];
}

- (void)updateMessage:(MessageItem *)message{
    NSString *sql = [NSString stringWithFormat:@"update %@ set message_id = %@, client_send_id = '%@', message_json = '%@', content = '%@' where client_send_id = '%@'",[self tableName],message.content.mid, message.client_send_id, [message modelToJSONString], message.content.text,message.client_send_id];
    
    [self.database executeUpdate:sql];
    
    for (MessageItem *messageItem in self.modelItemArray) {
        if([message.content.mid isEqualToString:messageItem.content.mid] || [message.client_send_id isEqualToString:messageItem.client_send_id]){
            [self.modelItemArray replaceObjectAtIndex:[self.modelItemArray indexOfObject:messageItem] withObject:message];
            break;
        }
    }
    [self sortMessage];
}

- (void)deleteMessage:(MessageItem *)message{
    NSString *sql;
    if(message.content.mid.length > 0){
        sql = [NSString stringWithFormat:@"delete from %@ where message_id = %@ ",[self tableName],message.content.mid];
    }
    else{
        sql = [NSString stringWithFormat:@"delete from %@ where client_send_id = '%@' ",[self tableName],message.client_send_id];
    }
    
    BOOL success = [self.database executeUpdate:sql];
    if(success){
        NSLog(@"delete success");
    }
    for (MessageItem *messageItem in self.modelItemArray) {
        if([message.content.mid isEqualToString:messageItem.content.mid] || [message.client_send_id isEqualToString:messageItem.client_send_id]){
            [self.modelItemArray removeObject:messageItem];
            break;
        }
    }
}

@end

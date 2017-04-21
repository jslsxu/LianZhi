//
//  ChatMessageModel.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/20.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ChatMessageModel.h"
#import "NHFileManager.h"
#import "AudioManager.h"
@implementation UpdateItem


@end

@interface ChatMessageModel ()
@property (nonatomic, strong)NSMutableArray* modelItemArray;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, assign)ChatType type;
@property (nonatomic, strong)FMDatabase *database;
@property (nonatomic, strong)NSArray *updateArray;
@property (nonatomic, copy)NSString *lastMaxMid;
@end

@implementation ChatMessageModel

+ (void)removeConversasionForUid:(NSString *)uid type:(ChatType)chatType{
    NSString* chatPath = [[NHFileManager localCurrentUserConversationCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%zd",uid, chatType]];
    [NHFileManager removeItemAtPath:chatPath];
//    if([[NSFileManager defaultManager] fileExistsAtPath:chatPath]){
//        NSLog(@"chat path %@ exsits",chatPath);
//    }
//    NSError *error = nil;
//    [[NSFileManager defaultManager] removeItemAtPath:chatPath error:&error];
//    if(error){
//        NSLog(@"error is %@",error);
//    }
//    if([[NSFileManager defaultManager] fileExistsAtPath:chatPath]){
//        NSLog(@"chat exist");
//    }
}

- (void)clearChatRecord{
    @synchronized (self) {
        NSString *sql = [NSString stringWithFormat:@"delete FROM %@", [self tableName]];
        [_database executeUpdate:sql];
        [self.modelItemArray removeAllObjects];
        self.numOfNew = 0;
    }
}

- (void)dealloc{
    [_database close];
}
- (instancetype)initWithUid:(NSString *)uid type:(ChatType)type{
    self = [super init];
    if(self){
        self.uid = uid;
        self.type = type;
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

- (void)setTargetUser:(NSString *)targetUser{
    _targetUser = targetUser;
    for (MessageItem *messageItem in self.modelItemArray) {
        [messageItem setTargetUser:_targetUser];
    }
}

- (FMDatabase *)database{
    if(!_database){
        _database = [FMDatabase databaseWithPath:[self chatPath]];
        [_database open];
    }
    return _database;
}

- (NSInteger)loadOldData{
    NSString *sql = nil;
    FMResultSet *rs = nil;
    NSString *old_client_id = [self oldClientID];
    if(old_client_id.length == 0){
        sql = [NSString stringWithFormat:@"select * from %@ where message_id = 0",[self tableName]];//未发送成功的
    }
    else{
        sql = [NSString stringWithFormat:@"select * from %@ where message_id = 0 and client_send_id < %@",[self tableName], old_client_id];//未发送成功的
    }

    rs = [self.database executeQuery:sql];
    NSInteger loadCount = 0;
    while ([rs next]) {
        loadCount++;
        NSString *messageJson = [rs stringForColumn:@"message_json"];
        MessageItem *item = [MessageItem nh_modelWithJson:messageJson];
        if(item.messageStatus != MessageStatusSuccess){
            item.messageStatus = MessageStatusFailed;
        }
        [item setIsRead:YES];
        [item setTargetUser:self.targetUser];
        [self.modelItemArray addObject:item];
    }
    
    
    NSString *oldID = [self oldId];
    if(oldID.length > 0){
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE message_id < %zd and message_id > 0 order by message_id desc limit 20", [self tableName], [oldID integerValue]];
    }
    else{
        sql = [NSString stringWithFormat:@"select * from %@ where message_id > 0 order by message_id desc limit 20 ", [self tableName]];
    }
    rs = [self.database executeQuery:sql];
    while ([rs next]){
        loadCount ++;
        NSString *messageJson = [rs stringForColumn:@"message_json"];
        MessageItem *item = [MessageItem nh_modelWithJson:messageJson];
        if(item.messageStatus != MessageStatusSuccess){
            item.messageStatus = MessageStatusFailed;
        }
        [item setIsRead:YES];
        [item setTargetUser:self.targetUser];
        [self.modelItemArray addObject:item];
    }
    if(loadCount > 0){
        [self sortMessage];
    }
    return loadCount;
}

- (NSMutableArray *)modelItemArray{
    if(!_modelItemArray){
        _modelItemArray = [NSMutableArray array];
    }
    return _modelItemArray;
}

- (NSArray *)searchMessageWithKeyword:(NSString *)keyword from:(NSInteger)from{
    if(keyword.length == 0)
        return nil;
    NSMutableArray* searchResultArray = [NSMutableArray array];
    NSString *sql = nil;
    FMResultSet *rs = nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE content like '%%%@%%' order by message_id desc limit %zd,20", [self tableName], keyword, from];
    rs = [self.database executeQuery:sql];
    while ([rs next]) {
        NSString *messageJson = [rs stringForColumn:@"message_json"];
        MessageItem *item = [MessageItem nh_modelWithJson:messageJson];
        [searchResultArray addObject:item];
    }
    return searchResultArray;
}

- (void)loadForSearchItem:(NSString *)mid{
    NSMutableArray* searchResultArray = [NSMutableArray array];
    NSString *sql = nil;
    FMResultSet *rs = nil;
    NSString *oldID = [self oldId];
    if(oldID.length > 0)
    {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE message_id >= %zd and message_id < %zd", [self tableName], [mid integerValue], [oldID integerValue]];
    }
    else{
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE message_id >= %zd", [self tableName], [mid integerValue]];
    }
    rs = [self.database executeQuery:sql];
    while ([rs next]) {
        NSString *messageJson = [rs stringForColumn:@"message_json"];
        MessageItem *item = [MessageItem nh_modelWithJson:messageJson];
        [searchResultArray addObject:item];
    }
    [self.modelItemArray addObjectsFromArray:searchResultArray];
    [self sortMessage];
}

- (NSString *)tableName{
    return [NSString stringWithFormat:@"conversation_%@_%zd",self.uid, self.type];
}

- (NSString *)chatPath{
    NSString* chatPath = [[NHFileManager localCurrentUserConversationCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%zd",self.uid, self.type]];
    return chatPath;
}

- (NSString *)latestId{
    if(self.lastMaxMid.length > 0){
        return self.lastMaxMid;
    }
    else{
        NSString *mid = nil;
        for (NSInteger i = self.modelItemArray.count - 1; i >= 0; i--) {
            MessageItem *item = self.modelItemArray[i];
            if(item.content.uniqueId.length > 0 ){
                NSString *curMid = item.content.uniqueId;
                if(curMid.integerValue > mid.integerValue){
                    mid = curMid;
                }
            }
        }
        return mid;
    }
}

- (NSString *)oldId{
    for (NSInteger i = 0; i < self.modelItemArray.count; i++) {
        MessageItem *item = self.modelItemArray[i];
        if(item.content.mid.length > 0)
            return item.content.mid;
    }
    return nil;
}

- (NSString *)oldClientID{
    for (NSInteger i = 0; i < self.modelItemArray.count; i++) {
        MessageItem *item = self.modelItemArray[i];
        if(item.content.mid.length == 0)
            return item.client_send_id;
    }
    return nil;
}

- (NSInteger)checkStatusTime{
    NSInteger time = 0;
    if(self.updateArray.count > 0){
        for (UpdateItem *updateTime in self.updateArray) {
            if([self.updateArray indexOfObject:updateTime] == 0){
                time = updateTime.ctime;
            }
            else{
                if(updateTime.ctime > time){
                    time = updateTime.ctime;
                }
            }
        }
    }
    else{
        if(self.modelItemArray.count > 0){
            for (NSInteger i = self.modelItemArray.count - 1; i >= 0; i--) {
                MessageItem *item = self.modelItemArray[i];
                if(item.content.mid.length > 0)
                    time = item.content.ctime;
            }
        }
        else{
            time = [[NSDate date] timeIntervalSince1970];
        }
    }
    return time;
}

- (void)sortMessage{
    @synchronized (self) {
        [self.modelItemArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            MessageItem *first = (MessageItem *)obj1;
            MessageItem *second = (MessageItem *)obj2;
            NSInteger mid1 = [first.content.mid integerValue];
            if(mid1 == 0)
                mid1 = NSIntegerMax;
            NSInteger mid2 = [second.content.mid integerValue];
            if(mid2 == 0){
                mid2 = NSIntegerMax;
            }
            NSString* clientSendID1 = first.client_send_id;
            NSString* clientSendID2 = second.client_send_id;
            if(mid1 == mid2){
                return [clientSendID1 compare:clientSendID2];
            }
            else{
                if(mid1 < mid2){
                    return NSOrderedAscending;
                }
                else {
                    return NSOrderedDescending;
                }
            }
            
        }];
        MessageItem *preItem = nil;
        for (MessageItem *messageItem in self.modelItemArray) {
            if(messageItem.content.ctime - preItem.content.ctime <= 60 * 3){
                messageItem.content.hideTime = YES;
            }
            preItem = messageItem;
        }

    }
}

- (BOOL)parseData:(NSDictionary *)data type:(RequestMessageType)type
{
    NSInteger originalNum = self.modelItemArray.count;
    NSArray *newMessageArray = [MessageItem nh_modelArrayWithJson:data[@"items"]];
    
    NSArray *updateArray = [UpdateItem nh_modelArrayWithJson:data[@"revoke"]];
    if(updateArray.count > 0){
        [self setUpdateArray:updateArray];
    }
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
    NSInteger addNum = 0;
    if(newMessageArray.count > 0){
        NSString *newMid = nil;
        //添加到前面
        for (NSInteger i = newMessageArray.count - 1; i >= 0; i--) {
            MessageItem *messageItem = newMessageArray[i];
            if(!messageItem.isRead && [messageItem.content.exinfo.voice.audioUrl length] > 0){
                [[AudioManager sharedInstance] addAudioUrl:messageItem.content.exinfo.voice.audioUrl];
            }
            if(messageItem.content.uniqueId.integerValue > newMid.integerValue){
                newMid = messageItem.content.uniqueId;
            }
            [messageItem setTargetUser:self.targetUser];
            //判断是否已存在，存在则更新，不存在则添加
            NSString *sql = nil;
            if(messageItem.client_send_id.length > 0){
                sql = [NSString stringWithFormat:@"select * from %@ where client_send_id = '%@'",[self tableName], messageItem.client_send_id];
            }
            else{
                sql = [NSString stringWithFormat:@"select * from %@ where message_id = %zd",[self tableName], [messageItem.content.mid integerValue]];
            }
            
            FMResultSet *rs = [self.database executeQuery:sql];
            if(![rs next]){//不存在
                addNum++;
                [self.modelItemArray addObject:messageItem];
                sql = [NSString stringWithFormat:@"insert into %@ values(%zd,'%@','%@','%@') ",[self tableName],[messageItem.content.mid integerValue], messageItem.client_send_id, messageItem.content.text, [messageItem modelToJSONString]];
                [self.database executeUpdate:sql];
            }
            else{
                [self updateMessage:messageItem];
            }

            
        }
//        NSLog(@"%@",midStr);
        if(newMid.integerValue > self.lastMaxMid.integerValue && type == RequestMessageTypeLatest){
            self.lastMaxMid = newMid;
        }
        
        if(addNum > 0){
            [self sortMessage];
            if(type == RequestMessageTypeLatest && originalNum > 0){
                //有新消息，播放声音
                if([UserCenter sharedInstance].personalSetting.soundOn)
                    [ApplicationDelegate playSound];
                if([UserCenter sharedInstance].personalSetting.shakeOn)
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
        }
    }
    NSInteger updateCount = 0;
    if(updateArray.count > 0){
        
        for (UpdateItem *updateItem in updateArray) {
            for (MessageItem *item in self.modelItemArray) {
                if([updateItem.mid isEqualToString:item.content.mid]){
                    if(item.content.type != updateItem.mtype){
                        item.content.type = updateItem.mtype;
                        [self updateMessage:item];
                        updateCount ++;
                        break;
                    }
                }
            }
        }
    }
    
    return type == RequestMessageTypeLatest && (addNum + updateCount);
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
    @synchronized (self) {
        [self.modelItemArray addObject:message];
        [self sortMessage];
        NSString *sql = [NSString stringWithFormat:@"insert into %@ values(%zd,'%@','%@','%@') ",[self tableName],[message.content.mid integerValue], message.client_send_id, message.content.text, [message modelToJSONString]];
        [self.database executeUpdate:sql];
//        if(insert){
//            NSLog(@"insert success");
//        }
    }
}

- (void)updateMessage:(MessageItem *)message{
    @synchronized (self) {
        NSString *sql = nil;
        if(message.client_send_id.length > 0){
            sql = [NSString stringWithFormat:@"update %@ set message_id = %zd, client_send_id = '%@', message_json = '%@', content = '%@' where client_send_id = '%@'",[self tableName],[message.content.mid integerValue], message.client_send_id, [message modelToJSONString], message.content.text,message.client_send_id];
        }
        else{
            sql = [NSString stringWithFormat:@"update %@ set message_id = %zd, client_send_id = '%@', message_json = '%@', content = '%@' where message_id = %zd",[self tableName],[message.content.mid integerValue], message.client_send_id, [message modelToJSONString], message.content.text,[message.content.mid integerValue]];
        }

        
        [self.database executeUpdate:sql];
//        if(success){
//            NSLog(@"update success");
//        }
//        BOOL replaced = NO;
        for (MessageItem *messageItem in self.modelItemArray) {
            BOOL isSame = NO;
            if(messageItem.client_send_id.length > 0 && message.client_send_id.length > 0){
                isSame = [messageItem.client_send_id isEqualToString:message.client_send_id];
            }
            else{
                isSame = [messageItem.content.mid isEqualToString:message.content.mid];
            }

            if(isSame){
//                replaced = YES;
                NSInteger index = [self.modelItemArray indexOfObject:messageItem];
                [self.modelItemArray removeObjectAtIndex:index];
                [self.modelItemArray insertObject:message atIndex:index];
                break;
            }
        }
//        if(!replaced){
//            [self.modelItemArray addObject:message];
//        }
        [self sortMessage];
    }
}

- (void)deleteMessage:(MessageItem *)message{
    @synchronized (self) {
        NSString *sql;
        if(message.content.mid.length > 0){
            sql = [NSString stringWithFormat:@"delete from %@ where message_id = %zd ",[self tableName],[message.content.mid integerValue]];
        }
        else{
            sql = [NSString stringWithFormat:@"delete from %@ where client_send_id = '%@' ",[self tableName],message.client_send_id];
        }
        
        [self.database executeUpdate:sql];
//        if(success){
//            NSLog(@"delete success");
//        }
        for (MessageItem *messageItem in self.modelItemArray) {
            if([message.content.mid isEqualToString:messageItem.content.mid] || [message.client_send_id isEqualToString:messageItem.client_send_id]){
                [self.modelItemArray removeObject:messageItem];
                break;
            }
        }
    }
}

@end

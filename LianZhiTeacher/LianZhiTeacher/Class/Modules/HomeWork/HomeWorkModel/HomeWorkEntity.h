//
//  HomeWorkEntity.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "HomeworkItem.h"
#import "HomeworkExplainEntity.h"
@interface HomeWorkEntity : TNBaseObject
@property(nonatomic, copy)NSString*             clientID;
@property(nonatomic, copy)NSString*             hid;
@property(nonatomic, copy)NSString*             course_name;
@property(nonatomic, strong)NSArray*            targets;
@property(nonatomic, assign)BOOL                sendSms;
@property(nonatomic, assign)BOOL                reply_close;    //作业回复截止时间
@property(nonatomic, copy)NSString*             reply_close_ctime;//    作业回复截止时间
@property(nonatomic, copy)NSString*             words;
@property(nonatomic, assign)BOOL                etype;              //是否可以恢复
@property(nonatomic, assign)NSInteger           count;
@property(nonatomic, assign)NSString*           createTime;
@property(nonatomic, assign)NSInteger           sent_num;
@property(nonatomic, assign)NSInteger           reply_num;
@property(nonatomic, assign)NSInteger           read_num;    //批阅数
@property(nonatomic, strong)NSMutableArray*     voiceArray;
@property(nonatomic, strong)NSMutableArray*     imageArray;
@property(nonatomic, strong)HomeworkExplainEntity*  explainEntity;
@property(nonatomic, strong)UserInfo*           authorUser;
@property(nonatomic, assign)CGFloat             uploadProgress;
//+ (HomeWorkEntity *)sendEntityWithNotification:(NotificationItem *)notification;
- (void)updateClientID;
- (NSInteger)maxCommentWordsNum;
- (void)removeTarget:(ClassInfo *)classInfo;
- (BOOL)hasImage;
- (BOOL)hasAudio;
- (void)sendWithProgress:(void (^)(CGFloat progress))progress success:(void (^)(HomeworkItem *homework))success fail:(void (^)())fail;
- (void)cancelSend;
- (BOOL)isSame:(HomeWorkEntity *)object;
@end

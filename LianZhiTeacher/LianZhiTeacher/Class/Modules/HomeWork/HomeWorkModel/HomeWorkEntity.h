//
//  HomeWorkEntity.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@interface HomeWorkEntity : TNBaseObject
@property(nonatomic, copy)NSString*             clientID;
@property(nonatomic, strong)NSMutableArray*     classArray;
@property(nonatomic, strong)NSMutableArray*     groupArray;
@property(nonatomic, copy)NSString*             words;
@property(nonatomic, assign)BOOL                openHomeworkCommit;
@property(nonatomic, assign)NSInteger           createTime;
@property(nonatomic, strong)NSMutableArray*     voiceArray;
@property(nonatomic, strong)NSMutableArray*     imageArray;
@property(nonatomic, strong)NSMutableArray*     videoArray;
@property(nonatomic, strong)UserInfo*           authorUser;
@property(nonatomic, assign)CGFloat             uploadProgress;
//+ (HomeWorkEntity *)sendEntityWithNotification:(NotificationItem *)notification;
- (void)updateClientID;
- (NSInteger)maxCommentWordsNum;
- (NSMutableArray *)targets;
- (void)removeTarget:(UserInfo *)userInfo;
- (BOOL)hasVideo;
- (BOOL)hasImage;
- (BOOL)hasAudio;
- (void)sendWithProgress:(void (^)(CGFloat progress))progress success:(void (^)(NotificationItem *notification))success fail:(void (^)())fail;
- (void)cancelSend;
- (BOOL)isSame:(HomeWorkEntity *)object;
@end

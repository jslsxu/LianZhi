//
//  NotificationItem.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "VideoItem.h"
@interface NotificationItem : TNBaseObject
@property (nonatomic, copy)NSString *nid;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, assign)BOOL is_sent;          //是否已发送
@property (nonatomic, assign)BOOL sms;              //是否发短信
@property (nonatomic, assign)NSInteger sent_num;
@property (nonatomic, assign)NSInteger read_num;
@property (nonatomic, copy)UserInfo*    user;
@property (nonatomic, copy)NSString *created_time;
@property (nonatomic, strong)AudioItem* voice;
@property (nonatomic, strong)NSArray<PhotoItem*> *pictures;
@property (nonatomic, strong)VideoItem* video;
@property (nonatomic, strong)NSArray<ClassInfo *>* classes;
@property (nonatomic, strong)NSArray<TeacherGroup*>* groups;
- (BOOL)hasImage;
- (BOOL)hasAudio;
- (BOOL)hasVideo;
- (NSArray *)targetArray;
+ (NotificationItem *)convertFromMessageItem:(MessageDetailItem *)messageItem;
@end

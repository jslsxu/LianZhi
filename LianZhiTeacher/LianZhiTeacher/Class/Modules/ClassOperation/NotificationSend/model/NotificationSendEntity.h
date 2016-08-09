//
//  NotificationSendEntity.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "MessageDetailModel.h"
@interface NotificationSendEntity : TNBaseObject
@property(nonatomic, strong)NSMutableArray*     classArray;
@property(nonatomic, strong)NSMutableArray*     groupArray;
@property(nonatomic, strong)NSMutableArray*     targets;
@property(nonatomic, copy)NSString*             content;
@property(nonatomic, assign)BOOL sendSms;
@property(nonatomic, strong)NSDate*             sendSmsDate;
@property(nonatomic, assign)NSString*           timeStr;
@property(nonatomic, strong)NSMutableArray*     voiceArray;
@property(nonatomic, strong)NSMutableArray*     imageArray;
@property(nonatomic, strong)NSMutableArray*     videoArray;
@property(nonatomic, strong)UserInfo*           authorUser;
- (void)removeTarget:(UserInfo *)userInfo;
- (instancetype)initWithMessageDetailItem:(MessageDetailItem *)detailItem;
@end

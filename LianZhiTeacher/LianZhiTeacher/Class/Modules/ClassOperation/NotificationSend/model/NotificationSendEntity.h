//
//  NotificationSendEntity.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@interface NotificationSendEntity : TNBaseObject
@property(nonatomic, strong)NSMutableArray*     targets;
@property(nonatomic, assign)BOOL sendSms;
@property(nonatomic, strong)NSDate*     date;
@property(nonatomic, strong)NSMutableArray*     voiceArray;
@property(nonatomic, strong)NSMutableArray*     imageArray;
@end

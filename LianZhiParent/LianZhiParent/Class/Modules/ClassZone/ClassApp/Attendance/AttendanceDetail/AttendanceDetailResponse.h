//
//  AttendanceDetailResponse.h
//  LianZhiParent
//
//  Created by jslsxu on 17/1/10.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@interface AttendanceNoteItem : TNBaseObject
@property (nonatomic, copy)NSString* ctime;
@property (nonatomic, copy)NSString* recode;
@end

@interface AttendanceInfo : TNBaseObject
@property (nonatomic, assign)NSInteger absence;
@property (nonatomic, assign)NSInteger attendance;
@property (nonatomic, copy)NSString* absence_rate;
@property (nonatomic, copy)NSString* attendance_rate;
@end

@interface AttendanceDetailResponse : TNBaseObject
@property (nonatomic, strong)NSArray* recode;
@property (nonatomic, strong)AttendanceInfo *info;
@end

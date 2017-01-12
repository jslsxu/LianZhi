//
//  AttendanceNotificationListModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/1/12.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "AttendanceNotificationItem.h"
@interface AttendanceNotificationListModel : TNListModel
@property (nonatomic, assign)BOOL has_next;
@property (nonatomic, copy)NSString *minID;
@end

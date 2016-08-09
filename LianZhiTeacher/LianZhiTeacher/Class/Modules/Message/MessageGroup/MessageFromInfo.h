//
//  MessageFromInfo.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/8.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "MessageItem.h"
@interface MessageFromInfo : TNModelItem
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *label;
@property (nonatomic, copy)NSString *logoUrl;
@property (nonatomic, assign)ChatType type;
@property (nonatomic, strong)UIImage *logoImage;
@property (nonatomic, copy)NSString *typeName;
@property (nonatomic, copy)NSString *from_obj_id;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, copy)NSString *childID;
- (BOOL)isNotification;
@end

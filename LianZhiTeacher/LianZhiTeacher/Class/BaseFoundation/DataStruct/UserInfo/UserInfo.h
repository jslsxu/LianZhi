//
//  UserInfo.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"
@interface UserInfo : TNModelItem<NSCoding>
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *label;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, copy)NSString *constellation;
@property (nonatomic, assign)NSInteger gender;
@property (nonatomic, copy)NSString *birthDay;
@property (nonatomic, copy)NSString *email;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, copy)NSString *shortIndex;
@property (nonatomic, assign)BOOL activited;
@end


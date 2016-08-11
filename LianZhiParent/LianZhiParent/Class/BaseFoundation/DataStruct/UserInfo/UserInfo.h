//
//  UserInfo.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"
@interface UserInfo : TNModelItem
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *label;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *nick;
@property (nonatomic, copy)NSString *constellation;
@property (nonatomic, assign)NSInteger sex;
@property (nonatomic, copy)NSString *birthday;
@property (nonatomic, copy)NSString *email;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *avatar;
@property (nonatomic, copy)NSString *first_letter;
@property (nonatomic, assign)BOOL actived;
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, copy)NSString *blid;
@end


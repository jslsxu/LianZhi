//
//  ContactModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "SchoolInfo.h"

@interface ContactGroup : NSObject
@property (nonatomic, copy)NSString *key;
@property (nonatomic, strong)NSMutableArray *contacts;

@end

@interface ContactModel : NSObject
@property (nonatomic, strong)NSMutableArray *classes;
@property (nonatomic, strong)NSMutableArray *teachers;
- (void)refresh;
- (NSArray *)classKeys;
- (NSArray *)teacherKeys;
@end

//
//  TNBaseObject.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/4.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/NSObject+YYModel.h>
@interface TNBaseObject : NSObject<NSCoding, NSCopying, YYModel>
+ (NSArray *)nh_modelArrayWithJson:(id)json;

+ (instancetype)nh_modelWithJson:(id)json;
@end

//
//  Param+Util.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/12/6.
//  Copyright © 2016年 jslsxu. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ParamUtil : NSObject

@property (nonatomic, strong)ClassInfo *classInfo;

+ (instancetype)sharedInstance;
- (NSMutableDictionary *)getParam;
@end



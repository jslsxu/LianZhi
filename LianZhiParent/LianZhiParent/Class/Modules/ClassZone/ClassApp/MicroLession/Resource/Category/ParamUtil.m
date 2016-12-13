//
//  Param+Util.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/12/6.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ParamUtil.h"

@implementation ParamUtil

// 声明一个全局对象
static id _instance;

// 实现创建单例对象的类方法
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    
    /**
     dispatch_once  一次性执行
     它是安全的，系统已经自动帮我们加了锁，所以在多个线程抢夺同一资源的时候，也是安全的
     */
    
    dispatch_once(&onceToken, ^{
        NSLog(@"---once---");
        
        // 这里也会调用到 allocWithZone 方法
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (NSMutableDictionary *)getParam
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *childId = [UserCenter sharedInstance].curChild.uid;
    
    NSString *class_id =  self.classInfo.classID;
    NSString *school_id =  self.classInfo.school.schoolID;
    
    [params setValue:childId forKey:@"child_id"];
    [params setValue:class_id forKey:@"class_id"];
    [params setValue:school_id forKey:@"school_id"];
    
    return params;

}

@end

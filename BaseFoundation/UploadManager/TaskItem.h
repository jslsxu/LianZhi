//
//  TaskItem.h
//  LianZhiParent
//
//  Created by jslsxu on 15/3/25.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kTaskCacheDirectory                     @"TaskCache"

extern NSString *const kTaskItemSuccessNotification;
@interface TaskItem : NSObject<NSCoding>
@property (nonatomic, copy)NSString *filePath;                  //本地路径
@property (nonatomic, copy)NSString *targetUrl;                 //上传URL
@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, strong)NSDictionary *images;
@property (nonatomic, weak)NSURLSessionDataTask *uploadTask;    //上传的任务
- (void)startUpload;
@end

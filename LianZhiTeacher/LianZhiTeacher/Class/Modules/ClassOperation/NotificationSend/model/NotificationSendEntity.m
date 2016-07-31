//
//  NotificationSendEntity.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSendEntity.h"

@implementation NotificationSendEntity
- (instancetype)init{
    self = [super init];
    if(self){
        self.targets = [NSMutableArray array];
        self.voiceArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
    }
    return self;
}
@end

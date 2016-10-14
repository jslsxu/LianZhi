//
//  HomeworkExplainEntity.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkExplainEntity.h"

@implementation HomeworkExplainEntity

- (instancetype)init{
    self = [super init];
    if(self){
        self.voiceArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        self.videoArray = [NSMutableArray array];
    }
    return self;
}
@end

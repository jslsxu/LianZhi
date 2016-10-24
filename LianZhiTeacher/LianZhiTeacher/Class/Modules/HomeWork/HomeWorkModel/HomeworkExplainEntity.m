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
    }
    return self;
}

+ (HomeworkExplainEntity *)explainEntityFromAnswer:(HomeworkItemAnswer *)answer{
    HomeworkExplainEntity *explainEntity = [[HomeworkExplainEntity alloc] init];
    explainEntity.words = answer.words;
    if([answer.pics count] > 0){
        [explainEntity.imageArray addObjectsFromArray:answer.pics];
    }
    if(answer.voice){
         [explainEntity.voiceArray addObject:answer.voice];
    }
    return explainEntity;
}
@end

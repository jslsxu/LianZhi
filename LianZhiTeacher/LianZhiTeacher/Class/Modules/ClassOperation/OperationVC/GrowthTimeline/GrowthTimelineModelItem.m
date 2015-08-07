//
//  GrowthTimelineModelItem.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/19.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "GrowthTimelineModelItem.h"

@implementation GrowthTimelineModelItem
- (id)init
{
    self = [super init];
    if(self)
    {
        self.stoolNum = 0;
        self.emotion = @"高兴";
        self.temprature = @"正常";
        self.water = 8;
        self.sleep = 2;
        
    }
    return self;
}

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.growthID = [dataWrapper getStringForKey:@"id"];
    self.stoolNum = [dataWrapper getIntegerForKey:@"stool_num"];
    self.emotion = [dataWrapper getStringForKey:@"mood"];
    self.temprature = [dataWrapper getStringForKey:@"temperature"];
    self.water = [dataWrapper getIntegerForKey:@"water"];
    self.sleep = [dataWrapper getFloatForKey:@"sleep"];
    self.comment = [dataWrapper getStringForKey:@"words"];
    self.hasSent = YES;
    TNDataWrapper *studentWrapper = [dataWrapper getDataWrapperForKey:@"student"];
    if(studentWrapper.count > 0)
    {
        StudentInfo *studentInfo = [[StudentInfo alloc] init];
        [studentInfo parseData:studentWrapper];
        [self setStudentInfo:studentInfo];
    }
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.studentInfo.uid forKey:@"student_id"];
    [dic setValue:self.emotion forKey:@"mood"];
    [dic setValue:kStringFromValue(self.stoolNum) forKey:@"stool_num"];
    [dic setValue:self.temprature forKey:@"temperature"];
    [dic setValue:[NSString stringWithFormat:@"%ld",(long)self.water] forKey:@"water"];
    [dic setValue:[NSString stringWithFormat:@"%.1f",self.sleep] forKey:@"sleep"];
    [dic setValue:self.comment forKey:@"words"];
    return dic;
}
@end

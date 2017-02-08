//
//  GrowthClassListModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/6.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "GrowthClassListModel.h"

@implementation GrowthStudentInfo
- (instancetype)init{
    self = [super init];
    if(self){
        self.uid = kStringFromValue(arc4random() % 1000);
        self.avatar = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=895009738,1542646259&fm=116&gp=0.jpg";
        self.status = arc4random() % GrowthStatusNum;
    }
    return self;
}
@end

@implementation GrowthClassInfo

- (instancetype)init{
    self = [super init];
    if(self){
        self.name = @"16级2班";
        self.logo = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=895009738,1542646259&fm=116&gp=0.jpg";
        NSMutableArray* students = [NSMutableArray array];
        for (NSInteger i = 0; i < 35; i++) {
            GrowthStudentInfo* student = [[GrowthStudentInfo alloc] init];
            [student setName:[NSString stringWithFormat:@"学生%zd", i]];
            [students addObject:student];
        }
        [self setStudents:students];
    }
    return self;
}

- (BOOL)hasNew{
    return YES;
}
@end

@implementation GrowthClassListModel
- (instancetype)init{
    self = [super init];
    if(self){
        for (NSInteger i = 0; i < 10; i++) {
            GrowthClassInfo* classInfo = [[GrowthClassInfo alloc] init];
            [self.modelItemArray addObject:classInfo];
        }
    }
    return self;
}
@end

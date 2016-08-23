//
//  ChildInfo.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ChildInfo.h"
@implementation SchoolInfo

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

+ (NSDictionary <NSString *, id> *)modelCustomPropertyMapper{
    return @{@"schoolID" : @"id", @"schoolName" : @"name",
             @"classIMEnaled" : @"enabled_class_im"};
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.schoolID = [aDecoder decodeObjectForKey:@"id"];
        self.schoolName = [aDecoder decodeObjectForKey:@"name"];
        self.logo = [aDecoder decodeObjectForKey:@"logo"];
        if([aDecoder containsValueForKey:@"enabled_class_im"])
            self.classIMEnaled = [aDecoder decodeBoolForKey:@"enabled_class_im"];
        else
            self.classIMEnaled = YES;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.schoolID forKey:@"id"];
    [aCoder encodeObject:self.schoolName forKey:@"name"];
    [aCoder encodeObject:self.logo forKey:@"logo"];
    [aCoder encodeBool:self.classIMEnaled forKey:@"enabled_class_im"];
}
@end

@implementation TeacherInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

@end

@implementation ClassInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"students" : [ChildInfo class],
             @"teachers" : [TeacherInfo class],
             @"school" : [SchoolInfo class]};
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"classID" : @"id"};
}

@end

@implementation FamilyInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

@end


@implementation ChildInfo
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"classes" : [ClassInfo class],
             @"family" : [FamilyInfo class],
             };
}

@end

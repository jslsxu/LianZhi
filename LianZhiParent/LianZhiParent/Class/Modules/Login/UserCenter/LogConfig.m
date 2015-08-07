//
//  LogConfig.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "LogConfig.h"

@implementation SubTag
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.tagID = [dataWrapper getStringForKey:@"id"];
    self.tagName = [dataWrapper getStringForKey:@"name"];
    self.content = [dataWrapper getIntegerForKey:@"content"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.tagID = [aDecoder decodeObjectForKey:@"id"];
        self.tagName = [aDecoder decodeObjectForKey:@"name"];
        self.content = [aDecoder decodeIntegerForKey:@"content"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:self.tagID forKey:@"id"];
    [aCoder encodeObject:self.tagName forKey:@"name"];
    [aCoder encodeInteger:self.content forKey:@"content"];
}

@end

@implementation TagGroup
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.groupID = [dataWrapper getStringForKey:@"id"];
    self.groupName = [dataWrapper getStringForKey:@"name"];
    
    TNDataWrapper *tagsWrapper = [dataWrapper getDataWrapperForKey:@"sub_tags"];
    if(tagsWrapper.count > 0)
    {
        NSMutableArray *subtags = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < tagsWrapper.count; i++) {
            TNDataWrapper *tagWrapper = [tagsWrapper getDataWrapperForIndex:i];
            SubTag *subtag = [[SubTag alloc] init];
            [subtag parseData:tagWrapper];
            [subtags addObject:subtag];
        }
        [self setSubTags:subtags];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.groupID = [aDecoder decodeObjectForKey:@"id"];
        self.groupName = [aDecoder decodeObjectForKey:@"name"];
        self.subTags = [aDecoder decodeObjectForKey:@"sub_tags"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.groupID forKey:@"id"];
    [aCoder encodeObject:self.groupName forKey:@"name"];
    [aCoder encodeObject:self.subTags forKey:@"sub_tags"];
}

@end
@implementation LogConfig
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.dicoveryUrl = [dataWrapper getStringForKey:@"find_url"];
    self.introUrl = [dataWrapper getStringForKey:@"intro_url"];
    self.aboutUrl = [dataWrapper getStringForKey:@"about_url"];
    TNDataWrapper *groupWrapper = [dataWrapper getDataWrapperForKey:@"tags"];
    if(groupWrapper.count > 0)
    {
        NSMutableArray *groupArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger i = 0; i < groupWrapper.count; i++) {
            TagGroup *group = [[TagGroup alloc] init];
            TNDataWrapper *itemWrapper = [groupWrapper getDataWrapperForIndex:i];
            [group parseData:itemWrapper];
            [groupArray addObject:group];
        }
        [self setTags:groupArray];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.dicoveryUrl = [aDecoder decodeObjectForKey:@"find_url"];
        self.introUrl = [aDecoder decodeObjectForKey:@"intro_url"];
        self.aboutUrl = [aDecoder decodeObjectForKey:@"about_url"];
        self.tags = [aDecoder decodeObjectForKey:@"tags"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.dicoveryUrl forKey:@"find_url" ];
    [aCoder encodeObject:self.introUrl forKey:@"intro_url"];
    [aCoder encodeObject:self.aboutUrl forKey:@"about_url"];
    [aCoder encodeObject:self.tags forKey:@"tags"];
}

- (NSArray *)tagForPrivilege:(TagPrivilege)privilege
{
    NSMutableArray *tagArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (TagGroup *group in self.tags) {
        NSMutableArray *subTagArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (SubTag *subTag in group.subTags) {
            if(subTag.content & privilege)
            {
                [subTagArray addObject:subTag];
            }
        }
        if(subTagArray.count > 0)
        {
            TagGroup *tagGroup = [[TagGroup alloc] init];
            [tagGroup setGroupID:group.groupID];
            [tagGroup setGroupName:group.groupName];
            [tagGroup setSubTags:subTagArray];
            [tagArray addObject:tagGroup];
        }
    }
    if(tagArray.count > 0)
        return tagArray;
    return nil;
}
@end

//
//  LZSubjectModel.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LZSubjectModel.h"

@implementation LZSubjectList


@end


@implementation SkillItem


- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.skill_code = [dataWrapper getStringForKey:@"skill_code"];
    self.skill_name = [dataWrapper getStringForKey:@"skill_name"];
    
}

@end

@implementation LZSubjectModel

- (void)parseData:(TNDataWrapper *)dataWrapper  type:(REQUEST_TYPE)type
{
    
    TNDataWrapper *listWrapper = [dataWrapper getDataWrapperForKey:@"skills"];
    
    self.skills = [[TNListModel alloc]init];
    if(listWrapper.count > 0)
    {
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            SkillItem *item = [[SkillItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.skills.modelItemArray addObject:item];
        }
    }   
}

@end


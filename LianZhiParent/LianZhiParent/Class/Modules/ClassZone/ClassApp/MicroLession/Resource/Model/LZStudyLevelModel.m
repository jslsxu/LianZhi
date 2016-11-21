//
//  @"高手"  LZStudyLevelModel.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LZStudyLevelModel.h"

@implementation ScoreItem
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.name = [dataWrapper getStringForKey:@"name"];
    self.score = [dataWrapper getStringForKey:@"score"];
}

+ (LZStudyLevel)getStudyLevel:(float)score
{
    if (score >= 95){
        return LZStudyLevelPerfect;
    }
    else if (score >= 85)
    {
        return LZStudyLevelExcellent;
    }
    else if(score >= 75){
        return LZStudyLevelHigh;
    }
    else if( score >= 60){
        return LZStudyLevelNormal;
    }
    else{
        return LZStudyLevelLow;
    }
    
    
}
@end

@implementation SubjectItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{

    self.name = [dataWrapper getStringForKey:@"name"];
    self.hasRank = [dataWrapper getIntegerForKey:@"hasRank"];
    self.average = [dataWrapper getIntegerForKey:@"average"];
    TNDataWrapper *listWrapper = [dataWrapper getDataWrapperForKey:@"skills"];
    self.skills = [[TNListModel alloc]init];
    if(listWrapper.count > 0)
    {
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            ScoreItem *item = [[ScoreItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.skills.modelItemArray addObject:item];
        }
    }
    listWrapper = [dataWrapper getDataWrapperForKey:@"rankList"];
    self.rankList = [[TNListModel alloc]init];
    if(listWrapper.count > 0)
    {
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            ScoreItem *item = [[ScoreItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.rankList.modelItemArray addObject:item];
        }
    }
 
}

-(BOOL)checkHasSkillValue
{
    BOOL hasSkillValue = NO;
    
    for (NSInteger i = 0; i < self.skills.modelItemArray.count; i++) {
        ScoreItem *item = [[ScoreItem alloc] init];
        if([item.score integerValue] >0)
        {
            hasSkillValue = YES;
            break;
        }
    }
    
    return  hasSkillValue;
}

@end

@implementation AnalysisModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
   
    if(data.count > 0)
    {
        for (NSInteger i = 0; i < data.count; i++) {
            SubjectItem *item = [[SubjectItem alloc] init];
            TNDataWrapper *itemWrapper = [data getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.modelItemArray addObject:item];
        }
    }
    
    
    return parse;
}
@end



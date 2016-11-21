//
//  @"高手"  LZStudyLevelModel.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceDefine.h"


@interface ScoreItem : TNModelItem

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *score;
+ (LZStudyLevel)getStudyLevel:(float)score;

@end

@interface SubjectItem : TNModelItem

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSUInteger hasRank;
@property (nonatomic, assign)NSUInteger average;
@property (nonatomic, copy)TNListModel *skills;
@property (nonatomic, copy)TNListModel *rankList;

-(BOOL)checkHasSkillValue;
@end

@interface AnalysisModel : TNListModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type;
@end




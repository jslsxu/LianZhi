//
//  @"高手"  LZStudyLevelModel.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceDefine.h"


@interface QuestionItem : TNModelItem

@property (nonatomic, assign)NSUInteger star;
@property (nonatomic, copy)NSString *is_again;
@property (nonatomic, assign)ThroughTraining_Status status;
@property (nonatomic, copy)NSString *q_id;
@property (nonatomic, copy)NSString *sq_id;
@property (nonatomic, copy)NSString *chapter_name;
@property (nonatomic, assign)NSUInteger correctNum;
@property (nonatomic, assign)NSUInteger total;
@property (nonatomic, assign)NSUInteger qcount; //
- (void)parseData:(TNDataWrapper *)data;
@end


@interface QuestionsModel : TNModelItem
@property (nonatomic, copy)NSString *subjectCode;
@property (nonatomic, copy)NSString *gradeCode;
@property (nonatomic, copy)NSString *termCode;

@property (nonatomic, assign)NSUInteger totalQuestion;
@property (nonatomic, copy)TNListModel *qustionList;

- (void)parseData:(TNDataWrapper *)data;

@end




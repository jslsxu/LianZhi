//
//  LZQuestionsModel.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/11.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LZQuestionsModel.h"

@implementation QuestionItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.star = [dataWrapper getIntegerForKey:@"star"];
    self.status = [dataWrapper getIntegerForKey:@"status"];
    self.q_id = [dataWrapper getStringForKey:@"q_id"];
    self.is_again = [dataWrapper getStringForKey:@"is_again"];
    self.sq_id = [dataWrapper getStringForKey:@"sq_id"];
    self.chapter_name = [dataWrapper getStringForKey:@"chapter_name"];
    self.correctNum = [dataWrapper getIntegerForKey:@"correct_num"];
    self.total = [dataWrapper getIntegerForKey:@"total"];
    self.qcount = [dataWrapper getIntegerForKey:@"qcount"];
}


@end

@implementation QuestionsModel

- (void)parseData:(TNDataWrapper *)dataWrapper
{

    self.gradeCode = [dataWrapper getStringForKey:@"grade_code"];
    self.termCode = [dataWrapper getStringForKey:@"term_code"];
    self.subjectCode = [dataWrapper getStringForKey:@"subject_code"];
    self.totalQuestion = [dataWrapper getIntegerForKey:@"totalQuestion"];
    
    TNDataWrapper *listWrapper = [dataWrapper getDataWrapperForKey:@"qustionList"];
    
    self.qustionList = [[TNListModel alloc]init];
    if(listWrapper.count > 0)
    {
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            QuestionItem *item = [[QuestionItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper];
            [self.qustionList.modelItemArray addObject:item];
        }
    }

}

@end



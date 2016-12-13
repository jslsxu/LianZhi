//
//  LZTestModel.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/17.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "LZTestModel.h"
#import "ResourceDefine.h"

@implementation AnswerItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    
    NSString *trimmedString = [[dataWrapper getStringForKey:@"tag"] stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]]; // stri
    self.tag = trimmedString;
    self.name = [dataWrapper getStringForKey:@"name"];
}

@end

@implementation TestSubItem

- (void)parseData:(TNDataWrapper *)dataWrapper  TestType:(LZTestType)type
{

    
    self.s_id = [dataWrapper getIntegerForKey:@"s_id"];
    self.sa_id = [dataWrapper getIntegerForKey:@"sa_id"];
    self.index = [dataWrapper getIntegerForKey:@"index"];

    self.stem = [dataWrapper getStringForKey:@"stem"];
    self.answer = [dataWrapper getStringForKey:@"answer"];
    self.answerCount = [dataWrapper getIntegerForKey:@"answerCount"];
//    self.editAnswer = [NSMutableString string];
    self.userAnswer = [dataWrapper getStringForKey:@"useranswer"];
    self.is_correct = [dataWrapper getStringForKey:@"is_correct"];
    TNDataWrapper *listWrapper = [dataWrapper getDataWrapperForKey:@"option"];
    
    self.option = [[TNListModel alloc]init];
    
    if(type != LZTestFillInTheBlankType)
    {
        if(listWrapper.count > 0)
        {
            for (NSInteger i = 0; i < listWrapper.count; i++) {
                AnswerItem *item = [[AnswerItem alloc] init];
                TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
                [item parseData:itemWrapper];
                [self.option.modelItemArray addObject:item];
            }
        }
    }
    else
    {
        NSArray *optionArr = [self.answer componentsSeparatedByString:@"^"];
        
        for (NSInteger i = 0; i < optionArr.count; i++) {
            AnswerItem *item = [[AnswerItem alloc] init];
            item.tag = [NSString stringWithFormat:@"%ld",i+1];
            item.name = @"";
            [self.option.modelItemArray addObject:item];
        }
    }

//    self.option = [dataWrapper getStringForKey:@"option"];
    self.img_url = [dataWrapper getStringForKey:@"img_url"];
    AudioItem *item = [[AudioItem alloc] init];
    TNDataWrapper *audio = [dataWrapper getDataWrapperForKey:@"sound_url"];
    item.audioUrl = [audio getStringForKey:@"url"];
    item.timeSpan = [audio getIntegerForKey:@"second"];
    self.soundAudioItem = item;
    
}



@end

@implementation TestAddItem

- (void)parseData:(TNDataWrapper *)dataWrapper
{
    self.q_id = [dataWrapper getIntegerForKey:@"q_id"];

    self.grade_code = [dataWrapper getIntegerForKey:@"subject_code"];
    
    self.grade_code = [dataWrapper getIntegerForKey:@"grade_code"];
    
}

@end


@implementation TestItem

- (NSString *)getTypeString
{
    switch (self.et_code) {
        case LZTestSingleSelectType:
            return  @"单选";
        case LZTestMultiSelectTypType:
            return  @"多选";
        case LZTestFillInTheBlankType:
            return  @"填空";
        case LZTestReadingComprehensionType:
            return  @"阅读理解";
        default:
            return  @"完形填空";
            break;
    }
}

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];
    
    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];

    
    self.p_id = [data getIntegerForKey:@"p_id"];
    self.et_code = (LZTestType)([[data getStringForKey:@"et_code"] integerValue]);
    self.index = [data getIntegerForKey:@"index"];
    self.skill_code = [data getStringForKey:@"skill_code"];
    self.skill_name = [data getStringForKey:@"skill_name"];
    self.et_name = [data getStringForKey:@"et_name"];
    self.material = [data getStringForKey:@"material"];
    
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"praxis"];
    
    self.praxis = [[TNListModel alloc]init];
    if(listWrapper.count > 0)
    {
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            TestSubItem *item = [[TestSubItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper TestType:self.et_code];
            [self.praxis.modelItemArray addObject:item];
        }
    }
    
    return parse;
   
}


@end

@implementation LZTestModel

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type
{
    BOOL parse = [super parseData:data type:type];

    if(type == REQUEST_REFRESH)
        [self.modelItemArray removeAllObjects];
    
    
//    TestAddItem *addItem = [[TestAddItem alloc]init];
//    [addItem parseData:data];
//    
//    self.addItem = addItem;
//    self.totalQuestion = [data getIntegerForKey:@"totalQuestion"];
    self.q_id = [data getIntegerForKey:@"q_id"];
    self.grade_code = [data getIntegerForKey:@"grade_code"];
    self.subject_code = (LZTestType)([data getIntegerForKey:@"subject_code"]);
    self.star = [data getIntegerForKey:@"star"];
    self.sq_id = [data getStringForKey:@"sq_id"];
    self.qcount = [data getIntegerForKey:@"qcount"];
    TNDataWrapper *listWrapper = [data getDataWrapperForKey:@"praxisList"];
    
    self.praxisList = [[TNListModel alloc]init];
    if(listWrapper.count > 0)
    {
        for (NSInteger i = 0; i < listWrapper.count; i++) {
            TestItem *item = [[TestItem alloc] init];
            TNDataWrapper *itemWrapper = [listWrapper getDataWrapperForIndex:i];
            [item parseData:itemWrapper type:type];
            [self.praxisList.modelItemArray addObject:item];
        }
    }
    
    return parse;
  
}

-(BOOL)checkIsComplated
{
    BOOL  isCompleted = YES;
    for(TestItem *item in self.praxisList.modelItemArray)
    {
        if(item.et_code == LZTestFillInTheBlankType)
        {
            for(TestSubItem *subItem in item.praxis.modelItemArray){
                for(AnswerItem *answerItem in subItem.option.modelItemArray)
                {
                    if(answerItem.isChecked == NO){
                        isCompleted = NO;
                        return isCompleted;
                    }
                }
            }
        }
        else
        {
            for(TestSubItem *subItem in item.praxis.modelItemArray){
                if (!subItem.userAnswer || [subItem.userAnswer isEqualToString:@""])
                {
                    isCompleted = NO;
                    return isCompleted;
                }
            }
        }
        
    }
    
    return isCompleted;
}

-(BOOL)checkIsAllConrrect
{
    BOOL  isAllConrrect = YES;
    for(TestItem *item in self.praxisList.modelItemArray)
    {
        for(TestSubItem *subItem in item.praxis.modelItemArray){
            if (![subItem.is_correct isEqualToString:@"0"])
            {
                isAllConrrect = NO;
                break;
            }
        }
    }
    
    return isAllConrrect;
 
}

// 检查做题数
- (NSUInteger)checkHaveComplatedCount
{
    NSUInteger  isCompleted = 0;
    for(TestItem *item in self.praxisList.modelItemArray)
    {
        for(TestSubItem *subItem in item.praxis.modelItemArray){
            if (subItem.userAnswer && ![subItem.userAnswer isEqualToString:@""])
            {
                isCompleted ++;
            }
        }
    }
    
    return isCompleted;

}
@end

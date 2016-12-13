//
//  LZTestModel.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/17.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceDefine.h"

@interface AnswerItem : TNModelItem
@property (nonatomic, assign)BOOL isChecked;

@property (nonatomic, copy)NSString *tag;
@property (nonatomic, copy)NSString *name;

- (void)parseData:(TNDataWrapper *)data;
@end

@interface TestSubItem : TNModelItem

@property (nonatomic, assign) LZTestStatus status;
@property (nonatomic, assign)NSInteger s_id;
@property (nonatomic, assign)NSInteger sa_id;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, copy)NSString *stem;
@property (nonatomic, copy)NSString *answer;
@property (nonatomic, copy)NSString *userAnswer;
@property (nonatomic, copy)NSString *is_correct;
//@property (nonatomic, strong)NSMutableString *editAnswer;
@property (nonatomic, assign)NSInteger answerCount;
@property (nonatomic, copy)TNListModel *option;
@property (nonatomic, copy)NSString *img_url;
@property (nonatomic, copy)AudioItem *soundAudioItem;

- (void)parseData:(TNDataWrapper *)dataWrapper  TestType:(LZTestType)type;
@end

@interface TestItem : TNListModel

@property (nonatomic, assign)NSInteger p_id;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, copy)NSString * skill_code;
@property (nonatomic, copy)NSString * skill_name;
@property (nonatomic, copy)NSString * et_name;
@property (nonatomic, copy)NSString * material;
@property (nonatomic, assign)LZTestType et_code;
@property (nonatomic, copy)TNListModel *praxis;

- (NSString *)getTypeString;
- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type;
@end

@interface TestAddItem : TNModelItem

@property (nonatomic, assign)NSUInteger q_id;
@property (nonatomic, assign)NSUInteger subject_code;
@property (nonatomic, assign)NSUInteger grade_code;

- (void)parseData:(TNDataWrapper *)data;
@end

@interface LZTestModel : TNListModel
//@property (nonatomic, copy)TestAddItem *addItem;
@property (nonatomic, assign)float star1;
@property (nonatomic, assign) EditModel_Status isEditModel;
@property (nonatomic, assign)NSUInteger star;
@property (nonatomic, copy)  NSString * sq_id;
@property (nonatomic, assign)NSUInteger q_id;
@property (nonatomic, assign)NSUInteger qcount;
@property (nonatomic, assign)NSUInteger subject_code;
@property (nonatomic, assign)NSUInteger grade_code;
@property (nonatomic, copy)TNListModel *praxisList;

- (BOOL)parseData:(TNDataWrapper *)data type:(REQUEST_TYPE)type;
- (BOOL)checkIsComplated;
- (BOOL)checkIsAllConrrect;
- (NSUInteger)checkHaveComplatedCount;

@end

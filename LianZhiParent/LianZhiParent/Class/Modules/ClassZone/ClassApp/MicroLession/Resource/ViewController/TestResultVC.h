//
//  TestResultVC.m
//  LianZhiParent
//
//  Created by Chen Qi on 2016/10/9.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceDefine.h"

@class TestItem,LZTestModel,QuestionItem;

@protocol SelectAnswerDelegate <NSObject>
- (void)answerViewSelected:(TestItem *)item;

@end

@interface CourseResultItem : TNModelItem
@property (nonatomic, copy)NSString *courseID;
@property (nonatomic, copy)NSString *courseName;
@property (nonatomic, assign) int testId;
@property (nonatomic, assign) float score;
@property (nonatomic, assign) LZTestStatus status;
@end

@interface CourseResultListModel : TNListModel

@end

@interface CourseResultCell : TNCollectionViewCell
{
//    UIButton*        _resultBtn;
    UILabel *resultLabel;

}
@property (nonatomic, weak)id<SelectAnswerDelegate> selectDelegate;
@property (nonatomic, strong)TestItem *item;

- (void)setSubItem:(TNModelItem *)modelItem;
@end




@interface TestResultVC : TNBaseCollectionViewController<SelectAnswerDelegate>

@property (nonatomic, weak)UIViewController *rootVC;
@property (nonatomic, copy)LZTestModel *testResultitem;
@property (nonatomic, copy)QuestionItem *qItem;

@end

//
//  HeadLineView.h
//  LianzhiParent
//
//  Created by Chen qi on 15/11/12.
//  Copyright © 2016年 com.sjwy. All rights reserved.

#import <UIKit/UIKit.h>
#import "ResourceDefine.h"

@class QuestionItem;

@interface LZThrougnAlertView : UIView

@property(nonatomic,strong)QuestionItem * qItem;
@property(nonatomic,assign)NSInteger subjectCode;
@property(nonatomic,assign)ThroughTraining_Status status;
- (void)setItem:(QuestionItem *)quesionItem;
- (instancetype)initWithViewController:(UIViewController *)rViewController
                               Status:(ThroughTraining_Status)status;
- (void)setActionButtonEnable:(BOOL)enable;
@end

//
//  ResourceBaseVC.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceBaseVC.h"
#import "ResourceDefine.h"

@class AnswerItem;
// 排名Cell的布局
@interface AnswerCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, assign) LZTestType type;
@property (nonatomic, assign) EditModel_Status isEditModel;
//@property (nonatomic, copy) NSString *editAnswer;
@property (nonatomic, copy) NSString *userAnswer;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, strong) UIImageView *conrrectImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *answerTextLabel;
@property (nonatomic, strong) UITextField *answerTextTxtField;
@property (nonatomic, strong) UILabel *sepLabel;
@property (nonatomic, strong) AnswerItem *aItem;
@property (nonatomic, strong) void (^textEditedhandler)(NSString *text);
-(void)setAnswerItem:(AnswerItem *)aItem;
-(void)setCellStyle:(BOOL)selected;
@end

@class QuestionItem,LZTestModel;

@interface TestBaseVC : ResourceBaseVC   //Collection

@property (nonatomic, weak)   UIViewController *rootVC;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) LZQuestionType isAgain;
@property (nonatomic, strong) QuestionItem *qItem;
@property (nonatomic, assign) NSInteger subjectCode;
@property (nonatomic,copy)   LZTestModel *testModel;   //本页模型
@property (nonatomic,assign) EditModel_Status isEditModel;
- (void)toTestViewPage:(NSUInteger)index;
- (void)getTestData;
@end

//
//  CommonDefine.h
//  BaseFoundation
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#ifndef BaseFoundation_ResourceDefine_h
#define BaseFoundation_ResourceDefine_h



// 判断是否为iPhone 6/6s
#define iPhone6_6s ([[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f)
// 判断是否为iPhone 6Plus/6sPlus
#define IS_IPhone6Plus ([[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f)

//清除背景色
#define CLEARCOLOR [UIColor clearColor]
#define kViewPadding                     12
#define TitlePadding                     10


//颜色
#define JXColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define GrayLblColor        JXColor(0x5c, 0x5d, 0x5d, 1)
#define GreenLineColor      JXColor(0x02, 0xc9, 0x94, 1)
#define GreenLblColor       JXColor(0x00, 0xba, 0x88, 1)
#define RedResultColor      JXColor(0xfe, 0x64, 0x61, 1)
#define GreenResultColor    JXColor(0x9b, 0xdb, 0x20, 1)
#define SepLineColor        JXColor(0xcf, 0xcf, 0xcf, 1)
#define AnswerSepLineColor  JXColor(0xda, 0xda, 0xda, 1)
#define GrayColor           JXColor(0xbd, 0xbd, 0xbd, 1)
#define OrangeColor         JXColor(0xfb, 0x98, 0x38, 1)

#define NavibarColor        JXColor(0x00, 0xc9, 0x92, 1)
#define ClearColor          [UIColor clearColor]
#define WhiteColor          [UIColor whiteColor]
#define TrackBgColor                   JXColor(0xe6, 0xe6, 0xe6, 1)
#define LightGrayLblColor              JXColor(0x8c, 0x8c, 0x8c, 1)
#define RedResultInstructionColor      JXColor(0xf9, 0x7c, 0x7c, 1)
#define GreenResultInstructionColor    JXColor(0xae, 0xe1, 0x4c, 1)
#define BgGrayColor                    JXColor(0xf7, 0xf7, 0xf9, 1)

#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, LZStudyLevel) {
    LZStudyLevelLow,           //@"普通"
    LZStudyLevelNormal,        //@"中等"
    LZStudyLevelHigh,          //@"优秀"
    LZStudyLevelExcellent,     //@"高手"
    LZStudyLevelPerfect,       //@"学霸"
};

typedef NS_ENUM(NSInteger, LZTestType) {
    LZTestSingleSelectType = 1,  // 单选
    LZTestMultiSelectTypType,    // 多选
    LZTestFillInTheBlankType,    // 填空
    LZTestReadingComprehensionType,  // 阅读理解
    LZTestClozetestType,             // 完形填空

};

typedef NS_ENUM(NSInteger, ThroughTraining_Status) {
    Lock_Status = 0,           // 已锁定
    NotComplated_Status,       // 开始做，未完成
    Complated_Status,          // 已完成
    UnLocked_Status,           // 已解锁
    Unknown_Status
};

typedef NS_ENUM(NSInteger, EditModel_Status) {
    NotEditEnable_Status = 0,        // 不允许编辑
    Edited_Status,                   // 有做过的题目，允许编辑
    EditEnable_Status,               // 允许编辑
    Unknown_EditStatus
};


typedef NS_OPTIONS(NSInteger, LZTestStatus) {
    LZTestUnknown = 0,
    LZTestNoAnswer = 1 << 0,           // 未做
    LZTestCorrect = 1 << 1,            // 正确
    LZTestWrong = 1 << 2,              // 错误
    LZTestWithAnswer= 1 << 3,          // 已做过
    
};


typedef NS_ENUM(NSInteger, LZQuestionType) {
    LZQuestionFirst = 0,               // 第一次做题
    LZQuestionRetrain,                 // 重新答题
    LZQuestionWrongAgain,              // 错题加练
    LZQuestionUnknown                  // 未知
};

#endif

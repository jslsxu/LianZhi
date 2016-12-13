//
//  HeadLineView.m
//  LianzhiParent
//
//  Created by Chen qi on 15/11/12.
//  Copyright © 2016年 com.sjwy. All rights reserved.

#import "LZThrougnAlertView.h"
#import "EDStarRating.h"
#import "LZCustomAlertView.h"
#import "ThroughTrainingVC.h"
#import "TestBaseVC.h"


@interface LZThrougnAlertView()
{
    UIView *contentView;
    EDStarRating *starRating;
    UILabel *currentStageLabel;
    UILabel *totalStageLabel;
    UILabel *optionLabel;
    ThroughTrainingVC *trainingVC;

}
@end
@implementation LZThrougnAlertView

-(instancetype)initWithViewController:(UIViewController *)rViewController
                               Status:(ThroughTraining_Status)status{
    trainingVC = (ThroughTrainingVC *)rViewController;
    self.status = status;
    switch (status) {
        case Complated_Status:
            //已交卷做完题
            self = [self initComplatedViewWithFrame:rViewController.view.frame];
            break;
        case NotComplated_Status:
            //未交卷  未做完题
            self = [self initNotComplatedViewWithFrame:rViewController.view.frame];
            break;
        case UnLocked_Status:
            //第一次做题
            self = [self initUnLockedViewWithFrame:rViewController.view.frame];
            break;
        default:
        
            break;
    }
    
    
    return self;
}

-(instancetype)initViewWithFrame:(CGRect)viewframe{
    if (self=[super initWithFrame:viewframe]) {
//        CGFloat width = viewframe.size.width - 152;
//        CGFloat height = width * 284/204;
        
        CGFloat width = 204;
        CGFloat height = 284;
        
        // 视图容器的初始化
        contentView = [[UIView alloc] init];
        contentView.frame = CGRectMake(0, 0, width, height);
        
        CGSize size = contentView.size;
        CGFloat currentStageHeight = 100;//IS_IPhone6Plus?120: 90.0;
        currentStageLabel = [[UILabel alloc] initWithFrame:CGRectMake((size.width/2.0 - 140.0/2.0),
                                                                      currentStageHeight,
                                                                      140.0,
                                                                      30.0)];
        //    [currentStageLabel setTextColor:JXColor(0xc0,0xff,0x16,1)];
        [currentStageLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [currentStageLabel setTextAlignment:NSTextAlignmentCenter];
        
        currentStageLabel.shadowColor = JXColor(0x04,0x96,0x6f,1);
        currentStageLabel.shadowOffset = CGSizeMake(0, -4.0);
        
        CGFloat totalStageHeight = 195;//IS_IPhone6Plus?240: 190.0;
        
        totalStageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, totalStageHeight, size.width - 20, 20.0)];
        [totalStageLabel setTextColor:JXColor(0x5c,0x5d,0x5d,1)];
        [totalStageLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [totalStageLabel setTextAlignment:NSTextAlignmentCenter];
        
        [contentView addSubview:currentStageLabel];
        [contentView addSubview:totalStageLabel];

    }
    return self;
}



-(instancetype)initComplatedViewWithFrame:(CGRect)viewframe{
    if (self = [self initViewWithFrame:viewframe]) {
        CGFloat width = 204;
        CGFloat height = 284;
//        CGFloat width = viewframe.size.width - 152;
//        CGFloat height = width * 284/204;
    
        CGSize size = contentView.size;
        CGFloat starRatinHeight = 130;//IS_IPhone6Plus?160: 125.0;
        // 星星评价视图的初始化
        starRating = [[EDStarRating alloc] initWithFrame:CGRectMake((size.width/2.0 - 140.0/2.0), starRatinHeight, 140.0, 50.0)];
        starRating.starImage = [UIImage imageNamed:@"starGrayImg"];
        starRating.starHighlightedImage = [UIImage imageNamed:@"starGoldImg"];
        starRating.maxRating = 3.0;
        starRating.horizontalMargin = 12.0;
        starRating.editable = NO;
        starRating.displayMode = EDStarRatingDisplayFull;
        
        starRating.backgroundColor = [UIColor clearColor];
    
        [contentView addSubview:starRating];
     
        [LZCustomAlertView showAlertOnView:trainingVC.navigationController.view  withTitle:@"" titleColor:[UIColor whiteColor] width:width height:height blur:NO backgroundImage:[UIImage imageNamed:@"alertBg"] backgroundColor:nil cornerRadius:0.0 shadowAlpha:0.7 alpha:1.0 contentView:contentView type:FVAlertTypeCustom allowTap:YES];
        
         __weak typeof(self) wself = self;
        
        LZAlertAction *cancelAlertAction = [LZAlertAction actionWithTitle:@"错题加练" style:UIAlertActionStyleDefault handler:^(LZAlertAction *action) {
            //        [self dismissViewControllerAnimated:YES completion:nil];
            [wself wrongReTraining];
        }];
        
        LZAlertAction *defaultAlertAction = [LZAlertAction actionWithTitle:@"重新闯关" style:UIAlertActionStyleDefault handler:^(LZAlertAction *action) {
            [LZCustomAlertView closeClick:nil];
            
            TestBaseVC *testVC = [[TestBaseVC alloc] init];
            testVC.rootVC = trainingVC;
            testVC.subjectCode = wself.subjectCode;
            testVC.isAgain = LZQuestionRetrain;
       
            testVC.isEditModel = (wself.qItem.status == NotComplated_Status)? Edited_Status:EditEnable_Status;
            testVC.rootVC = trainingVC;
            testVC.qItem = wself.qItem;
            [CurrentROOTNavigationVC pushViewController:testVC animated:YES];
        }];
        //
        NSArray *actions = [NSArray arrayWithObjects:cancelAlertAction,defaultAlertAction,nil];
        
        [LZCustomAlertView createActionButtons:actions Status:Complated_Status];
        
        
     }
    return self;
}

-(instancetype)initNotComplatedViewWithFrame:(CGRect)viewframe{
    if (self = [self initViewWithFrame:viewframe]) {
//        CGFloat width = viewframe.size.width - 152;
//        CGFloat height = width * 284/204;
        CGFloat width = 204;
        CGFloat height = 284;
        CGSize size = contentView.size;
        CGFloat starRatingHeight = 140;//IS_IPhone6Plus?160: 125.0;
        
        optionLabel =  [[UILabel alloc] initWithFrame:CGRectMake((size.width/2.0 - 150.0/2.0), starRatingHeight, 150.0, 20.0)];
        [optionLabel setTextColor:WhiteColor];
        [optionLabel setFont:[UIFont boldSystemFontOfSize:28]];
        [optionLabel setTextAlignment:NSTextAlignmentCenter];
        
        [contentView addSubview:optionLabel];

        
        [LZCustomAlertView showAlertOnView:trainingVC.navigationController.view  withTitle:@"" titleColor:[UIColor whiteColor] width:width height:height blur:NO backgroundImage:[UIImage imageNamed:@"alertBgOneBtn"] backgroundColor:nil cornerRadius:0.0 shadowAlpha:0.7 alpha:1.0 contentView:contentView type:FVAlertTypeCustom allowTap:YES];
        
        __weak typeof(self) wself = self;
    
        LZAlertAction *defaultAlertAction = [LZAlertAction actionWithTitle:@"继续闯关" style:UIAlertActionStyleDefault handler:^(LZAlertAction *action) {
            [LZCustomAlertView closeClick:nil];
            
            TestBaseVC *testVC = [[TestBaseVC alloc] init];
            testVC.rootVC = trainingVC;
            testVC.subjectCode = wself.subjectCode;
            testVC.isAgain = (LZQuestionType)[wself.qItem.is_again integerValue];
            testVC.isEditModel = (wself.qItem.status == NotComplated_Status)? Edited_Status:EditEnable_Status;
            testVC.rootVC = trainingVC;
            testVC.qItem = wself.qItem;
//            testVC.qItem.status = NotComplated_Status;
            [CurrentROOTNavigationVC pushViewController:testVC animated:YES];
        }];
        //
        NSArray *actions = [NSArray arrayWithObjects:defaultAlertAction,nil];
        
        [LZCustomAlertView createActionButtons:actions Status:NotComplated_Status];
       
    }
    return self;
}

-(instancetype)initUnLockedViewWithFrame:(CGRect)viewframe{
    if (self = [self initViewWithFrame:viewframe]) {
        CGFloat width = 204;
        CGFloat height = 284;
//        CGFloat width = viewframe.size.width - 152;
//        CGFloat height = width * 284/204;
        CGSize size = contentView.size;
        CGFloat starRatingHeight = 140;//IS_IPhone6Plus?160: 125.0;
        
        optionLabel =  [[UILabel alloc] initWithFrame:CGRectMake((size.width/2.0 - 150.0/2.0), starRatingHeight, 150.0, 20.0)];
        [optionLabel setTextColor:WhiteColor];
        [optionLabel setFont:[UIFont boldSystemFontOfSize:28]];
        [optionLabel setTextAlignment:NSTextAlignmentCenter];
        
        [contentView addSubview:optionLabel];
        
        
        [LZCustomAlertView showAlertOnView:trainingVC.navigationController.view  withTitle:@"" titleColor:[UIColor whiteColor] width:width height:height blur:NO backgroundImage:[UIImage imageNamed:@"alertBgOneBtn"] backgroundColor:nil cornerRadius:0.0 shadowAlpha:0.7 alpha:1.0 contentView:contentView type:FVAlertTypeCustom allowTap:YES];
        
        __weak typeof(self) wself = self;
        
        LZAlertAction *defaultAlertAction = [LZAlertAction actionWithTitle:@"开始" style:UIAlertActionStyleDefault handler:^(LZAlertAction *action) {
            [LZCustomAlertView closeClick:nil];
            
            TestBaseVC *testVC = [[TestBaseVC alloc] init];
            testVC.isAgain = LZQuestionFirst;
            testVC.subjectCode = wself.subjectCode;
            testVC.isEditModel = (wself.qItem.status == NotComplated_Status)? Edited_Status:EditEnable_Status;
            testVC.rootVC = trainingVC;
            testVC.qItem = wself.qItem;
//            testVC.qItem.status = NotComplated_Status;
            [CurrentROOTNavigationVC pushViewController:testVC animated:YES];
        }];
        //
        NSArray *actions = [NSArray arrayWithObjects:defaultAlertAction,nil];
        
        [LZCustomAlertView createActionButtons:actions Status:UnLocked_Status];

    }
    return self;
}



- (void)setItem:(QuestionItem *)quesionItem
{
    self.qItem = quesionItem;
    
    
    NSString *string = quesionItem.chapter_name;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSUInteger length = [string length];
    
    if(length  < 1)
        return;
    
    //设置字体
//    NSRange range = [string rangeOfString:@"关"];
//    UIFont *boldFont = [UIFont boldSystemFontOfSize:20]; //设置所有的字体
    UIFont *bigBoldFont = [UIFont boldSystemFontOfSize:34];
    
//    long sectionLocation = range.location - 1 > length ?  1 : range.location - 1;
    [attrString addAttribute:NSFontAttributeName value:bigBoldFont range:NSMakeRange(0, length)];
//    [attrString addAttribute:NSFontAttributeName value:bigBoldFont range:NSMakeRange(1, sectionLocation)];//设置Text这四个字母的字体为粗体
    
    //设置Text这四个字母的字体为粗体
//    [attrString addAttribute:NSFontAttributeName value:boldFont range:range];
    
    // 设置颜色
    UIColor *color = JXColor(0xc0,0xff,0x16,1);
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:color
                       range:NSMakeRange(0, length)];
    
    
    [attrString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, length)];//字符间距 2pt
    [attrString addAttribute:NSStrokeColorAttributeName value:JXColor(0x02,0x72,0x55,1) range:NSMakeRange(0, length)];//设置文字描边颜色，需要和
    
    currentStageLabel.attributedText = attrString;
    
    starRating.rating = self.qItem.star;
    
    NSUInteger count = self.qItem.qcount;
    if(self.status == NotComplated_Status && [self.qItem.is_again isEqualToString:@"2"]){
        
        count = self.qItem.qcount -  self.qItem.correctNum;
        totalStageLabel.text = [NSString stringWithFormat:@"共%lu道错题",(unsigned long)count];
    }
    else
    {
        totalStageLabel.text = [NSString stringWithFormat:@"共%lu道题",(unsigned long)count];
    }


    
//    [totalStageLabel sizeToFit];

}

- (void)setActionButtonEnable:(BOOL)enable
{
    [LZCustomAlertView setActionButtonEnable:enable];
}

-(void)reTraining{
    CGFloat starRatinHeight = 140;//IS_IPhone6Plus?160: 125.0;
    // 星星评价视图的初始化
    starRating.hidden = YES;
    CGSize size = contentView.size;
    optionLabel =  [[UILabel alloc] initWithFrame:CGRectMake((size.width/2.0 - 150.0/2.0), starRatinHeight, 150.0, 20.0)];
    [optionLabel setTextColor:WhiteColor];
    [optionLabel setFont:[UIFont boldSystemFontOfSize:28]];
    [optionLabel setTextAlignment:NSTextAlignmentCenter];
    
    [contentView addSubview:optionLabel];
    optionLabel.text = @"错题加练";
    NSInteger count = self.qItem.qcount - self.qItem.correctNum > 0 ?  self.qItem.qcount - self.qItem.correctNum : 0;
    totalStageLabel.text = [NSString stringWithFormat:@"共%lu道错题",count];
//    totalStageLabel.text = @"共3道错题";
    
    __weak typeof(self) wself = self;
  

    LZAlertAction *cancelAlertAction = [LZAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(LZAlertAction *action) {
        [LZCustomAlertView closeClick:nil];

    }];
    
    LZAlertAction *defaultAlertAction = [LZAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(LZAlertAction *action) {
        [LZCustomAlertView closeClick:nil];
        
        TestBaseVC *testVC = [[TestBaseVC alloc] init];
        testVC.subjectCode = wself.subjectCode;
        testVC.isEditModel = (wself.qItem.status == NotComplated_Status)? Edited_Status:EditEnable_Status;
        testVC.isAgain = LZQuestionRetrain;
        testVC.rootVC = trainingVC;
        testVC.qItem = wself.qItem;
//        testVC.qItem.status = NotComplated_Status;
        [CurrentROOTNavigationVC pushViewController:testVC animated:YES];
    }];
    
    //
    NSArray *actions = [NSArray arrayWithObjects:cancelAlertAction,defaultAlertAction,nil];
    
    [LZCustomAlertView createActionButtons:actions Status:Unknown_Status];


}

-(void)wrongReTraining{
    CGFloat starRatinHeight = 140;//IS_IPhone6Plus?160: 125.0;
    // 星星评价视图的初始化
    starRating.hidden = YES;
    CGSize size = contentView.size;
    optionLabel =  [[UILabel alloc] initWithFrame:CGRectMake((size.width/2.0 - 150.0/2.0), starRatinHeight, 150.0, 20.0)];
    [optionLabel setTextColor:WhiteColor];
    [optionLabel setFont:[UIFont boldSystemFontOfSize:28]];
    [optionLabel setTextAlignment:NSTextAlignmentCenter];
    
    [contentView addSubview:optionLabel];
    optionLabel.text = @"错题加练";
    long count = self.qItem.qcount - self.qItem.correctNum;
    long trueCount = count > 0? count : 0;
    totalStageLabel.text = [NSString stringWithFormat:@"共%ld道错题",trueCount];
//    [totalStageLabel sizeToFit];

    __weak typeof(self) wself = self;
 
    LZAlertAction *cancelAlertAction = [LZAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(LZAlertAction *action) {
        [LZCustomAlertView closeClick:nil];
   
    }];
    
    LZAlertAction *defaultAlertAction = [LZAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(LZAlertAction *action) {
        [LZCustomAlertView closeClick:nil];
        TestBaseVC *testVC = [[TestBaseVC alloc] init];
        testVC.rootVC = trainingVC;
        testVC.subjectCode = wself.subjectCode;
        testVC.isAgain = LZQuestionWrongAgain;
        testVC.isEditModel = (wself.qItem.status == NotComplated_Status)? Edited_Status:EditEnable_Status;
        testVC.rootVC = trainingVC;
        testVC.qItem = wself.qItem;
//        testVC.qItem.status = NotComplated_Status;
        [CurrentROOTNavigationVC pushViewController:testVC animated:YES];
    }];
    
    //
    NSArray *actions = [NSArray arrayWithObjects:cancelAlertAction,defaultAlertAction,nil];
    
    [LZCustomAlertView createActionButtons:actions Status:Unknown_Status];
    
}

@end

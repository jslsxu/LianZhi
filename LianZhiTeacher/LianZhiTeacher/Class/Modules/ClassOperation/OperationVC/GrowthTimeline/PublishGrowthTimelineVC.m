//
//  PublishGrowthTimelineVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PublishGrowthTimelineVC.h"
#import "GrowthTimelineVC.h"
#import "GrowthTimelineClassChangeVC.h"
#import "ClassSelectionVC.h"
@interface PublishGrowthTimelineVC ()<UITextViewDelegate>
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSArray *keyArray;

@property (nonatomic, copy)NSString *mood;
@property (nonatomic, assign)NSInteger stoolNum;
@property (nonatomic, copy)NSString *temparature;
@end

@implementation PublishGrowthTimelineVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _healthArray = [NSMutableArray array];
        self.classInfo = [UserCenter sharedInstance].curSchool.classes[0];
        self.keyArray = @[@"mood",@"stool_num",@"temperature",@"water",@"sleep"];
        self.mood = @"高兴";
        self.stoolNum = 0;
        self.temparature = @"正常";
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"家园手册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"RecordHistory"] style:UIBarButtonItemStylePlain target:self action:@selector(showRecordHistory)];
    [self addKeyboardNotifications];
    
    _scrollView = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:_scrollView];
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 20)];
    [hintLabel setFont:[UIFont systemFontOfSize:14]];
    [hintLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy年MM月dd日"];
    
    [hintLabel setText:[NSString stringWithFormat:@"今天是%@ %@",[formmater stringFromDate:date],[Utility weekdayStr:[NSDate date]]]];
    [hintLabel setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:hintLabel];
    
    UILabel *subHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, hintLabel.bottom + 15, self.view.width - 50 * 2, 35)];
    [subHintLabel setTextAlignment:NSTextAlignmentCenter];
    [subHintLabel setNumberOfLines:0];
    [subHintLabel setTextColor:[UIColor colorWithHexString:@"b7b7b7"]];
    [subHintLabel setFont:[UIFont systemFontOfSize:12]];
    [subHintLabel setText:@"针对表现相同的孩子，您只需填写一次，在选择学生时批量选择即可"];
    [_scrollView addSubview:subHintLabel];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, subHintLabel.bottom + 20, self.view.width - 10 * 2, 240)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView.layer setCornerRadius:10];
    [bgView.layer setMasksToBounds:YES];
    [self setupBGView:bgView];
    [_scrollView addSubview:bgView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(onSendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setFrame:CGRectMake(15, bgView.bottom + 33, self.view.width - 15 * 2, 36)];
    [sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed016"] size:sendButton.size cornerRadius:18] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [sendButton setTitle:@"选择学生并发送" forState:UIControlStateNormal];
    [_scrollView addSubview:sendButton];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, sendButton.bottom + 20)];
}

- (void)setupBGView:(UIView *)viewParent
{
    NSInteger hMargin = 10;
    NSInteger vMargin = 20;
    NSInteger itemWIdth = 50;
    NSInteger innerMargin = (viewParent.width - hMargin * 2 - itemWIdth * 5) / 4;
    NSArray *imageArray = @[@"ExpressionHappy",@"ToiletNo",@"TempNormal",@"DrinkNormal",@"SleepNormal"];
    for (NSInteger i = 0; i < 5; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(hMargin + (innerMargin + itemWIdth) * i, vMargin, itemWIdth, itemWIdth)];
        [button addTarget:self action:@selector(onHealthButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        if(i == 3)
            [button setImage:[UIImage imageNamed:@"DrinkAbnormal"] forState:UIControlStateSelected];
        else if(i == 4)
            [button setImage:[UIImage imageNamed:@"SleepAbnormal"] forState:UIControlStateSelected];
        [viewParent addSubview:button];
        [_healthArray addObject:button];
    }
    
    UIView *inputBGView = [[UIView alloc] initWithFrame:CGRectMake(5, 90, viewParent.width - 5 * 2, viewParent.height -  20 - 90)];
    [inputBGView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [inputBGView.layer setCornerRadius:5];
    [inputBGView.layer setMasksToBounds:YES];
    [viewParent addSubview:inputBGView];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectInset(inputBGView.bounds, 5, 5)];
    [_textView setDelegate:self];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setPlaceholder:@"写点什么"];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setTextColor:[UIColor grayColor]];
    [inputBGView addSubview:_textView];
}

- (void)onHealthButtonClicked:(UIButton *)button
{
    NSInteger index = [_healthArray indexOfObject:button];
    if(index == 0)
        [self onEmotionButtonClicked];
    else if(index == 1)
        [self onToiletButtonClicked];
    else if(index == 2)
        [self onTemperatureButtonClicked];
    else
    {
        BOOL selected = button.selected;
        button.selected = !selected;
    }
}

- (void)onSendButtonClicked
{
    NSMutableDictionary *record = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < self.keyArray.count; i++)
    {
        NSString *key = self.keyArray[i];
        UIButton *healthButton = _healthArray[i];
        BOOL selected = healthButton.selected;
        if(i >= 3)
            [record setValue:kStringFromValue(selected) forKey:key];
        else
        {
            NSString *status;
            if(i == 0)
                status = self.mood;
            else if (i == 1)
                status = kStringFromValue(self.stoolNum);
            else
                status = self.temparature;
            [record setValue:status forKey:key];
        }
    }
    [record setValue:_textView.text forKey:@"words"];
    GrowthTimelineClassChangeVC *classSelectVC = [[GrowthTimelineClassChangeVC alloc] init];
    [classSelectVC setRecord:record];
    [CurrentROOTNavigationVC pushViewController:classSelectVC animated:YES];
}

- (void)showRecordHistory
{
    if([UserCenter sharedInstance].curSchool.classNum == 0)
        return;
    if([UserCenter sharedInstance].curSchool.classNum == 1)
    {
        ClassInfo *classInfo = nil;
        if([UserCenter sharedInstance].curSchool.classes.count > 0)
            classInfo = [UserCenter sharedInstance].curSchool.classes[0];
        else if([UserCenter sharedInstance].curSchool.managedClasses.count > 0)
            classInfo = [UserCenter sharedInstance].curSchool.managedClasses[0];
        GrowthTimelineVC *growthTimelineVC = [[GrowthTimelineVC alloc] init];
        [growthTimelineVC setClassID:classInfo.classID];
        [growthTimelineVC setTitle:classInfo.name];
        [CurrentROOTNavigationVC pushViewController:growthTimelineVC animated:YES];
    }
    else
    {
        ClassSelectionVC *selectionVC = [[ClassSelectionVC alloc] init];
        [selectionVC setSelection:^(ClassInfo *classInfo) {
            GrowthTimelineVC *growthTimelineVC = [[GrowthTimelineVC alloc] init];
            [growthTimelineVC setClassID:classInfo.classID];
            [growthTimelineVC setTitle:classInfo.name];
            [CurrentROOTNavigationVC pushViewController:growthTimelineVC animated:YES];
        }];
        [CurrentROOTNavigationVC pushViewController:selectionVC animated:YES];
    }
}

- (void)onKeyboardWillShow:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] delay:0 options:curve.integerValue animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0)];
    } completion:nil];
}

- (void)onKeyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] delay:0 options:curve.integerValue animations:^{
        [_scrollView setContentInset:UIEdgeInsetsZero];
    } completion:nil];
}

- (void)onTemperatureButtonClicked
{
    NSString *next = nil;
    UIButton *temparatureButton = _healthArray[2];
    if([self.temparature isEqualToString:@"正常"])
    {
        [temparatureButton setImage:[UIImage imageNamed:(@"TempHigh")] forState:UIControlStateNormal];
        next = @"发烧";
    }
    else if([self.temparature isEqualToString:@"发烧"])
    {
        [temparatureButton setImage:[UIImage imageNamed:(@"TempNormal")] forState:UIControlStateNormal];
        next = @"正常";
    }
    self.temparature = next;
}

- (void)onToiletButtonClicked
{
    NSInteger next = 0;
    UIButton *toiletButton = _healthArray[1];
    if(self.stoolNum == 0)
    {
        next = 1;
        [toiletButton setImage:[UIImage imageNamed:(@"ToiletOnce.png")] forState:UIControlStateNormal];
    }
    else if(self.stoolNum == 1)
    {
        next = 2;
        [toiletButton setImage:[UIImage imageNamed:(@"ToiletTwice.png")] forState:UIControlStateNormal];
    }
    else
    {
        next = 0;
        [toiletButton setImage:[UIImage imageNamed:(@"ToiletNo.png")] forState:UIControlStateNormal];
    }
    self.stoolNum = next;
}

- (void)onEmotionButtonClicked
{
    NSString *next = nil;
    UIButton *moodButton = _healthArray[0];
    if([self.mood isEqualToString:@"高兴"])
    {
        next = @"哭闹";
        [moodButton setImage:[UIImage imageNamed:(@"ExpressionCry")] forState:UIControlStateNormal];
    }
    else if ([self.mood isEqualToString:@"哭闹"])
    {
        next = @"一般";
        [moodButton setImage:[UIImage imageNamed:(@"ExpressionSimple")] forState:UIControlStateNormal];
    }
    else
    {
        next = @"高兴";
        [moodButton setImage:[UIImage imageNamed:(@"ExpressionHappy")] forState:UIControlStateNormal];
    }
    self.mood = next;
}


#pragma mark - UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  RequestVacationVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "RequestVacationVC.h"

#define kMargin                     10

@interface RequestVacationVC ()<UITextViewDelegate>
@property (nonatomic, strong)NSDate *startDate;
@property (nonatomic, strong)NSDate *endDate;
@end

@implementation RequestVacationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线请假";
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"eeeef4"]];
    UIView *startBG = [[UIView alloc] initWithFrame:CGRectMake(10, 15, self.view.width - 10 * 2, 45)];
    [startBG setBackgroundColor:[UIColor whiteColor]];
    [startBG.layer setCornerRadius:10];
    [startBG.layer setMasksToBounds:YES];
    [self.view addSubview:startBG];
    
    UITapGestureRecognizer *startTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onStartButtonClicked)];
    [startBG addGestureRecognizer:startTapGesture];
    
    UIImageView* rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ParentRelationArrow"]];
    [rightArrow setOrigin:CGPointMake(startBG.width - 10 - rightArrow.width, (startBG.height - rightArrow.height) / 2)];
    [startBG addSubview:rightArrow];
    
    _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, rightArrow.left - 10 - 10, startBG.height)];
    [_startLabel setTextColor:[UIColor colorWithHexString:@"9e9e9e"]];
    [_startLabel setText:@"起始:"];
    [_startLabel setFont:[UIFont systemFontOfSize:15]];
    [startBG addSubview:_startLabel];
    
    UIView *endBG = [[UIView alloc] initWithFrame:CGRectMake(10, startBG.bottom + 10, self.view.width - 10 * 2, 45)];
    [endBG setBackgroundColor:[UIColor whiteColor]];
    [endBG.layer setCornerRadius:10];
    [endBG.layer setMasksToBounds:YES];
    [self.view addSubview:endBG];
    
    UITapGestureRecognizer *endTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onEndButtonClicked)];
    [endBG addGestureRecognizer:endTapGesture];
    
    UIImageView* rightArrowEnd = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ParentRelationArrow"]];
    [rightArrowEnd setOrigin:CGPointMake(endBG.width - 10 - rightArrowEnd.width, (endBG.height - rightArrowEnd.height) / 2)];
    [endBG addSubview:rightArrowEnd];
    
    _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, rightArrowEnd.left - 10 - 10, endBG.height)];
    [_endLabel setTextColor:[UIColor colorWithHexString:@"9e9e9e"]];
    [_endLabel setText:@"终于:"];
    //    [_endLabel setTextAlignment:NSTextAlignmentCenter];
    [_endLabel setFont:[UIFont systemFontOfSize:15]];
    [endBG addSubview:_endLabel];

    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(kMargin , self.view.height - 10 - 40, self.view.width - kMargin * 2 , 40)];
    [sendButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:@"给班主任发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:sendButton.size cornerRadius:5] forState:UIControlStateNormal];
    [self.view addSubview:sendButton];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(10, endBG.bottom + 15, self.view.width - 10 * 2, sendButton.y - 20 - (endBG.bottom + 15))];
    [contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView.layer setCornerRadius:10];
    [contentView.layer setMasksToBounds:YES];
    [self.view addSubview:contentView];
    
    UILabel* hintLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [hintLabel setText:@"原因说明:"];
    [hintLabel setFont:[UIFont systemFontOfSize:15]];
    [hintLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [hintLabel sizeToFit];
    [hintLabel setOrigin:CGPointMake(15, 15)];
    [contentView addSubview:hintLabel];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, hintLabel.bottom + 5, contentView.width - 10 * 2, contentView.height - 10 - (hintLabel.bottom + 5))];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setPlaceholder:@"请输入请假原因"];
    [_textView setFont:[UIFont systemFontOfSize:15]];
    [_textView setTextColor:[UIColor darkGrayColor]];
    [_textView setDelegate:self];
    [contentView addSubview:_textView];
    
    [self setStartDate:[NSDate date]];
    [self setEndDate:[self.startDate dateByAddingDays:1]];
}
- (void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formmater stringFromDate:_startDate];
    NSMutableAttributedString *startStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"起始:  %@",dateStr] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"2c2c2c"]}];
    [startStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[NSDate getWeekStringFromInteger:[_startDate weekday]]] attributes:@{NSForegroundColorAttributeName : kCommonParentTintColor}]];
    [_startLabel setAttributedText:startStr];
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formmater stringFromDate:_endDate];
    NSMutableAttributedString *endStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"终于:  %@",dateStr ] attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"2c2c2c"]}];
     [endStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",[NSDate getWeekStringFromInteger:[_endDate weekday]]] attributes:@{NSForegroundColorAttributeName : kCommonParentTintColor}]];
    [_endLabel setAttributedText:endStr];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Actions
- (void)onStartButtonClicked
{
    VacationDatePickerView *datePicker = [[VacationDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds andDate:self.startDate ? : [NSDate date] minimumDate:[NSDate date]];
    [datePicker setCallBack:^(NSDate *date){
        self.startDate = date;
    }];
    [datePicker show];
}

- (void)onEndButtonClicked
{
    VacationDatePickerView *datePicker = [[VacationDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds andDate:self.endDate ? : [NSDate date] minimumDate:[NSDate date]];
    [datePicker setCallBack:^(NSDate *date){
        self.endDate = date;
    }];
    [datePicker show];
}

- (void)onCancel
{
    
}

- (void)onSend
{
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:self.classInfo.classID forKey:@"class_id"];
//    [params setValue:self.classInfo.schoolInfo.schoolID forKey:@"school_id"];
    [params setValue:self.startDate forKey:@"from_date"];
    [params setValue:self.endDate forKey:@"to_date"];
    [params setValue:_textView.text forKey:@"words"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"leave/leave" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:YES];
        [ProgressHUD showHintText:@"请假条已发给老师"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CurrentROOTNavigationVC popViewControllerAnimated:YES];
        });
    } fail:^(NSString *errMsg) {
        [hud hide:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

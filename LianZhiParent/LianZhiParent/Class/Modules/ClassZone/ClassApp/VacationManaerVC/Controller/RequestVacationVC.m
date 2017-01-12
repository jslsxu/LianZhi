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
@property (nonatomic, strong)UITouchScrollView* scrollView;
@property (nonatomic, strong)NSDate *startDate;
@property (nonatomic, strong)NSDate *endDate;
@property (nonatomic, strong)UILabel* startLabel;
@property (nonatomic, strong)UILabel* endLabel;
@property (nonatomic, strong)UTPlaceholderTextView* textView;
@property (nonatomic, strong)UIView* bottomView;
@end

@implementation RequestVacationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    self.title = @"在线请假";
    
    [self.view addSubview:[self bottomView]];

    self.scrollView = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.bottomView.top)];
    [self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.scrollView];
    
    [self setupScrollView];
    
    NSDate *curDate = [NSDate date];
    NSString *str = [curDate stringWithFormat:@"yyyy-MM-dd"];
    NSDate *todayDate = [NSDate dateWithString:str format:@"yyyy-MM-dd"];
    NSDate *compareDate = [todayDate dateByAddingHours:8];
    if([curDate compare:compareDate] == NSOrderedAscending){
        [self setStartDate:compareDate];
    }
    else{
        [self setStartDate:[compareDate dateByAddingDays:1]];
    }
    
    [self setEndDate:[self.startDate dateByAddingHours:9]];
}

- (void)setupScrollView{
    UIView* startView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 10 * 2, 50)];
    [startView setBackgroundColor:[UIColor whiteColor]];
    [startView.layer setCornerRadius:10];
    [startView.layer setMasksToBounds:YES];
    [self.scrollView addSubview:startView];
    
    UIImageView *startArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ParentRelationArrow"]];
    [startArrow setOrigin:CGPointMake(startView.width - 10 - startArrow.width, (startView.height - startArrow.height) / 2)];
    [startView addSubview:startArrow];
    
    self.startLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, startArrow.left - 10 - 10, startView.height)];
    [self.startLabel setFont:[UIFont systemFontOfSize:16]];
    [startView addSubview:self.startLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onStartButtonClicked)];
    [startView addGestureRecognizer:tapGesture];
    
    UIView* endView = [[UIView alloc] initWithFrame:CGRectMake(10, startView.bottom + 10, self.view.width - 10 * 2, 50)];
    [endView setBackgroundColor:[UIColor whiteColor]];
    [endView.layer setCornerRadius:10];
    [endView.layer setMasksToBounds:YES];
    [self.scrollView addSubview:endView];
    
    UIImageView *endArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ParentRelationArrow"]];
    [endArrow setOrigin:CGPointMake(endView.width - 10 - endArrow.width, (endView.height - endArrow.height) / 2)];
    [endView addSubview:endArrow];
    
    self.endLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, endArrow.left - 10 - 10, startView.height)];
    [self.endLabel setFont:[UIFont systemFontOfSize:16]];
    [endView addSubview:self.endLabel];
    
    UITapGestureRecognizer *endTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onEndButtonClicked)];
    [endView addGestureRecognizer:endTapGesture];
    
    TTTAttributedLabel* hintLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(12, endView.bottom + 10, self.view.width - 12 * 2, 0)];
    [hintLabel setNumberOfLines:0];
    [hintLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [hintLabel setTextColor:kColor_66];
    [hintLabel setFont:[UIFont systemFontOfSize:13]];
    [hintLabel setLineSpacing:4];
    [hintLabel setText:@"8:00-17:00为一天。\n系统会根据您所选的时间来确定当天出勤状态。"];
    [hintLabel sizeToFit];
    [self.scrollView addSubview:hintLabel];
    
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(10, hintLabel.bottom + 20, self.view.width - 10 * 2, 240)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView.layer setCornerRadius:10];
    [contentView.layer setMasksToBounds:YES];
    [self.view addSubview:contentView];
    
    UILabel* inputLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [inputLabel setFont:[UIFont systemFontOfSize:15]];
    [inputLabel setTextColor:kColor_33];
    [inputLabel setText:@"备注:"];
    [inputLabel sizeToFit];
    [inputLabel setOrigin:CGPointMake(10, 10)];
    [contentView addSubview:inputLabel];
    
    UIButton* quickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [quickButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [quickButton setFrame:CGRectMake(10, contentView.height - 40, contentView.width - 10 * 2, 40)];
    [quickButton setTitleColor:kCommonParentTintColor forState:UIControlStateNormal];
    [quickButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [quickButton setTitle:@"快捷输入" forState:UIControlStateNormal];
    [quickButton addTarget:self action:@selector(onButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:quickButton];
    
    UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, quickButton.y - kLineHeight, contentView.width, kLineHeight)];
    [sepLine setBackgroundColor:kSepLineColor];
    [contentView addSubview:sepLine];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(6, inputLabel.bottom, contentView.width - 6 * 2, sepLine.top - 10 - inputLabel.bottom)];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setPlaceholder:@"请输入请假原因"];
    [_textView setFont:[UIFont systemFontOfSize:15]];
    [_textView setTextColor:[UIColor darkGrayColor]];
    [_textView setDelegate:self];
    [contentView addSubview:_textView];

    
    [self.scrollView setContentSize:CGSizeMake(self.view.width, contentView.bottom + 10)];

}

- (UIView *)bottomView{
    if(nil == _bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
        [_bottomView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [_bottomView setBackgroundColor:[UIColor whiteColor]];
        
        UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.width, kLineHeight)];
        [topLine setBackgroundColor:kSepLineColor];
        [_bottomView addSubview:topLine];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton setFrame:CGRectInset(_bottomView.bounds, 10, 10)];
        [sendButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sendButton setTitle:@"给班主任发送" forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:sendButton.size cornerRadius:5] forState:UIControlStateNormal];
        [_bottomView addSubview:sendButton];
    }
    return _bottomView;
}

- (void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;

    NSMutableAttributedString *startStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"起始:  %zd年%zd月%zd日  ", _startDate.year, _startDate.month, _startDate.day] attributes:@{NSForegroundColorAttributeName : kColor_66}];
    [startStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %zd:00",[self weekdayAtIndex:_startDate.weekday], [self.startDate hour]] attributes:@{NSForegroundColorAttributeName : kCommonParentTintColor}]];
    [_startLabel setAttributedText:startStr];
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    NSMutableAttributedString *startStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"截止:  %zd年%zd月%zd日  ", _endDate.year, _endDate.month, _endDate.day] attributes:@{NSForegroundColorAttributeName : kColor_66}];
    [startStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %zd:00",[self weekdayAtIndex:_endDate.weekday], [self.endDate hour]] attributes:@{NSForegroundColorAttributeName : kCommonParentTintColor}]];
    [_endLabel setAttributedText:startStr];
}

- (NSString *)weekdayAtIndex:(NSInteger)weekday{
    NSArray* weekdayArray = @[@"周日",@"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    return weekdayArray[weekday - 1];
}

- (void)onButtonClicked{
    __weak typeof(self) wself = self;
    LGAlertView* alertView = [[LGAlertView alloc] initWithTitle:@"请假原因" message:nil style:LGAlertViewStyleActionSheet buttonTitles:@[@"生病休息", @"家中有事"] cancelButtonTitle:@"关闭" destructiveButtonTitle:nil];
    [alertView setCancelButtonTitleColor:kCommonParentTintColor];
    [alertView setCancelButtonBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setButtonsTitleColor:kCommonParentTintColor];
    [alertView setButtonsBackgroundColorHighlighted:[UIColor colorWithHexString:@"dddddd"]];
    [alertView setActionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
        [wself.textView setText:title];
    }];
    [alertView showAnimated:YES completionHandler:nil];
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
    NSDate *curDate = [NSDate date];
    VacationDatePickerView *datePicker = [[VacationDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds andDate:self.startDate ? : [NSDate date] minimumDate:curDate];
    [datePicker setCallBack:^(NSDate *date){
        self.startDate = date;
    }];
    [datePicker show];
}

- (void)onEndButtonClicked
{
    NSDate *curDate = [NSDate date];
    VacationDatePickerView *datePicker = [[VacationDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds andDate:self.endDate ? : [NSDate date] minimumDate:curDate];
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
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"发送中" toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [params setValue:self.classInfo.school.schoolID forKey:@"school_id"];
    NSDateFormatter* formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [params setValue:[formmater stringFromDate:self.startDate] forKey:@"from_date"];
    [params setValue:[formmater stringFromDate:self.endDate] forKey:@"to_date"];
    [params setValue:_textView.text forKey:@"words"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"leave/nleave" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
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

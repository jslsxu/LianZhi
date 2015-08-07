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
    self.title = @"考勤请假";
}

- (void)setupSubviews
{
    
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [maskView setImage:[[UIImage imageNamed:MJRefreshSrcName(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [avatarView.layer setMask:maskView.layer];
    [avatarView.layer setMasksToBounds:YES];
    [avatarView sd_setImageWithURL:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar] placeholderImage:[UIImage imageNamed:MJRefreshSrcName(@"NoAvatarDefault.png")]];
    [self.view addSubview:avatarView];
    
    UILabel *nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, avatarView.bottom + 5, avatarView.width, 20)];
    [nickLabel setTextAlignment:NSTextAlignmentCenter];
    [nickLabel setFont:[UIFont systemFontOfSize:14]];
    [nickLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [nickLabel setText:[UserCenter sharedInstance].curChild.nickName];
    [self.view addSubview:nickLabel];
    
    CGFloat width = 35;
    _startField = [[LZTextField alloc] initWithFrame:CGRectMake(80, 10, self.view.width - 10 - 80, width)];
    [_startField setUserInteractionEnabled:NO];
    [_startField setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:_startField];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setImage:[UIImage imageNamed:@"VacationDateModify"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(onStartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [startButton setFrame:CGRectMake(_startField.right - width, _startField.top, width, width)];
    [self.view addSubview:startButton];
    
    _endField = [[LZTextField alloc] initWithFrame:CGRectMake(80, _startField.bottom + 10, self.view.width - 10 - 80, width)];
    [_endField setUserInteractionEnabled:NO];
    [_endField setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:_endField];
    
    UIButton *endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endButton setImage:[UIImage imageNamed:@"VacationDateModify"] forState:UIControlStateNormal];
    [endButton addTarget:self action:@selector(onEndButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [endButton setFrame:CGRectMake(_endField.right - width, _endField.top, width, width)];
    [self.view addSubview:endButton];
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"事假",@"病假"]];
    [segmentControl setSelectedSegmentIndex:0];
    [segmentControl setTintColor:kCommonParentTintColor];
    [segmentControl setFrame:CGRectMake(10, _endField.bottom + 20, self.view.width - 10 * 2, 30)];
    [segmentControl addTarget:self action:@selector(onSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentControl];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 60, self.view.width, 60)];
    [self setupBottomView:bottomView];
    [self.view addSubview:bottomView];
    
    UIImageView *textViewBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [textViewBG setUserInteractionEnabled:YES];
    [textViewBG setFrame:CGRectMake(10, segmentControl.bottom + 20, self.view.width - 10 * 2, bottomView.top - (segmentControl.bottom + 20))];
    [self.view addSubview:textViewBG];
    
    UIImageView *innerTextViewBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [innerTextViewBG setUserInteractionEnabled:YES];
    [innerTextViewBG setFrame:CGRectInset(textViewBG.bounds, kMargin, kMargin)];
    [textViewBG addSubview:innerTextViewBG];
    
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectInset(innerTextViewBG.bounds, 5, 5)];
    [textView setFont:[UIFont systemFontOfSize:15]];
    [textView setTextColor:[UIColor darkGrayColor]];
    [textView setDelegate:self];
    [innerTextViewBG addSubview:textView];
}

- (void)setupBottomView:(UIView *)viewParent
{
//    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelButton setFrame:CGRectMake(kMargin, (viewParent.height - 30) / 2, 100, 30)];
//    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
//    [cancelButton setBackgroundImage:[[UIImage imageNamed:MJRefreshSrcName(@"GreenBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin)] forState:UIControlStateNormal];
//    [viewParent addSubview:cancelButton];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(kMargin , (viewParent.height - 36) / 2, viewParent.width - kMargin * 2 , 36)];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:@"发送给班主任" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundImage:[[UIImage imageNamed:MJRefreshSrcName(@"GreenBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(kMargin, kMargin, kMargin, kMargin)] forState:UIControlStateNormal];
    [viewParent addSubview:sendButton];
}

- (void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yy年MM月dd日 EEEE a HH:mm"];
    NSString *dateStr = [formmater stringFromDate:_startDate];
    _startField.text = dateStr;
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yy年MM月dd日 EEEE a HH:mm"];
    NSString *dateStr = [formmater stringFromDate:_endDate];
    _endField.text = dateStr;
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

- (void)onSegmentChanged:(UISegmentedControl *)segment
{
    
}

- (void)onCancel
{
    
}

- (void)onSend
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

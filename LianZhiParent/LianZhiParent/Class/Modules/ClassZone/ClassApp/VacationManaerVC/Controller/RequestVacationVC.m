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
    self.title = [UserCenter sharedInstance].curChild.name;
    
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 10 * 2, 80)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [bgView.layer setCornerRadius:40];
    [bgView.layer setMasksToBounds:YES];
    [self.view addSubview:bgView];
    
    AvatarView *avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [avatarView setImageWithUrl:[NSURL URLWithString:[UserCenter sharedInstance].curChild.avatar]];
    [bgView addSubview:avatarView];
    
    _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarView.right + 10, 10, bgView.width - 50 - (avatarView.right + 20), 30)];
    [_startLabel setTextColor:[UIColor colorWithHexString:@"9e9e9e"]];
    [_startLabel setText:@"自"];
//    [_startLabel setTextAlignment:NSTextAlignmentCenter];
    [_startLabel setFont:[UIFont systemFontOfSize:15]];
    [bgView addSubview:_startLabel];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton addTarget:self action:@selector(onStartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [startButton setFrame:_startLabel.frame];
    [self.view addSubview:startButton];
    
    _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarView.right + 10, _startLabel.bottom, bgView.width - 50 - (avatarView.right + 20), 30)];
    [_endLabel setTextColor:[UIColor colorWithHexString:@"9e9e9e"]];
    [_endLabel setText:@"至"];
//    [_endLabel setTextAlignment:NSTextAlignmentCenter];
    [_endLabel setFont:[UIFont systemFontOfSize:15]];
    [bgView addSubview:_endLabel];
    
    UIButton *endButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [endButton addTarget:self action:@selector(onEndButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [endButton setFrame:_endLabel.frame];
    [self.view addSubview:endButton];
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(kMargin , self.view.height - 15 - 36 - 64, self.view.width - kMargin * 2 , 36)];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setTitle:@"发送假条" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed115"] size:sendButton.size cornerRadius:18] forState:UIControlStateNormal];
    [self.view addSubview:sendButton];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(10, bgView.bottom + 20, self.view.width - 10 * 2, sendButton.y - 20 - (bgView.bottom + 20))];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView.layer setCornerRadius:10];
    [contentView.layer setMasksToBounds:YES];
    [self.view addSubview:contentView];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectInset(contentView.bounds, 10, 10)];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setPlaceholder:@"请输入请假原因"];
    [_textView setFont:[UIFont systemFontOfSize:15]];
    [_textView setTextColor:[UIColor darkGrayColor]];
    [_textView setDelegate:self];
    [contentView addSubview:_textView];
}
- (void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yy-MM-dd HH:mm"];
    NSString *dateStr = [formmater stringFromDate:_startDate];
    NSMutableAttributedString *startStr = [[NSMutableAttributedString alloc] initWithString:@"自 " attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9e9e9e"]}];
    [startStr appendAttributedString:[[NSAttributedString alloc] initWithString:dateStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"2c2c2c"]}]];
    [_startLabel setAttributedText:startStr];
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yy-MM-dd HH:mm"];
    NSString *dateStr = [formmater stringFromDate:_endDate];
    NSMutableAttributedString *endStr = [[NSMutableAttributedString alloc] initWithString:@"至 " attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"9e9e9e"]}];
    [endStr appendAttributedString:[[NSAttributedString alloc] initWithString:dateStr attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"2c2c2c"]}]];
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

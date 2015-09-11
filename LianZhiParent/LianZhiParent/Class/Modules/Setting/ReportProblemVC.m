//
//  ReportProblemVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ReportProblemVC.h"

#define kReportContentMaxNum                500
@implementation ReportProblemVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setupSubviews
{
    CGFloat margin = 15;
    NSInteger vMargin = 8;
    
    _contactField = [[LZTextField alloc] initWithFrame:CGRectMake(margin, margin, self.view.width - margin * 2, 40)];
    [_contactField setPlaceholder:@"请留下您的电话"];
    [_contactField setTextColor:[UIColor colorWithHexString:@"666666"]];
    [_contactField setReturnKeyType:UIReturnKeyDone];
    [_contactField setDelegate:self];
    [_contactField setFont:[UIFont systemFontOfSize:15]];
    [_contactField setText:[UserCenter sharedInstance].userInfo.mobile];
    [self.view addSubview:_contactField];
    
    CGFloat spaceYStart = _contactField.bottom + vMargin;
    if(self.type == 2)
    {
        _groupField = [[LZTextField alloc] initWithFrame:CGRectMake(margin, spaceYStart, self.view.width - margin * 2, 40)];
        [_groupField setPlaceholder:@"请选择关联错误的组织"];
        [_groupField setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_groupField setReturnKeyType:UIReturnKeyDone];
        [_groupField setDelegate:self];
        [_groupField setFont:[UIFont systemFontOfSize:15]];
        [self.view addSubview:_groupField];
        spaceYStart += 40 + vMargin;
    }
    
    UIView *textViewBG = [[UIView alloc] initWithFrame:CGRectZero];
    [textViewBG setBackgroundColor:[UIColor whiteColor]];
    [textViewBG.layer setCornerRadius:4];
    [textViewBG.layer setBorderWidth:0.5];
    [textViewBG.layer setBorderColor:[UIColor colorWithHexString:@"D8D8D8"].CGColor];
    [textViewBG setFrame:CGRectMake(margin, spaceYStart, self.view.width - margin * 2, 100)];
    [self.view addSubview:textViewBG];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(5, 5, textViewBG.width - 5 * 2, textViewBG.height - 5 - 20)];
    [_textView setPlaceholder:@"请输入要上报的内容"];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setDelegate:self];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setFont:[UIFont systemFontOfSize:15]];
    [_textView setTextColor:[UIColor colorWithHexString:@"666666"]];
    [textViewBG addSubview:_textView];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_textView.left, _textView.bottom, _textView.width, 20)];
    [_numLabel setTextColor:[UIColor lightGrayColor]];
    [_numLabel setFont:[UIFont systemFontOfSize:14]];
    [_numLabel setTextAlignment:NSTextAlignmentRight];
    [_numLabel setText:kStringFromValue(kReportContentMaxNum - _textView.text.length)];
    [textViewBG addSubview:_numLabel];
    
    _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contactButton addTarget:self action:@selector(onContactButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_contactButton setImage:[UIImage imageNamed:@"ControlDefault"] forState:UIControlStateNormal];
    [_contactButton setImage:[UIImage imageNamed:@"ControlSelected"] forState:UIControlStateSelected];
    [_contactButton setFrame:CGRectMake(margin - 4, textViewBG.bottom + 5, 20, 20)];
    [self.view addSubview:_contactButton];
    
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contactButton.right + 5, _contactButton.y, 120, 20)];
    [_hintLabel setFont:[UIFont systemFontOfSize:12]];
    [_hintLabel setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
    [_hintLabel setText:@"需要客服与您联系"];
    [self.view addSubview:_hintLabel];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setFrame:CGRectMake(margin, self.view.height - 35 - 55, self.view.width - margin * 2, 36)];
    [_sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"E82550"] size:_sendButton.size cornerRadius:18] forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton setTitle:@"提交给客服处理" forState:UIControlStateNormal];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:_sendButton];
}

- (void)setContactMe:(BOOL)contactMe
{
    _contactMe = contactMe;
    [_contactButton setSelected:_contactMe];
}

- (void)onContactButtonClicked
{
    self.contactMe = !self.contactMe;
}

- (void)onSend
{
    NSString *contact = [_contactField text];
    NSString *content = [[_textView text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([content length] == 0)
    {
        TNButtonItem *confirmItem = [TNButtonItem itemWithTitle:@"确定" action:nil];
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"写点要提交的信息吧" buttonItems:@[confirmItem]];
        [alertView show];
        return;
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:kStringFromValue(self.type) forKey:@"type"];
    [params setValue:content forKey:@"content"];
    [params setValue:contact forKey:@"contact"];
    [params setValue:kStringFromValue(self.contactMe) forKey:@"contact_me"];
    
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在发送" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"setting/feedback" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [hud hide:YES];
        [ProgressHUD showHintText:@"提交客服成功"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
    } fail:^(NSString *errMsg) {
        [hud hide:YES];
    }];
}

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
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

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = textView.text;
    NSInteger num = [text length];
    if(num > kReportContentMaxNum)
        [textView setText:[text substringToIndex:kReportContentMaxNum]];
    [_numLabel setText:kStringFromValue(kReportContentMaxNum - [textView.text length])];
}
@end

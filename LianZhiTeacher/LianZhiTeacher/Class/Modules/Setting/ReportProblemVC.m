//
//  ReportProblemVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ReportProblemVC.h"

#define kReportContentMaxNum        500
@implementation ReportProblemVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.type == 1)
        self.title = @"信息修改";
    else if(self.type == 2)
        self.title = @"关联报错";
    else if(self.type == 3)
        self.title = @"产品升级";
    else
        self.title = @"软件错误报告";
}

- (void)setupSubviews
{
    CGFloat margin = 15;
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [bgImageView setUserInteractionEnabled:YES];
    [bgImageView setFrame:CGRectMake(margin, margin, self.view.width - margin * 2, 240)];
    [self.view addSubview:bgImageView];
    
    _contactField = [[LZTextField alloc] initWithFrame:CGRectMake(margin, margin, bgImageView.width - margin * 2, 40)];
    [_contactField setPlaceholder:@"请留下您的电话"];
    [_contactField setTextColor:[UIColor colorWithHexString:@"666666"]];
    [_contactField setReturnKeyType:UIReturnKeyDone];
    [_contactField setDelegate:self];
    [_contactField setFont:[UIFont systemFontOfSize:15]];
    [_contactField setText:[UserCenter sharedInstance].userInfo.mobile];
    [bgImageView addSubview:_contactField];
    
    UIImageView *textViewBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [textViewBG setUserInteractionEnabled:YES];
    [textViewBG setFrame:CGRectMake(margin, _contactField.bottom + margin, bgImageView.width - margin * 2, 100)];
    [bgImageView addSubview:textViewBG];
    
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
    [_contactButton setFrame:CGRectMake(margin, textViewBG.bottom + margin, (bgImageView.width - margin * 4) / 3, bgImageView.height - textViewBG.bottom - margin * 2)];
    [bgImageView addSubview:_contactButton];
    [self setContactMe:YES];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setBackgroundImage:[[UIImage imageNamed:(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_sendButton setFrame:CGRectMake(margin * 2 + _contactButton.right, textViewBG.bottom + margin, _contactButton.width * 2, 45)];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton setTitle:@"提交给客服处理" forState:UIControlStateNormal];
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [bgImageView addSubview:_sendButton];
}

- (void)setContactMe:(BOOL)contactMe
{
    _contactMe = contactMe;
    if(_contactMe)
        [_contactButton setImage:[UIImage imageNamed:(@"ContactMe.png")] forState:UIControlStateNormal];
    else
        [_contactButton setImage:[UIImage imageNamed:(@"NoContactMe.png")] forState:UIControlStateNormal];
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
        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"写点您要上报的信息吧" buttonItems:@[confirmItem]];
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
    NSInteger num = text.length;
    if(num > kReportContentMaxNum)
        [textView setText:[text substringToIndex:kReportContentMaxNum]];
    [_numLabel setText:kStringFromValue(kReportContentMaxNum - textView.text.length)];
}
@end

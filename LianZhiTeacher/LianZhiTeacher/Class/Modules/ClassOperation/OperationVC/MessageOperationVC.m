//
//  MessageOperationVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "MessageOperationVC.h"
#define kReportContentMaxNum                    500
#define kBorderMargin                           15
@implementation MessageOperationVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息通知";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"WhiteLeftArrow.png")] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    NSString *classID = [self.targetDic objectForKey:@"class_id"];
    NSString *numStr = nil;
    if(classID)//ren
    {
        NSString *studentStr = [self.targetDic objectForKey:@"student_ids"];
        NSArray *studentArray = [studentStr componentsSeparatedByString:@","];
        numStr = [NSString stringWithFormat:@"%ld人",(long)studentArray.count];
    }
    else
    {
        NSString *classIDStr = [self.targetDic objectForKey:@"class_ids"];
        NSArray *classArray = [classIDStr componentsSeparatedByString:@","];
        numStr = [NSString stringWithFormat:@"%ld个班",(long)classArray.count];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:numStr style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)setupSubviews
{
    if(_bgImageView == nil)
    {
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setUserInteractionEnabled:YES];
        [self.view addSubview:_bgImageView];
        [_bgImageView setFrame:CGRectMake(kBorderMargin, kBorderMargin, self.view.width - kBorderMargin * 2, self.view.height - kBorderMargin * 2)];
    }
    
    if(_inputBG == nil)
    {
        _inputBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_inputBG setUserInteractionEnabled:YES];
        [_bgImageView addSubview:_inputBG];
    }
    [_inputBG setFrame:CGRectMake(kBorderMargin, kBorderMargin, _bgImageView.width - kBorderMargin * 2, _bgImageView.height - 45 - kBorderMargin * 3)];
    
    if(_textView == nil)
    {
        _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(5, 5, _inputBG.width - 5 * 2, _inputBG.height - 5 - 20)];
        [_textView setPlaceholder:@"请输入您要发布的内容"];
        [_textView setDelegate:self];
        [_textView setReturnKeyType:UIReturnKeyDone];
        [_textView setFont:[UIFont systemFontOfSize:14]];
        [_textView setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_inputBG addSubview:_textView];
    }
    [_textView setFrame:CGRectMake(5, 5, _inputBG.width - 5 * 2, _inputBG.height - 5 - 20)];
    
    if(_numLabel == nil)
    {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_textView.left, _textView.bottom, _textView.width, 20)];
        [_numLabel setTextColor:[UIColor lightGrayColor]];
        [_numLabel setFont:[UIFont systemFontOfSize:14]];
        [_numLabel setTextAlignment:NSTextAlignmentRight];
        [_numLabel setText:kStringFromValue(kReportContentMaxNum - _textView.text.length)];
        [_inputBG addSubview:_numLabel];
    }
    [_numLabel setFrame:CGRectMake(_textView.left, _textView.bottom, _textView.width, 20)];
    
    if(_recordView == nil)
    {
        _recordView = [[AudioRecordView alloc] initWithFrame:_textView.frame];
        [_recordView setAlpha:0.f];
        [_recordView setDelegate:self];
        [_inputBG addSubview:_recordView];
    }
    [_recordView setFrame:_textView.frame];
    
    if(_switchButton == nil)
    {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton addTarget:self action:@selector(onSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [_switchButton setImage:[UIImage imageNamed:@"TextSwitch.png"] forState:UIControlStateNormal];
        [_bgImageView addSubview:_switchButton];
    }
    [_switchButton setFrame:CGRectMake(kBorderMargin, _inputBG.bottom + kBorderMargin, 72, 45)];
    
    if(_sendButton == nil)
    {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundImage:[[UIImage imageNamed:MJRefreshSrcName(@"BlueBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(onSendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_sendButton setTitle:@"写好了，发送" forState:UIControlStateNormal];
        [_bgImageView addSubview:_sendButton];
    }
    [_sendButton setFrame:CGRectMake(_bgImageView.width - 150 - kBorderMargin, _inputBG.bottom + kBorderMargin, 150, 45)];
}

#pragma mark KeyboardNotification
- (void)onKeyboardShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        _bgImageView.height = self.view.height - kBorderMargin * 2 - keyboardRect.size.height;
        [self setupSubviews];
    }];
}

- (void)onKeyboardHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        _bgImageView.height = self.view.height - kBorderMargin * 2;
        [self setupSubviews];
    }];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSwitch:(id)sender
{
    [self.view endEditing:YES];
    UIButton *button = (UIButton *)sender;
    if(_textView.alpha == 1.f)
    {
        [button setImage:[UIImage imageNamed:@"AudioSwitch.png"] forState:UIControlStateNormal];
        [_sendButton setTitle:@"录好了，发送" forState:UIControlStateNormal];
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"TextSwitch.png"] forState:UIControlStateNormal];
        [_sendButton setTitle:@"写好了，发送" forState:UIControlStateNormal];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [_textView setAlpha:1.f - _textView.alpha];
        [_recordView setAlpha:1.f - _recordView.alpha];
        [_numLabel setAlpha:1.f - _numLabel.alpha];
    }];
}

- (void)onSendButtonClicked
{
    [self.view endEditing:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.targetDic];
    if(_recordView.alpha ==1.f)
    {
        if([_recordView tmpAmrDuration] > 0)
            [params setObject:[NSString stringWithFormat:@"%ld",(long)[_recordView tmpAmrDuration]] forKey:@"voice_time"];
        else
        {
//            TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:nil];
//            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"请录入语音消息" buttonItems:@[item]];
//            [alertView show];
            [ProgressHUD showHintText:@"说点什么吧!"];
            return;
        }
    }
    if(_textView.alpha == 1.f)
    {
        if(_textView.text.length > 0)
            [params setValue:_textView.text forKey:@"words"];
        else
        {
//            TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:nil];
//            TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"请输入通知内容" buttonItems:@[item]];
//            [alertView show];
            [ProgressHUD showHintText:@"尚未填写消息内容"];
            return;
        }
    }
    
    NSString *url = nil;
    
    if([self.targetDic valueForKey:@"all_teachers"])
    {
        url = @"notice/publish";
    }
    else
    {
        if([self.targetDic valueForKey:@"class_id"])
            url = @"class/notice_students";
        else
            url = @"class/notice_classes";
    }
    
    MBProgressHUD *progressHud = [MBProgressHUD showMessag:@"正在发送" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:url withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(_recordView.alpha == 1.f)
            [formData appendPartWithFileData:[_recordView tmpAmrData] name:@"voice" fileName:@"voice" mimeType:@"audio/amr"];
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        [progressHud hide:YES];
        [MBProgressHUD showSuccess:@"发送成功" toView:self.view];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:2];
        if([self.targetDic valueForKey:@"all_teachers"])
            [CurrentROOTNavigationVC popToRootViewControllerAnimated:NO];
    } fail:^(NSString *errMsg) {
        [progressHud hide:YES];
        [ProgressHUD showHintText:errMsg];
    }];
    
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AudioRecordDelegate
- (void)audioRecordViewDidStartRecord:(AudioRecordView *)recordView
{
    [_sendButton setEnabled:NO];
}

- (void)audioRecordViewDidFinishedRecord:(AudioRecordView *)recordView
{
    [_sendButton setEnabled:YES];
}

- (void)audioRecordViewDidCancl:(AudioRecordView *)recordView
{
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = textView.text;
    
    if([text length] > kReportContentMaxNum)
        [textView setText:[text substringToIndex:kReportContentMaxNum]];
    [_numLabel setText:kStringFromValue(kReportContentMaxNum - textView.text.length)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end

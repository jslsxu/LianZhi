//
//  PublishHomeWorkAudioVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PublishHomeWorkAudioVC.h"

@interface PublishHomeWorkAudioVC ()<UITextViewDelegate>

@end

@implementation PublishHomeWorkAudioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发语音";
    
    _scrollView = [[UITouchScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_scrollView];
    
    _recordView = [[AudioRecordView alloc] initWithFrame:CGRectMake(10, 10, _scrollView.width - 10 * 2, _scrollView.width - 10 * 2)];
    [_scrollView addSubview:_recordView];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, _recordView.bottom + 10, _scrollView.width - 10 * 2, 60)];
    [_textView setDelegate:self];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setPlaceholder:@"作业描述"];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [_scrollView addSubview:_textView];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, _textView.bottom + 5, _scrollView.width - 10 * 2, 1)];
    [sepLine setBackgroundColor:kCommonTeacherTintColor];
    [_scrollView addSubview:sepLine];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"确认添加" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [sendButton addTarget:self action:@selector(onSendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setFrame:CGRectMake(10, sepLine.bottom + 30, _scrollView.width - 10 * 2, 36)];
    [sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed016"] size:sendButton.size cornerRadius:18] forState:UIControlStateNormal];
    [_scrollView addSubview:sendButton];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, MAX(self.view.height - 64, sendButton.bottom + 20))];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
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
    NSInteger keyboardHeight = keyboardRect.size.height;
    CGPoint textOrigin = [_textView convertPoint:CGPointZero toView:_scrollView];
    [UIView animateWithDuration:animationDuration animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight, 0)];
        [_scrollView setContentOffset:CGPointMake(0, textOrigin.y + _textView.height + keyboardHeight - _scrollView.height)];
    }completion:^(BOOL finished) {
    }];
}

- (void)onKeyboardHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [_scrollView setContentOffset:CGPointZero];
    }completion:^(BOOL finished) {
        [_scrollView setContentInset:UIEdgeInsetsZero];
    }];
}


- (void)onSendButtonClicked
{
    NSData *audioData = [_recordView tmpAmrData];
    NSInteger timeSpan = [_recordView tmpAmrDuration];
    if(timeSpan == 0 || audioData == nil)
    {
        [ProgressHUD showHintText:@"你还有录制语音"];
        return;
    }
    HomeWorkItem *homeWorkItem = [[HomeWorkItem alloc] init];
    [homeWorkItem setContent:_textView.text];
    [homeWorkItem setAudioData:audioData];
    [homeWorkItem setTimeSpan:timeSpan];
    if([self.delegate respondsToSelector:@selector(publishHomeWorkFinished:)])
        [self.delegate publishHomeWorkFinished:homeWorkItem];
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  AudioMessageSendVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AudioMessageSendVC.h"

@interface AudioMessageSendVC ()<UITextViewDelegate>

@end

@implementation AudioMessageSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"语音通知";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_scrollView setBounces:YES];
    [_scrollView setDelegate:self];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    _recordView = [[AudioRecordView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, (self.view.height - 64) / 2)];
    [_recordView setDelegate:self];
    if(self.amrData.length > 0 && self.duration > 0)
    {
        [_recordView setTmpAmrData:self.amrData];
        [_recordView setDuration:self.duration];
        [_recordView setRecordType:RecordTypePlay];
    }
    [_scrollView addSubview:_recordView];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, _recordView.bottom, self.view.width - 10 * 2, 60)];
    [_textView setDelegate:self];
    [_textView setPlaceholder:@"给录音起个标题吧"];
    [_textView setFont:[UIFont systemFontOfSize:16]];
    [_textView setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [_textView setText:self.words];
    [_scrollView addSubview:_textView];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, _textView.bottom + 10, self.view.width - 10 * 2, 1)];
    [sepLine setBackgroundColor:kCommonTeacherTintColor];
    [_scrollView addSubview:sepLine];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, MAX(sepLine.bottom, self.view.height - 64))];
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

- (BOOL)validate
{
    if(_recordView.tmpAmrDuration == 0 || _recordView.tmpAmrData)
    {
        [ProgressHUD showHintText:@"请录制要发布的语音"];
        return NO;
    }
    return YES;
}

- (NSDictionary *)params
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *content = _textView.text;
    if(content.length == 0)
        content = @"都来听听我说的语录";
    [dic setValue:content forKey:@"words"];
    [dic setValue:kStringFromValue(_recordView.tmpAmrDuration) forKey:@"voice_time"];
    return dic;
}

- (NSData *)audioData
{
    return _recordView.tmpAmrData;
}

#pragma mark 
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

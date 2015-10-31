//
//  PublishHomeWorkTextVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PublishHomeWorkTextVC.h"

#define kHomeWorkTextNumLength              500

@interface PublishHomeWorkTextVC ()<UITextViewDelegate>

@end

@implementation PublishHomeWorkTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发文字";
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 10 * 2, 80)];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setDelegate:self];
    [_textView setPlaceholder:@"请输入您要发布的内容"];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [self.view addSubview:_textView];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, _textView.bottom, self.view.width - 10 * 2, 1)];
    [sepLine setBackgroundColor:kCommonTeacherTintColor];
    [self.view addSubview:sepLine];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, sepLine.bottom, self.view.width - 10 * 2, 15)];
    [_numLabel setText:kStringFromValue(kHomeWorkTextNumLength)];
    [_numLabel setTextAlignment:NSTextAlignmentRight];
    [_numLabel setFont:[UIFont systemFontOfSize:12]];
    [_numLabel setTextColor:[UIColor colorWithHexString:@""]];
    [self.view addSubview:_numLabel];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(onSendButtonCLicked) forControlEvents:UIControlEventTouchUpInside];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [sendButton setTitle:@"确认添加" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake(10, _numLabel.bottom + 40, self.view.width - 10 * 2, 36)];
    [sendButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed016"] size:sendButton.size cornerRadius:18] forState:UIControlStateNormal];
    [self.view addSubview:sendButton];
}

- (void)onSendButtonCLicked
{
    HomeWorkItem *homeWorkItem = [[HomeWorkItem alloc] init];
    [homeWorkItem setContent:_textView.text];
    if([self.delegate respondsToSelector:@selector(publishHomeWorkFinished:)])
        [self.delegate publishHomeWorkFinished:homeWorkItem];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UItextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = textView.text;
    
    if([text length] > kHomeWorkTextNumLength)
        [textView setText:[text substringToIndex:kHomeWorkTextNumLength]];
    [_numLabel setText:kStringFromValue(kHomeWorkTextNumLength - textView.text.length)];
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

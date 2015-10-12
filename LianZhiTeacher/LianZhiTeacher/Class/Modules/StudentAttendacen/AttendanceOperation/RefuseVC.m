//
//  RefuseVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "RefuseVC.h"

#define kMaxWordsNum                    100

@interface RefuseVC ()<UITextViewDelegate>

@end

@implementation RefuseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _reasonType == ReasonTypeRefuse ? @"拒绝原因" : @"撤销原因";
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 10 * 2, 60)];
    [_textView setDelegate:self];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setPlaceholder:[NSString stringWithFormat:@"请向家长说明%@",self.title]];
    [self.view addSubview:_textView];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, _textView.bottom + 5, _textView.width, 1)];
    [sepLine setBackgroundColor:kCommonTeacherTintColor];
    [self.view addSubview:sepLine];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, sepLine.bottom, sepLine.width, 20)];
    [_numLabel setFont:[UIFont systemFontOfSize:14]];
    [_numLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
    [_numLabel setTextAlignment:NSTextAlignmentRight];
    [_numLabel setText:kStringFromValue(kMaxWordsNum)];
    [self.view addSubview:_numLabel];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton addTarget:self action:@selector(onConfirm) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton setFrame:CGRectMake(10, _numLabel.bottom + 20, self.view.width - 10 * 2, 34)];
    [confirmButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed016"] size:confirmButton.size cornerRadius:confirmButton.height / 2] forState:UIControlStateNormal];
    [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    if(self.reasonType == ReasonTypeRefuse)
        [confirmButton setTitle:@"确定拒绝" forState:UIControlStateNormal];
    else
        [confirmButton setTitle:@"确定撤销" forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
}
- (void)onConfirm
{
    if(self.reasonType == ReasonTypeRefuse)
    {
        
    }
    else
    {
        
    }
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
    NSString *text = [textView text];
    
    if(text.length > kMaxWordsNum)
        [textView setText:[text substringToIndex:kMaxWordsNum]];
    [_numLabel setText:kStringFromValue(kMaxWordsNum - textView.text.length)];
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

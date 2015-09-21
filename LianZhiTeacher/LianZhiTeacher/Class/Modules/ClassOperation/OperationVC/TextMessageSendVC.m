//
//  MessageOperationVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TextMessageSendVC.h"
#define kReportContentMaxNum                    120
#define kBorderMargin                           15
@implementation TextMessageSendVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息通知";
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 140)];
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bgView];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, _bgView.width - 10 * 2, _bgView.height - 10 - 5 - 20)];
    [_textView setDelegate:self];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setPlaceholder:@"请输入您要发布的内容"];
    [_bgView addSubview:_textView];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, _textView.bottom + 5, _textView.width, 1)];
    [sepLine setBackgroundColor:kCommonTeacherTintColor];
    [_bgView addSubview:sepLine];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, sepLine.bottom, sepLine.width, 20)];
    [_numLabel setFont:[UIFont systemFontOfSize:14]];
    [_numLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
    [_numLabel setTextAlignment:NSTextAlignmentRight];
    [_numLabel setText:kStringFromValue(kReportContentMaxNum)];
    [_bgView addSubview:_numLabel];
    
//    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_checkButton setFrame:CGRectMake(0, _bgView.bottom, 30, 30)];
//    [_checkButton setImage:[UIImage imageNamed:@"StudentUnselected"] forState:UIControlStateNormal];
//    [_checkButton setImage:[UIImage imageNamed:@"StudentSelected"] forState:UIControlStateSelected];
//    [_checkButton addTarget:self action:@selector(onCheckClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_checkButton];
//    
//    _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(_checkButton.right, _bgView.bottom, self.view.width - 10 - _checkButton.right, 30)];
//    [_hintLabel setFont:[UIFont systemFontOfSize:16]];
//    [_hintLabel setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
//    [_hintLabel setText:@"以短信的形式发送"];
//    [self.view addSubview:_hintLabel];
//    
//    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_checkButton.right, _hintLabel.bottom, _hintLabel.width, 60)];
//    [detailLabel setNumberOfLines:0];
//    [detailLabel setFont:[UIFont systemFontOfSize:13]];
//    [detailLabel setTextColor:[UIColor colorWithHexString:@"8f8f8f"]];
//    [detailLabel setText:@"开启短信模式后，未开通炼制的用户也将以短信的形式受到通知，请将文字内容控制在120字以内"];
//    [self.view addSubview:detailLabel];
}

//- (void)onCheckClicked
//{
//    _checkButton.selected = !_checkButton.selected;
//}

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

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
    _recordView = [[AudioRecordView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, (self.view.height - 64) / 2)];
    [_recordView setDelegate:self];
    if(self.amrData.length > 0 && self.duration > 0)
    {
        [_recordView setTmpAmrData:self.amrData];
        [_recordView setDuration:self.duration];
        [_recordView setRecordType:RecordTypePlay];
    }
    [self.view addSubview:_recordView];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, _recordView.bottom, self.view.width - 10 * 2, 60)];
    [_textView setDelegate:self];
    [_textView setPlaceholder:@"给录音起个标题吧"];
    [_textView setFont:[UIFont systemFontOfSize:16]];
    [_textView setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [_textView setText:self.words];
    [self.view addSubview:_textView];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, _textView.bottom + 10, self.view.width - 10 * 2, 1)];
    [sepLine setBackgroundColor:kCommonTeacherTintColor];
    [self.view addSubview:sepLine];
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

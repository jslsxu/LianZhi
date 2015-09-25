//
//  AudioMessageSendVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "AudioMessageSendVC.h"

@interface AudioMessageSendVC ()

@end

@implementation AudioMessageSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"语音通知";
    _recordView = [[AudioRecordView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, (self.view.height - 64) / 2)];
    [_recordView setDelegate:self];
    [self.view addSubview:_recordView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, _recordView.bottom, _recordView.width, 40)];
    [_textField setPlaceholder:@"给录音起个标题吧"];
    [_textField setFont:[UIFont systemFontOfSize:16]];
    [_textField setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [self.view addSubview:_textField];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, _textField.bottom, _recordView.width, 1)];
    [sepLine setBackgroundColor:kCommonTeacherTintColor];
    [self.view addSubview:sepLine];
}

- (NSDictionary *)params
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[_textField text] forKey:@"words"];
    [dic setValue:kStringFromValue(_recordView.tmpAmrDuration) forKey:@"voice_time"];
    return dic;
}

- (NSData *)audioData
{
    return _recordView.tmpAmrData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  PublishAudioVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishAudioVC.h"

#define kBorderMargin              15

@interface PublishAudioVC ()<UITextFieldDelegate>

@end

@implementation PublishAudioVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发语音";
}

- (void)setupSubviews
{
    _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [_bgImageView setUserInteractionEnabled:YES];
    [_bgImageView setFrame:CGRectInset(self.view.bounds, kBorderMargin, kBorderMargin)];
    [self.view addSubview:_bgImageView];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendButton setFrame:CGRectMake(kBorderMargin, _bgImageView.height - 45 - kBorderMargin, _bgImageView.width - kBorderMargin * 2, 45)];
    [_sendButton addTarget:self action:@selector(onSendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton setBackgroundImage:[[UIImage imageNamed:MJRefreshSrcName(@"GreenBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton.titleLabel setFont:kButtonTextFont];
    [_sendButton setTitle:@"录好了，发送" forState:UIControlStateNormal];
    [_bgImageView addSubview:_sendButton];
    
    _whiteBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [_whiteBG setFrame:CGRectMake(kBorderMargin, kBorderMargin, _bgImageView.width - kBorderMargin * 2, _sendButton.y - kBorderMargin * 2)];
    [_whiteBG setUserInteractionEnabled:YES];
    [_bgImageView addSubview:_whiteBG];
    
    _poiInfoView = [[PoiInfoView alloc] initWithFrame:CGRectMake(0, _whiteBG.height - 40, _whiteBG.width, 40)];
    [_poiInfoView setParentVC:self];
    [_whiteBG addSubview:_poiInfoView];
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, _whiteBG.height - 40 * 2, _whiteBG.width, 40)];
    [self setupTitleView:_titleView];
    [_whiteBG addSubview:_titleView];
    
    _recordView = [[AudioRecordView alloc] initWithFrame:CGRectMake(0, 0, _whiteBG.width, _whiteBG.height - 40 * 2)];
    [_recordView setDelegate:self];
    [_whiteBG addSubview:_recordView];

}

- (void)setupTitleView:(UIView *)viewParent
{
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewParent.width, 1)];
    [sepLine setBackgroundColor:kSepLineColor];
    [viewParent addSubview:sepLine];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, viewParent.width - 5 * 2, viewParent.height - 10)];
    [_textField addTarget:self action:@selector(onTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_textField setTextAlignment:NSTextAlignmentCenter];
    [_textField setBackgroundColor:[UIColor clearColor]];
    [_textField setFont:[UIFont systemFontOfSize:14]];
    [_textField setTextColor:kNormalTextColor];
    [_textField setReturnKeyType:UIReturnKeyDone];
    [_textField setPlaceholder:@"点此输入，给录音起个标题吧!"];
    [_textField setDelegate:self];
    [viewParent addSubview:_textField];
    
}

- (void)onSendButtonClicked{
    NSData *amrData = [_recordView tmpAmrData];
    if(amrData.length > 0)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:_textField.text forKey:@"words"];
        [params setValue:kStringFromValue([_recordView tmpAmrDuration]) forKey:@"voice_time"];
        
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/post_content" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:amrData name:@"voice" fileName:@"voice" mimeType:@"audio/AMR"];
        } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            TNDataWrapper *infoWrapper = [responseObject getDataWrapperForKey:@"info"];
            if(infoWrapper.count > 0)
            {
                TreehouseItem *item = [[TreehouseItem alloc] init];
                [item parseData:infoWrapper];
                
                if([self.delegate respondsToSelector:@selector(publishTreeHouseSuccess:)])
                    [self.delegate publishTreeHouseSuccess:item];
            }
            [ProgressHUD showSuccess:@"发布成功"];
            [self performSelector:@selector(onBack) withObject:nil afterDelay:2];
        } fail:^(NSString *errMsg) {
            [self showError];
        }];
    }
    else
    {
//        TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:nil];
//        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"你还没有录音" buttonItems:@[item]];
//        [alertView show];
        [ProgressHUD showHintText:@"说点什么吧!"];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

- (void)onTextFieldChanged:(UITextField *)textField
{
    NSString *text = textField.text;
    if(text.length > 200)
        [textField setText:[text substringToIndex:200]];
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
        _bgImageView.bottom = self.view.height - keyboardRect.size.height;
    }];
}

- (void)onKeyboardHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        _bgImageView.y = kBorderMargin;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

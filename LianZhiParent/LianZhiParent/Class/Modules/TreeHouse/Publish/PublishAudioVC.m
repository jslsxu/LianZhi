//
//  PublishAudioVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishAudioVC.h"

#define kBorderMargin              15

@interface PublishAudioVC ()<UITextViewDelegate>

@end

@implementation PublishAudioVC

- (void)dealloc
{
    [_recordView dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    self.title = @"发语音";
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

- (void)setupSubviews
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64)];
    [_scrollView setBounces:YES];
    [_scrollView setAlwaysBounceVertical:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scrollView];
    
    _recordView = [[AudioRecordView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, (self.view.height - 64) / 2)];
    if(self.amrData && self.duration > 0)
    {
        [_recordView setTmpAmrData:self.amrData];
        [_recordView setDuration:self.duration];
        [_recordView setRecordType:RecordTypePlay];
    }
    [_recordView setDelegate:self];
    [_scrollView addSubview:_recordView];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(15, _recordView.bottom, self.view.width - 15 * 2, 60)];
    [_textView setDelegate:self];
    [_textView setPlaceholder:@"给录音起个标题吧"];
    [_textView setText:self.words];
    [_textView setFont:[UIFont systemFontOfSize:16]];
    [_textView setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [_scrollView addSubview:_textView];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(15, _textView.bottom, _textView.width, 1)];
    [sepLine setBackgroundColor:kCommonParentTintColor];
    [_scrollView addSubview:sepLine];
    
    _poiInfoView = [[PoiInfoView alloc] initWithFrame:CGRectMake(20, sepLine.bottom, self.view.width - 20 * 2, 40)];
    [_poiInfoView setParentVC:self];
    if(self.poiItem)
        [_poiInfoView setPoiItem:self.poiItem];
    [_scrollView addSubview:_poiInfoView];

    [_scrollView setContentSize:CGSizeMake(_scrollView.width, MAX(_poiInfoView.bottom, self.view.height - 64))];
}

- (void)onSendClicked
{
    NSData *amrData = [_recordView tmpAmrData];
    if(amrData.length > 0 && [_recordView tmpAmrDuration] > 0)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:_textView.text forKey:@"words"];
        [params setValue:kStringFromValue([_recordView tmpAmrDuration]) forKey:@"voice_time"];
        POIItem *poiItem = _poiInfoView.poiItem;
        if(!poiItem.clearLocation)
        {
            [params setValue:poiItem.poiInfo.name forKey:@"position"];
            [params setValue:kStringFromValue(poiItem.poiInfo.location.latitude) forKey:@"latitude"];
            [params setValue:kStringFromValue(poiItem.poiInfo.location.longitude) forKey:@"longitude"];
        }
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
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//#pragma mark KeyboardNotification
//- (void)onKeyboardShow:(NSNotification *)notification
//{
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    [UIView animateWithDuration:animationDuration animations:^{
//        _bgImageView.bottom = self.view.height - keyboardRect.size.height;
//    }];
//}
//
//- (void)onKeyboardHide:(NSNotification *)notification
//{
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    [UIView animateWithDuration:animationDuration animations:^{
//        _bgImageView.y = kBorderMargin;
//    }];
//}
//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

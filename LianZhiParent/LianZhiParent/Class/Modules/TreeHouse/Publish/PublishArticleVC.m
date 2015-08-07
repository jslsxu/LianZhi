//
//  PulishArticleVC.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishArticleVC.h"

#define kBorderMargin               15

@interface PublishArticleVC ()<UITextViewDelegate>

@end

@implementation PublishArticleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发文章";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupSubviews
{
    _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [_bgImageView setUserInteractionEnabled:YES];
    [_bgImageView setFrame:CGRectMake(kBorderMargin, kBorderMargin, self.view.width - kBorderMargin * 2, self.view.height - kBorderMargin * 2)];
    [self.view addSubview:_bgImageView];
    
    _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishButton setFrame:CGRectMake(kBorderMargin, _bgImageView.height - kBorderMargin - 45, _bgImageView.width - kBorderMargin * 2, 45)];
    [_publishButton addTarget:self action:@selector(onPublishClicked) forControlEvents:UIControlEventTouchUpInside];
    [_publishButton setBackgroundImage:[[UIImage imageNamed:MJRefreshSrcName(@"GreenBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishButton.titleLabel setFont:kButtonTextFont];
    [_publishButton setTitle:@"写好了，发送" forState:UIControlStateNormal];
    [_bgImageView addSubview:_publishButton];
    
    _textBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:MJRefreshSrcName(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [_textBG setUserInteractionEnabled:YES];
    [_textBG setFrame:CGRectMake(kBorderMargin, kBorderMargin, _bgImageView.width - kBorderMargin * 2, _bgImageView.height - kBorderMargin * 3 - _publishButton.height)];
    [_bgImageView addSubview:_textBG];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(5, 5, _textBG.width - 5 * 2, _textBG.height - 5 - 40)];
    [_textView setPlaceholder:@"请输入您要发布的内容"];
    [_textView setDelegate:self];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textBG addSubview:_textView];
    
    
    _poiInfoView = [[PoiInfoView alloc] initWithFrame:CGRectMake(0, _textView.bottom, _textBG.width, 40)];
    [_placeHolder setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [_poiInfoView setParentVC:self];
    [_textBG addSubview:_poiInfoView];
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
        [_textBG setHeight:_bgImageView.height - kBorderMargin * 3 - _publishButton.height];
        [_textView setHeight:_textBG.height - 5 - 40];
        [_poiInfoView setY:_textView.bottom];
        [_publishButton setY:_bgImageView.height - kBorderMargin - 45];
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
        [_textBG setHeight:_bgImageView.height - kBorderMargin * 3 - _publishButton.height];
        [_textView setHeight:_textBG.height - 5 - 40];
        [_poiInfoView setY:_textView.bottom];
        [_publishButton setY:_bgImageView.height - kBorderMargin - 45];
    }];
}


- (void)onPublishClicked
{
    [self.view endEditing:YES];
    NSString *publishText = [_textView text];
    if(publishText.length > 0)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:publishText forKey:@"words"];
        
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在发送" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/post_content" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            TNDataWrapper *infoWrapper = [responseObject getDataWrapperForKey:@"info"];
            if(infoWrapper.count > 0)
            {
                TreehouseItem *item = [[TreehouseItem alloc] init];
                [item parseData:infoWrapper];
                if([self.delegate respondsToSelector:@selector(publishTreeHouseSuccess:)])
                    [self.delegate publishTreeHouseSuccess:item];
                
            }
            [hud hide:NO];
            [ProgressHUD showSuccess:@"发布成功"];
            [self performSelector:@selector(onBack) withObject:nil afterDelay:2];
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
            [ProgressHUD showHintText:errMsg];
        }];
    }
    else
    {
        [ProgressHUD showHintText:@"尚未填写消息内容"];
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
    [_placeHolder setHidden:text.length != 0];
    
    if(text.length > kCommonMaxNum)
        [textView setText:[text substringToIndex:kCommonMaxNum]];
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

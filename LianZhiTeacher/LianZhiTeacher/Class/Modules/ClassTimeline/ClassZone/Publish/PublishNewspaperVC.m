//
//  PublishNewspaperVC.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PublishNewspaperVC.h"
#define kBorderMargin               15

#define kNewpaperMaxNum             70
@interface PublishNewspaperVC()<UITextViewDelegate>
@end

@implementation PublishNewspaperVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"黑板报";
    self.navigationItem.rightBarButtonItem = nil;
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, self.view.width - 10 * 2, 100)];
    [_textView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [_textView.layer setCornerRadius:10];
    [_textView.layer setMasksToBounds:YES];
    [_textView setDelegate:self];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setText:self.newsPaper];
    [self.view addSubview:_textView];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 10 - 60, _textView.bottom, 60, 30)];
    [_numLabel setTextColor:[UIColor lightGrayColor]];
    [_numLabel setFont:[UIFont systemFontOfSize:12]];
    [_numLabel setTextAlignment:NSTextAlignmentRight];
    [_numLabel setText:kStringFromValue(kNewpaperMaxNum - _textView.text.length)];
    [self.view addSubview:_numLabel];
    
    _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contactButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_contactButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_contactButton setTitleColor:[UIColor colorWithHexString:@"8f8f8f"] forState:UIControlStateNormal];
    [_contactButton setTitle:@"发通知" forState:UIControlStateNormal];
    [_contactButton addTarget:self action:@selector(onContactButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_contactButton setImage:[UIImage imageNamed:@"ControlDefault"] forState:UIControlStateNormal];
    [_contactButton setImage:[UIImage imageNamed:@"ControlSelectAll"] forState:UIControlStateSelected];
    [_contactButton setFrame:CGRectMake(10, _textView.bottom, 70, 30)];
    [self.view addSubview:_contactButton];
    
    
    _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishButton setFrame:CGRectMake(20, _textView.bottom + 50, self.view.width - 20 * 2, 36)];
    [_publishButton addTarget:self action:@selector(onPublishClicked) forControlEvents:UIControlEventTouchUpInside];
    [_publishButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"5ed015"] size:_publishButton.size cornerRadius:18] forState:UIControlStateNormal];
    [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_publishButton setTitle:@"写好了，公布" forState:UIControlStateNormal];
    [self.view addSubview:_publishButton];
    
    [self textViewDidChange:_textView];
}

- (void)onContactButtonClicked
{
    _contactButton.selected = !_contactButton.selected;
}

- (void)onPublishClicked
{
    [self.view endEditing:YES];
    NSString *publishText = [_textView text];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [params setValue:publishText forKey:@"words"];
    [params setValue:kStringFromValue(_contactButton.selected) forKey:@"if_notice"];
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在发布" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/update_newspaper" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if([self.delegate respondsToSelector:@selector(publishNewsPaperFinished:)])
        {
            NSString *newpaper = publishText;
            if(newpaper.length == 0)
            {
                newpaper = [NSString stringWithFormat:@"热烈庆祝我们班率先引用连枝APP智能客户端这里是我们 %@ 的掌上根据地。就让我们一起努力经营好这个大家庭吧",self.classInfo.name];
            }
            [self.delegate publishNewsPaperFinished:newpaper];
        }
        [hud hide:YES];
        [MBProgressHUD showSuccess:@"黑板报发布成功" toView:self.view];
        [self performSelector:@selector(onBack) withObject:nil afterDelay:1.5];
    } fail:^(NSString *errMsg) {
        [hud hide:YES];
        [MBProgressHUD showError:errMsg toView:self.view];
    }];
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
    NSString *text = textView.text;
    NSInteger num = [text length];
    if(num > kNewpaperMaxNum)
        [textView setText:[text substringToIndex:kNewpaperMaxNum]];
    [_numLabel setText:kStringFromValue(kNewpaperMaxNum - [textView.text length])];
}


@end

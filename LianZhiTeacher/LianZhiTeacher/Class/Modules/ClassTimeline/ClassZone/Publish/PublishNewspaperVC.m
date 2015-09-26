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
@property (nonatomic, assign)BOOL sendNotification;
@end

@implementation PublishNewspaperVC
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"黑板报";
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [bgImageView setUserInteractionEnabled:YES];
    [bgImageView setFrame:CGRectMake(kBorderMargin, kBorderMargin, self.view.width - kBorderMargin * 2, 240)];
    [self.view addSubview:bgImageView];
    
    CGFloat width = bgImageView.width - kBorderMargin * 3;
    _notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_notificationButton addTarget:self action:@selector(onNotificationClicked) forControlEvents:UIControlEventTouchUpInside];
    [_notificationButton setImage:[UIImage imageNamed:@"NotNotification.png"] forState:UIControlStateNormal];
    [_notificationButton setFrame:CGRectMake(kBorderMargin, bgImageView.height - kBorderMargin - 45, width / 3, 45)];
    [bgImageView addSubview:_notificationButton];
    
    
    _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishButton setFrame:CGRectMake(_notificationButton.right + kBorderMargin, _notificationButton.y, width * 2 / 3, 45)];
    [_publishButton addTarget:self action:@selector(onPublishClicked) forControlEvents:UIControlEventTouchUpInside];
    [_publishButton setBackgroundImage:[UIImage imageWithColor:kCommonTeacherTintColor size:_publishButton.size cornerRadius:5] forState:UIControlStateNormal];
    [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishButton.titleLabel setFont:kButtonTextFont];
    [_publishButton setTitle:@"写好了，公布" forState:UIControlStateNormal];
    [bgImageView addSubview:_publishButton];
    
    UIImageView *textBG = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:(@"WhiteBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    [textBG setUserInteractionEnabled:YES];
    [textBG setFrame:CGRectMake(kBorderMargin, kBorderMargin, bgImageView.width - kBorderMargin * 2, bgImageView.height - kBorderMargin * 3 - _publishButton.height)];
    [bgImageView addSubview:textBG];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, textBG.width - 5 * 2, textBG.height - 5 - 20)];
    [_textView setDelegate:self];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setText:self.newsPaper];
    [textBG addSubview:_textView];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(_textView.left, _textView.bottom, _textView.width, 20)];
    [_numLabel setTextColor:[UIColor lightGrayColor]];
    [_numLabel setFont:[UIFont systemFontOfSize:14]];
    [_numLabel setTextAlignment:NSTextAlignmentRight];
    [_numLabel setText:kStringFromValue(kNewpaperMaxNum - _textView.text.length)];
    [textBG addSubview:_numLabel];
    
//    _placeHolder = [[UILabel alloc] initWithFrame:CGRectZero];
//    [_placeHolder setUserInteractionEnabled:NO];
//    [_placeHolder setBackgroundColor:[UIColor clearColor]];
//    [_placeHolder setFont:_textView.font];
//    [_placeHolder setTextColor:[UIColor lightGrayColor]];
//    [_placeHolder setText:[NSString stringWithFormat:@"快为%@编写黑板报吧",self.classInfo.className]];
//    [_placeHolder sizeToFit];
//    [_placeHolder setOrigin:CGPointMake(2, 6)];
//    [_textView addSubview:_placeHolder];
}

- (void)onNotificationClicked
{
    self.sendNotification = !self.sendNotification;
    if(self.sendNotification)
        [_notificationButton setImage:[UIImage imageNamed:@"SendNotification.png"] forState:UIControlStateNormal];
    else
        [_notificationButton setImage:[UIImage imageNamed:@"NotNotification.png"] forState:UIControlStateNormal];
}

- (void)onPublishClicked
{
    [self.view endEditing:YES];
    NSString *publishText = [_textView text];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.classInfo.classID forKey:@"class_id"];
    [params setValue:publishText forKey:@"words"];
    [params setValue:kStringFromValue(self.sendNotification) forKey:@"if_notice"];
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在发布" toView:self.view];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/update_newspaper" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        if([self.delegate respondsToSelector:@selector(publishNewsPaperFinished:)])
        {
            NSString *newpaper = publishText;
            if(newpaper.length == 0)
            {
                newpaper = [NSString stringWithFormat:@"热烈庆祝我们班率先引用连枝APP智能客户端这里是我们 %@ 的掌上根据地。就让我们一起努力经营好这个大家庭吧",self.classInfo.className];
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

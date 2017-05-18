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
    self.title = @"发文字";
}

- (void)setupSubviews
{
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 10 * 2, 100)];
    [_textView setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
    [_textView.layer setCornerRadius:10];
    [_textView.layer setMasksToBounds:YES];
    [_textView setReturnKeyType:UIReturnKeyDone];
    [_textView setDelegate:self];
    [_textView setFont:[UIFont systemFontOfSize:14]];
    [_textView setPlaceholder:[NSString stringWithFormat:@"快为%@记录下美好时光",[UserCenter sharedInstance].curChild.name]];
    [self.view addSubview:_textView];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 10 - 60, _textView.bottom, 60, 40)];
    [_numLabel setFont:[UIFont systemFontOfSize:14]];
    [_numLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
    [_numLabel setTextAlignment:NSTextAlignmentRight];
    [_numLabel setText:kStringFromValue(kCommonMaxNum)];
    [self.view addSubview:_numLabel];
    
    [_textView setText:self.words];
    [self textViewDidChange:_textView];
    
    _poiInfoView = [[PoiInfoView alloc] initWithFrame:CGRectMake(0, _textView.bottom, _numLabel.x, 40)];
    [_poiInfoView setParentVC:self];
    if(self.poiItem)
        [_poiInfoView setPoiItem:self.poiItem];
    [self.view addSubview:_poiInfoView];
}

- (void)onSendClicked
{
    [self.view endEditing:YES];
    NSString *publishText = [_textView text];
    if(publishText.length > 0)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:publishText forKey:@"words"];
        [params setValue:kStringFromValue(self.forward) forKey:@"forward"];
        POIItem *poiItem = _poiInfoView.poiItem;
        if(!poiItem.clearLocation)
        {
            [params setValue:poiItem.poiInfo.name forKey:@"position"];
            [params setValue:kStringFromValue(poiItem.poiInfo.location.latitude) forKey:@"latitude"];
            [params setValue:kStringFromValue(poiItem.poiInfo.location.longitude) forKey:@"longitude"];
        }
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在发送" toView:[UIApplication sharedApplication].keyWindow];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"tree/post_content" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            TNDataWrapper *infoWrapper = [responseObject getDataWrapperForKey:@"info"];
            if(infoWrapper.count > 0)
            {
                TreehouseItem *item = [[TreehouseItem alloc] init];
                [item parseData:infoWrapper];
                [[NSNotificationCenter defaultCenter] postNotificationName:kPublishPhotoItemFinishedNotification object:nil userInfo:@{kPublishPhotoItemKey : item}];
                
            }
            [hud hide:NO];
            [ProgressHUD showSuccess:@"发布成功"];
            [self back];
        } fail:^(NSString *errMsg) {
            [hud hide:NO];
            [ProgressHUD showError:errMsg];
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
    if(text.length > kCommonMaxNum)
        [textView setText:[text substringToIndex:kCommonMaxNum]];
    [_numLabel setText:[NSString stringWithFormat:@"%ld",(long)(kCommonMaxNum - textView.text.length)]];
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

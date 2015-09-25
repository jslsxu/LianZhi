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
    [self.view setBackgroundColor:kCommonBackgroundColor];
}

- (void)setupSubviews
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 180)];
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_bgView];
    
    _textView = [[UTPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, _bgView.width - 10 * 2, _bgView.height - 10 - 5 - 20 - 40)];
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
    [_numLabel setText:kStringFromValue(kCommonMaxNum)];
    [_bgView addSubview:_numLabel];
    
    
    _poiInfoView = [[PoiInfoView alloc] initWithFrame:CGRectMake(0, _numLabel.bottom, _bgView.width, 40)];
    [_poiInfoView setParentVC:self];
    [_bgView addSubview:_poiInfoView];
}

- (void)onSendClicked
{
    [self.view endEditing:YES];
    NSString *publishText = [_textView text];
    if(publishText.length > 0)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.classInfo.classID forKey:@"class_id"];
        [params setValue:publishText forKey:@"words"];
        POIItem *poiItem = _poiInfoView.poiItem;
        if(!poiItem.clearLocation)
        {
            [params setValue:poiItem.poiInfo.name forKey:@"position"];
            [params setValue:kStringFromValue(poiItem.poiInfo.location.latitude) forKey:@"latitude"];
            [params setValue:kStringFromValue(poiItem.poiInfo.location.longitude) forKey:@"longitude"];
        }
        MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在发送" toView:self.view];
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/post_content" method:REQUEST_POST type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
            TNDataWrapper *infoWrapper = [responseObject getDataWrapperForKey:@"info"];
            if(infoWrapper.count > 0)
            {
                ClassZoneItem *zoneItem = [[ClassZoneItem alloc] init];
                [zoneItem parseData:infoWrapper];
                
                if([self.delegate respondsToSelector:@selector(publishZoneItemFinished:)])
                    [self.delegate publishZoneItemFinished:zoneItem];
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
//        TNButtonItem *item = [TNButtonItem itemWithTitle:@"确定" action:nil];
//        TNAlertView *alertView = [[TNAlertView alloc] initWithTitle:@"请输入发送文字" buttonItems:@[item]];
//        [alertView show];
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
    [_numLabel setText:kStringFromValue(kCommonMaxNum - textView.text.length)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

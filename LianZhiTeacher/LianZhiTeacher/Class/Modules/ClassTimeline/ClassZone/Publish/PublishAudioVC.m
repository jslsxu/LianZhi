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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发语音";
}

- (void)setupSubviews
{
    _recordView = [[AudioRecordView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, (self.view.height - 64) / 2)];
    [_recordView setDelegate:self];
    [self.view addSubview:_recordView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, _recordView.bottom, self.view.width - 15 * 2, 40)];
    [_textField setPlaceholder:@"给录音起个标题吧"];
    [_textField setFont:[UIFont systemFontOfSize:16]];
    [_textField setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
    [self.view addSubview:_textField];
    
    UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(15, _textField.bottom, _textField.width, 1)];
    [sepLine setBackgroundColor:kCommonTeacherTintColor];
    [self.view addSubview:sepLine];
    
    _poiInfoView = [[PoiInfoView alloc] initWithFrame:CGRectMake(20, sepLine.bottom, self.view.width - 20 * 2, 40)];
    [_poiInfoView setParentVC:self];
    [self.view addSubview:_poiInfoView];
    
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

- (void)onSendClicked
{
    NSData *amrData = [_recordView tmpAmrData];
    if(amrData.length > 0)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.classInfo.classID forKey:@"class_id"];
        [params setValue:_textField.text forKey:@"words"];
        [params setValue:kStringFromValue([_recordView tmpAmrDuration]) forKey:@"voice_time"];
        POIItem *poiItem = _poiInfoView.poiItem;
        if(!poiItem.clearLocation)
        {
            [params setValue:poiItem.poiInfo.name forKey:@"position"];
            [params setValue:kStringFromValue(poiItem.poiInfo.location.latitude) forKey:@"latitude"];
            [params setValue:kStringFromValue(poiItem.poiInfo.location.longitude) forKey:@"longitude"];
        }
        [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"class/post_content" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:amrData name:@"voice" fileName:@"voice" mimeType:@"audio/AMR"];
        } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
             TNDataWrapper *infoWrapper = [responseObject getDataWrapperForKey:@"info"];
            if(infoWrapper.count > 0)
            {
                ClassZoneItem *zoneItem = [[ClassZoneItem alloc] init];
                [zoneItem parseData:infoWrapper];
                
                if([self.delegate respondsToSelector:@selector(publishZoneItemFinished:)])
                    [self.delegate publishZoneItemFinished:zoneItem];
            }
            [ProgressHUD showSuccess:@"发布成功"];
            [self performSelector:@selector(onBack) withObject:nil afterDelay:2];
        } fail:^(NSString *errMsg) {
            [self showError];
        }];
    }
    else
    {
        [ProgressHUD showHintText:@"说点什么吧!"];
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

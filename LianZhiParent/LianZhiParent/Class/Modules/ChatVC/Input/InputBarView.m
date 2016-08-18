//
//  InputBarView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "InputBarView.h"
#import "MyGiftVC.h"
#import "VideoRecordView.h"
#import "ClassMemberVC.h"
#import "NHFileManager.h"
#import "PhotoItem.h"
#define kContentViewHeight                  48
#define kButtonWidth                        30
#define kButtonHeight                       30

#define kInputViewVMargin                   7
#define kInputViewheight                    34

#define kButtonMargin                       5

#define kTextFont                           [UIFont systemFontOfSize:15]

@interface InputBarView ()<PhotoPickerVCDelegate>
@property (nonatomic,assign)NSInteger targetHeight;
@property (nonatomic, strong)NSMutableArray *atArray;
@end

@implementation InputBarView

- (void)dealloc
{
    [self removeNotifications];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentViewHeight)];
    if(self)
    {
        self.inputType = InputTypeNone;
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kContentViewHeight)];
        [_contentView setBackgroundColor:[UIColor colorWithHexString:@"c8d7e2"]];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLineHeight)];
        [topLine setBackgroundColor:[UIColor colorWithHexString:@"A4A4A4"]];
        [_contentView addSubview:topLine];
        
        [self addSubview:_contentView];
        
        _soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_soundButton setImage:[UIImage imageNamed:@"SoundIconNormal"] forState:UIControlStateNormal];
        [_soundButton addTarget:self action:@selector(onKeyboardTypeChanged:) forControlEvents:UIControlEventTouchUpInside];
        [_soundButton setFrame:CGRectMake(5, (_contentView.height - kButtonWidth) / 2 , kButtonWidth, kButtonHeight)];
        [_contentView addSubview:_soundButton];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setImage:[UIImage imageNamed:@"AddIconNormal"] forState:UIControlStateNormal];
        [_addButton setFrame:CGRectMake(_contentView.width - kButtonWidth - kButtonMargin, (_contentView.height - kButtonHeight) / 2, kButtonWidth, kButtonHeight)];
        [_addButton addTarget:self action:@selector(onKeyboardTypeChanged:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_addButton];
        
        // 键盘切换按钮
        _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exchangeButton setImage:[UIImage imageNamed:@"FaceIconNormal"] forState:UIControlStateNormal];
        [_exchangeButton setFrame:CGRectMake(_addButton.x - kButtonMargin - kButtonWidth, (_contentView.height - kButtonHeight) / 2, kButtonWidth, kButtonHeight)];
        [_exchangeButton addTarget:self action:@selector(onKeyboardTypeChanged:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_exchangeButton];
        
        // 设置TextView
        _inputView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(_soundButton.right + 10, kInputViewVMargin, _exchangeButton.x - 10 - (_soundButton.right + 10), kInputViewheight)];
        [_inputView.layer setCornerRadius:4];
        [_inputView.layer setBorderWidth:0.5];
        [_inputView.layer setBorderColor:[UIColor colorWithHexString:@"A4A4A4"].CGColor];
        [_inputView.layer setMasksToBounds:YES];
        [_inputView setBackgroundColor:[UIColor whiteColor]];
        [_inputView setFont:kTextFont];
        [_inputView setMinHeight:kInputViewheight];
        [_inputView setMinNumberOfLines:0];
        [_inputView setMaxNumberOfLines:5];
        [_inputView setReturnKeyType:UIReturnKeySend];
        [[_inputView internalTextView] setScrollIndicatorInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
        [_inputView setDelegate:self];
        [_contentView addSubview:_inputView];
        
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setFrame:_inputView.frame];
        [_recordButton setHidden:YES];
        [_recordButton.layer setCornerRadius:4];
        [_recordButton.layer setBorderWidth:0.5];
        [_recordButton.layer setBorderColor:[UIColor colorWithHexString:@"A4A4A4"].CGColor];
        [_recordButton.layer setMasksToBounds:YES];
        [_recordButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:_inputView.size] forState:UIControlStateHighlighted];
        [_recordButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:_inputView.size] forState:UIControlStateNormal];
        [_recordButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_recordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_recordButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_recordButton setTitle:@"按下 说话" forState:UIControlStateNormal];
        [_recordButton setTitle:@"松开 发送" forState:UIControlStateHighlighted];
        [_recordButton addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_recordButton addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_recordButton addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [_contentView addSubview:_recordButton];
        
        _faceSelectView = [[FaceSelectView alloc] initWithFrame:CGRectMake(0, _contentView.height, kScreenWidth, FaceSelectHeight)];
        [self addSubview:_faceSelectView];
        _faceSelectView.delegate = self;
        
        _functionView = [[FunctionView alloc] initWithFrame:CGRectMake(0, _contentView.height, self.width, 180)];
        [_functionView setDelegate:self];
        [self addSubview:_functionView];
        
        [self addNotifications];
    }
    return self;
}

- (NSMutableArray *)atArray{
    if(_atArray == nil){
        _atArray = [NSMutableArray array];
    }
    return _atArray;
}

- (void)setCanSendGift:(BOOL)canSendGift
{
    _canSendGift = canSendGift;
    [_functionView setCanSendGift:_canSendGift];
}

- (void)setCanCallTelephone:(BOOL)canCallTelephone{
    _canCallTelephone = canCallTelephone;
    [_functionView setCanCalltelephone:_canCallTelephone];
}

- (void)layoutSubviews
{
    [_faceSelectView setY:_contentView.height];
    [_functionView setY:_contentView.height];
}

- (void)setInputType:(InputType)inputType
{
    _inputType = inputType;
    if(_inputType == InputTypeSound){
        [_soundButton setImage:[UIImage imageNamed:@"SoundIconHighlighted"] forState:UIControlStateNormal];
    }
    else{
        [_soundButton setImage:[UIImage imageNamed:@"SoundIconNormal"] forState:UIControlStateNormal];
    }
    NSInteger height = kContentViewHeight;
    if(_inputType == InputTypeNone)
    {
        height = _contentView.height;
    }
    else if(_inputType == InputTypeSound)
    {
        height = kContentViewHeight;
        [_contentView setHeight:height];
    }
    else if(_inputType == InputTypeFace)
    {
        height = _contentView.height + _faceSelectView.height;
    }
    else if(_inputType == InputTypeNormal)
    {
        height = _contentView.height;
    }
    else
        height = _contentView.height + _faceSelectView.height;
    
    if(self.inputType == InputTypeSound)
    {
        [_inputView setText:nil];
        [_inputView resignFirstResponder];
    }
    [_recordButton setHidden:self.inputType != InputTypeSound];
    [_faceSelectView setHidden:self.inputType != InputTypeFace];
    [_functionView setHidden:self.inputType != InputTypeAdd];
    if(self.inputType != InputTypeNormal)
    {
        [_inputView resignFirstResponder];
        if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidChangeHeight:)])
            [self.inputDelegate inputBarViewDidChangeHeight:height];
    }
    else
        [_inputView becomeFirstResponder];
}

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onKeyboardWillShow:(NSNotification *)notification
{
    if(self.window){
        CGRect keyboardBounds;
        [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        self.targetHeight = keyboardBounds.size.height + _contentView.height;
        if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidChangeHeight:)])
            [self.inputDelegate inputBarViewDidChangeHeight:self.targetHeight];
    }
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
    //    self.targetHeight = _contentView.height;
}

#pragma mark - Actions
#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{
    [[UUProgressHUD sharedInstance] show];
    [[UUProgressHUD sharedInstance] setRecordCallBack:^(NSString *audioUrl, NSInteger time)
     {
         if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidSendVoice:)]){
             AudioItem *audioItem = [[AudioItem alloc] init];
             [audioItem setAudioUrl:audioUrl];
             [audioItem setTimeSpan:time];
             [self.inputDelegate inputBarViewDidSendVoice:audioItem];
         }
     }];
    [[UUProgressHUD sharedInstance] startRecording];
}

- (void)endRecordVoice:(UIButton *)button
{
    [[UUProgressHUD sharedInstance] endRecording];
}

- (void)cancelRecordVoice:(UIButton *)button
{
    [[UUProgressHUD sharedInstance] cancelRecording];
}

- (void)RemindDragExit:(UIButton *)button
{
    [[UUProgressHUD sharedInstance] remindDragExit];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [[UUProgressHUD sharedInstance] remindDragEnter];
}

- (void)onKeyboardTypeChanged:(UIButton *)button
{
    if(button == _soundButton)
    {
        if(self.inputType == InputTypeSound)
            self.inputType = InputTypeNormal;
        else
            self.inputType = InputTypeSound;
    }
    else if(button == _exchangeButton)
    {
        if(self.inputType != InputTypeFace)
            self.inputType = InputTypeFace;
        else
            self.inputType = InputTypeNormal;
        
    }
    else if (button == _addButton)
    {
        if(self.inputType != InputTypeAdd)
            self.inputType = InputTypeAdd;
        else
            self.inputType = InputTypeNormal;
    }
}

#pragma mark - HPGrowingTextViewDelegate
- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    self.inputType = InputTypeNormal;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    if(self.inputType == InputTypeNormal)
    {
        NSInteger contentHeight = _contentView.height;
        NSInteger extraheight = self.height - contentHeight;
        _contentView.height = height + kInputViewVMargin * 2;
        self.targetHeight = _contentView.height + extraheight;
        if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidChangeHeight:)])
            [self.inputDelegate inputBarViewDidChangeHeight:self.targetHeight];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        NSString *content = growingTextView.text;
        if(content.length > 0)
        {
            [growingTextView setText:nil];
            if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidCommit: atArray:)]){
                NSMutableArray *deleteArray = [NSMutableArray array];
                for (UserInfo *user in self.atArray) {
                    NSString *atStr = [NSString stringWithFormat:@"@%@",user.name];
                    NSRange range = [content rangeOfString:atStr];
                    if(range.location == NSNotFound){
                        [deleteArray addObject:user];
                    }
                }
                if(deleteArray.count > 0){
                    [self.atArray removeObjectsInArray:deleteArray];
                }
                [self.inputDelegate inputBarViewDidCommit:content atArray:self.atArray];
            }
        }
        return NO;
    }
    if(self.classID.length > 0 || self.groupID.length > 0){
        if([text isEqualToString:@"@"]){
            [growingTextView setText:[NSString stringWithFormat:@"%@@",growingTextView.text]];
            [self setInputType:InputTypeNone];
            ClassMemberVC *memberVC = [[ClassMemberVC alloc] init];
            if(self.classID.length > 0){
                [memberVC setClassID:self.classID];
            }
            @weakify(self)
            [memberVC setAtCallback:^(UserInfo *user) {
                @strongify(self)
                [growingTextView setText:[NSString stringWithFormat:@"%@%@",growingTextView.text,user.name]];
                [self.atArray addObject:user];
                [self setInputType:InputTypeNormal];
            }];
            [memberVC setCancelCallback:^{
                @strongify(self)
                [self setInputType:InputTypeNormal];
            }];
            TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:memberVC];
            [CurrentROOTNavigationVC presentViewController:nav animated:YES completion:nil];
        }
    }
    return YES;
}

#pragma mark - FaceSelectViewDelegate
- (void)faceSelectViewDidSelectAtIndex:(NSInteger)index
{
    if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidFaceSelect:)])
        [self.inputDelegate inputBarViewDidFaceSelect:[MFWFace faceStringForIndex:index]];
}

#pragma mark - FUnctionViewDelegate
- (void)functionViewDidSelectWithType:(FunctionType)functionType
{
    switch (functionType) {
        case FunctionTypePhoto:
        {
            PhotoPickerVC *photoPickerVC = [[PhotoPickerVC alloc] init];
            [photoPickerVC setMaxToSelected:9];
            [photoPickerVC setDelegate:self];
            TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:photoPickerVC];
            [CurrentROOTNavigationVC presentViewController:nav animated:YES completion:nil];
        }
            break;
        case FunctionTypeCamera:
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            [imagePicker setDelegate:self];
            [imagePicker setSourceType: UIImagePickerControllerSourceTypeCamera];
            [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
        case FunctionTypeShortVideo:
        {
            [VideoRecordView showWithCompletion:^(VideoItem *videoItem) {
                if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidSendVideo:)]){
                    [self.inputDelegate inputBarViewDidSendVideo:videoItem];
                }
            }];
        }
            break;
        case FunctionTypeSendGift:
        {
            MyGiftVC *myGiftVC = [[MyGiftVC alloc] init];
            [myGiftVC setCompletion:^(GiftItem *giftItem) {
                if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidSendGift:)])
                    [self.inputDelegate inputBarViewDidSendGift:giftItem];
            }];
            TNBaseNavigationController *navVC = [[TNBaseNavigationController alloc] initWithRootViewController:myGiftVC];
            [CurrentROOTNavigationVC presentViewController:navVC animated:YES completion:nil];
        }
            break;
        case FunctionTypeTelephone:
        {
            if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidCallTelephone)]){
                [self.inputDelegate inputBarViewDidCallTelephone];
            }
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - PhotoPickerVCDelegate
- (void)photoPickerVC:(PhotoPickerVC *)photoPickerVC didFinished:(NSArray *)selectedArray
{
    [photoPickerVC dismissViewControllerAnimated:YES completion:nil];
    NSMutableArray *photoArray = [NSMutableArray array];
    for (PublishImageItem *imageItem in selectedArray)
    {
        NSString *tmpImagePath = [NHFileManager getTmpImagePath];
        UIImage *image = imageItem.image;
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        [data writeToFile:tmpImagePath atomically:YES];
        PhotoItem *photoItem = [[PhotoItem alloc] init];
        [photoItem setWidth:image.size.width];
        [photoItem setHeight:image.size.height];
        [photoItem setBig:tmpImagePath];
        [photoArray addObject:photoItem];
    }
    if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidSendPhotoArray:)])
    {
        [self.inputDelegate inputBarViewDidSendPhotoArray:photoArray];
    }
}

- (void)photoPickerVCDidCancel:(PhotoPickerVC *)photoPickerVC
{
    [photoPickerVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:[UIApplication sharedApplication].keyWindow];
    __weak typeof(self) wself = self;
    __block UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [image formatImage];
        NSString *tmpImagePath = [NHFileManager getTmpImagePath];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [imageData writeToFile:tmpImagePath atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:NO];
            PhotoItem *photoItem = [[PhotoItem alloc] init];
            [photoItem setWidth:image.size.width];
            [photoItem setHeight:image.size.height];
            [photoItem setBig:tmpImagePath];
            [photoItem setSmall:tmpImagePath];
            if([wself.inputDelegate respondsToSelector:@selector(inputBarViewDidSendPhoto:)])
                [wself.inputDelegate inputBarViewDidSendPhoto:photoItem];
        });
    });
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
@end

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
#import "DNImagePickerController.h"
#define kContentViewHeight                  48
#define kButtonWidth                        30
#define kButtonHeight                       30

#define kInputViewVMargin                   7
#define kInputViewheight                    34

#define kButtonMargin                       5

#define kTextFont                           [UIFont systemFontOfSize:15]

@interface InputBarView ()<DNImagePickerControllerDelegate>
@property (nonatomic,assign)NSInteger targetHeight;
@property (nonatomic, strong)NSMutableArray *atArray;
@property (nonatomic, strong)UUProgressHUD *audioRecordView;
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
        [_contentView setBackgroundColor:[UIColor whiteColor]];
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
        [_recordButton addTarget:self action:@selector(beginRecordVoice) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(endRecordVoice) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [_recordButton addTarget:self action:@selector(RemindDragExit) forControlEvents:UIControlEventTouchDragExit];
        [_recordButton addTarget:self action:@selector(RemindDragEnter) forControlEvents:UIControlEventTouchDragEnter];
        [_contentView addSubview:_recordButton];
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _contentView.height - kLineHeight, _contentView.width, kLineHeight)];
        [bottomLine setBackgroundColor:[UIColor colorWithHexString:@"A4A4A4"]];
        [bottomLine setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
        [_contentView addSubview:bottomLine];
        
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

- (void)setImDisabled:(BOOL)imDisabled{
    if(_imDisabled != imDisabled){
        _imDisabled = imDisabled;
        if(_imDisabled){
            [self setInputType:InputTypeNone];
        }
        [_soundButton setEnabled:!_imDisabled];
        [_exchangeButton setEnabled:!_imDisabled];
        [_inputView setEditable:!_imDisabled];
        [_addButton setEnabled:!_imDisabled];
        if(_imDisabled){
            [_inputView setText:@"班级群聊已关闭"];
            [_inputView setTextAlignment:NSTextAlignmentCenter];
            [_inputView setTextColor:kCommonTeacherTintColor];
            [self setUserInteractionEnabled:NO];
        }
        else{
            [_inputView setText:@""];
            [_inputView setTextAlignment:NSTextAlignmentLeft];
            [_inputView setTextColor:[UIColor blackColor]];
            [self setUserInteractionEnabled:YES];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
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
    if(self.window){
        if(_inputType == InputTypeNormal){
            CGRect keyboardBounds;
            [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
            self.targetHeight = _contentView.height;
            if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidChangeHeight:)])
                [self.inputDelegate inputBarViewDidChangeHeight:self.targetHeight];
        }
    }
}

#pragma mark - Actions

- (void)addAtUser:(UserInfo *)userInfo{
    for (UserInfo *atUser in self.atArray) {
        if([atUser.uid isEqualToString:userInfo.uid]){
            return;
        }
    }
    if(userInfo){
        [self setInputType:InputTypeNormal];
        [self.atArray addObject:userInfo];
        NSString *text = _inputView.text;
        _inputView.text = [NSString stringWithFormat:@"%@@%@ ",text, userInfo.name];
    }
}

- (void)checkAtList{
    NSMutableArray *deleteArray = [NSMutableArray array];
    NSString *text = _inputView.text;
    for (UserInfo *atUser in self.atArray) {
        NSString *atStr = [NSString stringWithFormat:@"@%@",atUser.name];
        NSRange range = [text rangeOfString:atStr];
        if(range.location == NSNotFound){
            [deleteArray addObject:atUser];
        }
    }
    if(deleteArray.count > 0){
        [self.atArray removeObjectsInArray:deleteArray];
    }
}
#pragma mark - 录音touch事件
- (void)beginRecordVoice
{
    if(self.audioRecordView){
        [self.audioRecordView removeFromSuperview];
        self.audioRecordView = nil;
    }
    __weak typeof(self) wself = self;
    self.audioRecordView = [[UUProgressHUD alloc] init];
    [self.audioRecordView setRecordCallBack:^(NSString *audioUrl, NSInteger time)
     {
         if([wself.inputDelegate respondsToSelector:@selector(inputBarViewDidSendVoice:)]){
             AudioItem *audioItem = [[AudioItem alloc] init];
             [audioItem setAudioUrl:audioUrl];
             [audioItem setTimeSpan:time];
             [wself.inputDelegate inputBarViewDidSendVoice:audioItem];
         }
         [wself.audioRecordView dismiss];
     }];
    [self.audioRecordView startRecording];
    [self.audioRecordView show];
}

- (void)endRecordVoice
{
    [self.audioRecordView endRecording];
}

- (void)cancelRecordVoice
{
    [self.audioRecordView cancelRecording];
}

- (void)RemindDragExit
{
    [self.audioRecordView remindDragExit];
}

- (void)RemindDragEnter
{
    [self.audioRecordView remindDragEnter];
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
                [self.atArray removeAllObjects];
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
            else if(self.groupID.length > 0){
                [memberVC setGroupID:self.groupID];
            }
            @weakify(self)
            [memberVC setAtCallback:^(UserInfo *user) {
                @strongify(self)
                [growingTextView setText:[NSString stringWithFormat:@"%@%@ ",growingTextView.text,user.name]];
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
    
    [self checkAtList];
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
            DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
//            [imagePicker setFilterType:DNImagePickerFilterTypePhotos];
            [imagePicker setImagePickerDelegate:self];
            [imagePicker setMaxImageCount:9];
            [imagePicker setMaxVideoCount:1];
            [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
//            PhotoPickerVC *photoPickerVC = [[PhotoPickerVC alloc] init];
//            [photoPickerVC setMaxToSelected:9];
//            [photoPickerVC setDelegate:self];
//            TNBaseNavigationController *nav = [[TNBaseNavigationController alloc] initWithRootViewController:photoPickerVC];
//            [CurrentROOTNavigationVC presentViewController:nav animated:YES completion:nil];
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

#pragma mark - DNImagePickerDelegate
- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)dnImagePickerController:(DNImagePickerController *)imagePicker sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    if(imageAssets.count > 0){
        NSMutableArray *addImageArray = [NSMutableArray array];
        NSMutableArray *addVideoArray = [NSMutableArray array];
        for (ALAsset *asset in imageAssets) {
            if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
                UIImage *image;
                if(fullImage)
                    image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage] scale:1.f orientation:UIImageOrientationUp];
                else
                    image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:1.f orientation:UIImageOrientationUp];
                if(image)
                {
                    [addImageArray addObject:image];
                }
            }
            else if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]){
                NSString *coverUrl = [NHFileManager getTmpImagePath];
                ALAssetRepresentation *representation = asset.defaultRepresentation;
                UIImage *coverImage = [UIImage imageWithCGImage:[representation fullScreenImage] scale:1.f orientation:UIImageOrientationUp];
                BOOL shouldSend = [Utility checkVideo:asset];
                if(!shouldSend){
                    return;
                }
                NSData *imageData = UIImageJPEGRepresentation(coverImage, 0.8);
                [imageData writeToFile:coverUrl atomically:YES];
                NSString *filePath = [[representation url] absoluteString];
                NSString *tmpPath = [NHFileManager tmpVideoPathForPath:filePath];
                NSInteger duration = [[asset valueForProperty:ALAssetPropertyDuration] integerValue];
                [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
                MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:[UIApplication sharedApplication].keyWindow];
                AVAsset *avAsset = [AVAsset assetWithURL:[NSURL URLWithString:filePath]];
                AVAssetExportSession * exportSession = [AVAssetExportSession exportSessionWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
                exportSession.outputFileType = AVFileTypeMPEG4;
                exportSession.shouldOptimizeForNetworkUse = YES;
                exportSession.outputURL = [NSURL fileURLWithPath:tmpPath];
                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                        if(AVAssetExportSessionStatusCompleted == exportSession.status){
                            VideoItem *videoItem = [[VideoItem alloc] init];
                            [videoItem setVideoUrl:tmpPath];
                            [videoItem setCoverUrl:coverUrl];
                            [videoItem setVideoTime:duration];
                            [videoItem setCoverWidth:coverImage.size.width];
                            [videoItem setCoverHeight:coverImage.size.height];
                            [addVideoArray addObject:videoItem];
                            
                            if(addVideoArray.count > 0){
                                if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidSendVideo:)]){
                                    for (VideoItem *videoItem in addVideoArray) {
                                        [self.inputDelegate inputBarViewDidSendVideo:videoItem];
                                    }
                                }
                            }
                        }
                        else{
                            
                            [ProgressHUD showHintText:@"压缩失败"];
                        }
                    });
                    
                }];
                
            }
        }
        if(addImageArray.count > 0){
            MBProgressHUD *hud = [MBProgressHUD showMessag:@"正在压缩" toView:[UIApplication sharedApplication].keyWindow];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *photoItemArray = [NSMutableArray array];
                for (UIImage *image in addImageArray) {
                    NSString *tmpImagePath = [NHFileManager getTmpImagePath];
                    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
                    [imageData writeToFile:tmpImagePath atomically:YES];
                    PhotoItem *photoItem = [[PhotoItem alloc] init];
                    [photoItem setWidth:image.size.width];
                    [photoItem setHeight:image.size.height];
                    [photoItem setBig:tmpImagePath];
                    [photoItem setSmall:tmpImagePath];
                    [photoItemArray addObject:photoItem];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidSendPhotoArray:)])
                    {
                        [self.inputDelegate inputBarViewDidSendPhotoArray:photoItemArray];
                    }
                });
            });
        }
    }

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

@end

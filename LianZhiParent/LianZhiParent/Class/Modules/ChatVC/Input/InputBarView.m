//
//  InputBarView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "InputBarView.h"

#define kContentViewHeight                  48
#define kButtonWidth                        30
#define kButtonHeight                       30

#define kInputViewVMargin                   7
#define kInputViewheight                    34

#define kButtonMargin                       5

#define kTextFont                           [UIFont systemFontOfSize:15]

@interface InputBarView ()
@property (nonatomic,assign)NSInteger targetHeight;
@property (nonatomic, strong)NSTimer* timer;
@property (nonatomic, assign)NSInteger playTime;
@property (nonatomic, strong)MLAudioRecorder*   recorder;
@property (nonatomic, strong)AmrRecordWriter*   amrWriter;
@property (nonatomic, strong)MLAudioPlayer*     player;
@property (nonatomic, strong)AmrPlayerReader*   amrReader;
@end

@implementation InputBarView

- (void)dealloc
{
    [self.player stopPlaying];
    [self.recorder stopRecording];
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
        
        [self setupRecorder];
    }
    return self;
}

- (void)layoutSubviews
{
    [_faceSelectView setY:_contentView.height];
    [_functionView setY:_contentView.height];
}

- (void)setInputType:(InputType)inputType
{
    _inputType = inputType;
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
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    self.targetHeight = keyboardBounds.size.height + _contentView.height;
    if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidChangeHeight:)])
        [self.inputDelegate inputBarViewDidChangeHeight:self.targetHeight];
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
//    self.targetHeight = _contentView.height;
}

#pragma mark - Actions
#pragma mark - 录音touch事件

- (void)setupRecorder
{
    NSString *filePath = [[AudioRecordView class] tempFilePath];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    AmrRecordWriter *amrWriter = [[AmrRecordWriter alloc]init];
    amrWriter.filePath = filePath;
    amrWriter.maxSecondCount = 119;
    amrWriter.maxFileSize = 1024*256;
    self.amrWriter = amrWriter;
    
    MLAudioRecorder *recorder = [[MLAudioRecorder alloc]init];
    //amr
    recorder.bufferDurationSeconds = 0.5;
    recorder.fileWriterDelegate = self.amrWriter;
    self.recorder = recorder;
    
    MLAudioPlayer *player = [[MLAudioPlayer alloc]init];
    AmrPlayerReader *amrReader = [[AmrPlayerReader alloc]init];
    
    player.fileReaderDelegate = amrReader;
    player.receiveErrorBlock = ^(NSError *error){
        [[[UIAlertView alloc]initWithTitle:@"错误" message:error.userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil]show];
    };
    player.receiveStoppedBlock = ^{
    };
    self.player = player;
    self.amrReader = amrReader;
}

- (void)countVoiceTime
{
    self.playTime ++;
    if (self.playTime >= 119)
        [self endRecordVoice:nil];
}

- (void)beginRecordVoice:(UIButton *)button
{
    self.playTime = 0;
   self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [self.recorder startRecording];
}

- (void)endRecordVoice:(UIButton *)button
{
    if (self.timer)
    {
        [self.recorder stopRecording];
        [self.timer invalidate];
        self.timer = nil;
    }
    NSInteger time = self.playTime;
    NSData *audioData = [NSData dataWithContentsOfFile:self.amrWriter.filePath];
    if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidSendVoice: time:)])
        [self.inputDelegate inputBarViewDidSendVoice:audioData time:time];
}

- (void)cancelRecordVoice:(UIButton *)button
{
    if (self.timer)
    {
        [self.recorder stopRecording];
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)RemindDragExit:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Release to cancel"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Slide up to cancel"];
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

- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height
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
            if([self.inputDelegate respondsToSelector:@selector(inputBarViewDidCommit:)])
                [self.inputDelegate inputBarViewDidCommit:content];
        }
        return NO;
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
- (void)functionViewDidSelectAtIndex:(NSInteger)index
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setSourceType:index == 0 ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera];
    [CurrentROOTNavigationVC presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MBProgressHUD *hud = [MBProgressHUD showMessag:@"" toView:[UIApplication sharedApplication].keyWindow];
    __weak typeof(self) wself = self;
    __block UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image = [image formatImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:NO];
            if([wself.inputDelegate respondsToSelector:@selector(inputBarViewDidSendPhoto:)])
                [wself.inputDelegate inputBarViewDidSendPhoto:image];
        });
    });
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end

//
//  InputBarView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/9/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "InputBarView.h"

#define kContentViewHeight                  44
#define kButtonWidth                        30
#define kButtonHeight                       30

#define kButtonMargin                       5

#define kTextFont                           [UIFont systemFontOfSize:15]

@interface InputBarView ()
@property (nonatomic,assign)NSInteger targetHeight;
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
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        [_contentView setBackgroundColor:[UIColor colorWithHexString:@"F0F0F0"]];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLineHeight)];
        [topLine setBackgroundColor:kSepLineColor];
        [_contentView addSubview:topLine];
        
        [self addSubview:_contentView];
        
        _soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_soundButton setImage:[UIImage imageNamed:@"SoundIconNormal"] forState:UIControlStateNormal];
        [_soundButton addTarget:self action:@selector(onKeyboardTypeChanged:) forControlEvents:UIControlEventTouchUpInside];
        [_soundButton setFrame:CGRectMake(5, (_contentView.height - kButtonWidth) / 2 , kButtonWidth, kButtonHeight)];
        [_contentView addSubview:_soundButton];
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundImage:[[UIImage imageWithColor:kCommonTeacherTintColor size:CGSizeMake(10, 10) cornerRadius:3] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_sendButton setFrame:CGRectMake(_contentView.width - 60 - kButtonMargin, (_contentView.height - 36) / 2, 60, 36)];
        [_sendButton addTarget:self action:@selector(onKeyboardTypeChanged:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_sendButton];
        
        // 键盘切换按钮
        _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exchangeButton setImage:[UIImage imageNamed:@"FaceIconNormal"] forState:UIControlStateNormal];
        [_exchangeButton setFrame:CGRectMake(_sendButton.x - kButtonMargin - kButtonWidth, (_contentView.height - kButtonHeight) / 2, kButtonWidth, kButtonHeight)];
        [_exchangeButton addTarget:self action:@selector(onKeyboardTypeChanged:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_exchangeButton];
        
        // 设置TextView
        _inputView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(_soundButton.right + 10, 4, _exchangeButton.x - 10 - (_soundButton.right + 10), 36)];
        [_inputView setBackgroundColor:[UIColor whiteColor]];
        [_inputView setFont:kTextFont];
        [_inputView setMinNumberOfLines:1];
        [_inputView setMaxNumberOfLines:6];
        [_inputView setReturnKeyType:UIReturnKeyDefault];
        [[_inputView internalTextView] setScrollIndicatorInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
        [_inputView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [_inputView setDelegate:self];
        
        [_contentView addSubview:_inputView];
        
        _faceSelectView = [[FaceSelectView alloc] initWithFrame:CGRectMake(0, _contentView.height, kScreenWidth, FACESELECT_HEIGHT)];
        _faceSelectView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [_contentView addSubview:_faceSelectView];
        _faceSelectView.delegate = self;
        
        _extraMessageView = [[ExtraMessageView alloc] initWithFrame:CGRectMake(0, _contentView.height, self.width, FACESELECT_HEIGHT)];
        [_extraMessageView setDelegate:self];
        [_contentView addSubview:_extraMessageView];

        [self addNotifications];
    }
    return self;
}

- (void)layoutSubviews
{
    
}

//- (void)setInputType:(InputType)inputType
//{
//    _inputType = inputType;
//    NSInteger height = kContentViewHeight;
//    if(_inputType == InputTypeSound)
//        height = kContentViewHeight;
//    else if(_inputType == InputTypeFace)
//    {
//        height = kContentViewHeight + _faceSelectView.height;
//    }
//    else if(_inputType == InputTypeNormal)
//    {
//        height = kContentViewHeight + _extraMessageView.height;
//    }
//    if([self.delegate respondsToSelector:@selector(inputBarViewWillChangeHeight:)])
//        [self.delegate inputBarViewWillChangeHeight:height];
//}

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
    self.inputType = InputTypeNormal;
    if([self.delegate respondsToSelector:@selector(inputBarViewWillChangeHeight:)])
        [self.delegate inputBarViewWillChangeHeight:self.targetHeight];
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
//    self.targetHeight = _contentView.height;
}

#pragma mark - Actions
- (void)onKeyboardTypeChanged:(UIButton *)button
{
    if(button == _soundButton)
    {
        self.inputType = InputTypeSound;
        self.targetHeight = kContentViewHeight;
        [_inputView resignFirstResponder];
    }
    else if(button == _exchangeButton)
    {
        if(self.inputType == InputTypeFace)
        {
            self.inputType = InputTypeNormal;
            [_inputView becomeFirstResponder];
        }
        else
        {
            self.inputType = InputTypeFace;
            self.targetHeight = _contentView.height + _faceSelectView.height;
            [_inputView resignFirstResponder];
        }
    }
    if(self.inputType != InputTypeNormal)
        if([self.delegate respondsToSelector:@selector(inputBarViewWillChangeHeight:)])
            [self.delegate inputBarViewWillChangeHeight:self.targetHeight];
}

#pragma mark - HPGrowingTextViewDelegate
- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    self.inputType = InputTypeNormal;
    
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height
{
    NSInteger contentHeight = _contentView.height;
    NSInteger extraheight = self.height - contentHeight;
    _contentView.height = height + 4 * 2;
    self.targetHeight = _contentView.height + extraheight;
    if([self.delegate respondsToSelector:@selector(inputBarViewWillChangeHeight:)])
        [self.delegate inputBarViewWillChangeHeight:self.targetHeight];
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

#pragma mark - ContentActionInputDelegate
- (void)ContentActionInput_BackWord
{
    
}

- (void)ContentActionInput_FaceSelect:(NSString *)face
{
    
}

- (void)ContentActionInput_ReturnEntered
{
    
}

#pragma mark - ExtraMessageViewDelegate
- (void)extraMessageViewOnSelectPhoto
{
    
}

- (void)extraMessageViewOnSelectGift
{
    
}

- (void)extraMessageViewOnSelectCamera
{
    
}
@end

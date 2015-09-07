//
//  UIContentActionView.m
//  Photographer
//
//  Created by  dong jianbo on 12-4-10.
//  Copyright (c) 2012年 mafengwo. All rights reserved.
//


#import "UIContentActionView.h"
#import "MFWFace.h"

#define CONTENT_ACTION_BOTTOM   kScreenHeight

#define kContentActionHeight        45

#define kButtonWidth            30
#define kButtonHeight           30

#define	BUTTON_RIGHT            10
#define	BUTTON_TOP              9
#define	BUTTON_WIDTH            45
#define	BUTTON_HEIGHT           35

#define TEXTVIEW_FONT           [UIFont systemFontOfSize:15]
#define	BUTTON_FONT             [UIFont boldSystemFontOfSize:14]

#define SWITCHBUTTON_TAG_INIT       0
#define SWITCHBUTTON_TAG_KEYBOARD   1
#define SWITCHBUTTON_TAG_FACE       2

#define	INPUT_BG                    @"InputViewBG.png"
#define SEND_BUTTON                 @"SendMessageButton.png"

@interface UIContentActionView()
- (void) onClickSwitchKeyboardButton:(id)sender;
- (void) switchKeyboardType;
- (void) updateSwitchKeyboardButtonIcon;

- (void) commonInitialiser;
- (void) onClickCommitButton;

- (void) registerNotification;
@end


@implementation UIContentActionView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentActionHeight)]))
    {
        _inputType = InputType_Keyboard;
        [self commonInitialiser];
    }
    
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGFloat)inputHeight
{
    return self.height - FACESELECT_HEIGHT;
}


- (void) setText:(NSString *)text
{
    [_expandingTextView becomeFirstResponder];
    [_expandingTextView setText:text];
}

- (BOOL)resignFirstResponder
{
    [_expandingTextView resignFirstResponder];
    return [super resignFirstResponder];
}

#pragma mark - HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (height - growingTextView.frame.size.height);
    
    if(fabs(diff) < 0.00001)
        return;
    CGRect r = self.frame;
    r.size.height += diff;
    r.origin.y -= diff;
    self.frame = r;
    
    // notify move
    if(_delegate && [_delegate respondsToSelector:@selector(onActionViewHeightChanged:)]) {
        [_delegate onActionViewHeightChanged:diff];
    }
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if(_delegate && [_delegate respondsToSelector:@selector(onActionViewInputChange:)]) {
        [_delegate onActionViewInputChange:growingTextView.text];
    }
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    [_expandingTextView resignFirstResponder];
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (text.length == 0 && range.location != NSNotFound && range.length == 1) {
        NSString * text = [growingTextView text];
        NSRange del = NSMakeRange(NSNotFound, 0);
        if (_selectRange.length > 1)
        {
            if (_selectRange.location + _selectRange.length < [text length])
            {
                del = _selectRange;
            }
        }
        else if (_selectRange.location <= [text length])
        {
            if (_selectRange.location > 2)
            {
                unichar ch = [text characterAtIndex:_selectRange.location-2];
                if (ch >= 0xD800 && ch <= 0xDFFF)
                {
                    del = NSMakeRange(_selectRange.location-2, 2);
                }
                else
                {
                    del = NSMakeRange(_selectRange.location-1, 1);
                }
            }
            else
            {
                del = NSMakeRange(_selectRange.location-1, 1);
            }
        }
        if (del.location != NSNotFound)
        {
            _selectRange.location = del.location;
            _selectRange.length = 0;
        }
        
        if (growingTextView.text.length > 0) {
            NSRange searchRangeBack = NSMakeRange(range.location, growingTextView.text.length - range.location);
            NSRange searchRangeFront = NSMakeRange(0, range.location + 1);
            NSRange rangeBack = [growingTextView.text rangeOfString:EXP_FACE_END options:NSLiteralSearch range:searchRangeBack];
            NSRange rangeFront = [growingTextView.text rangeOfString:EXP_FACE_BEGIN options:NSBackwardsSearch range:searchRangeFront];
            if (rangeBack.location != NSNotFound && rangeFront.location != NSNotFound) {
                NSInteger length = rangeBack.location - rangeFront.location + 1;
                NSRange emptyRange = NSMakeRange(rangeFront.location, length);
                growingTextView.text = [growingTextView.text stringByReplacingCharactersInRange:emptyRange withString:@""];
                growingTextView.selectedRange = NSMakeRange(rangeFront.location, 0);
                return NO;
            }
        }
    }
    
    return YES;
}

#pragma mark - private function
-(void)commonInitialiser
{
    [self registerNotification];
   
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
    
    // 键盘切换按钮
    _switchKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _switchKeyboardButton.frame = CGRectMake(5, 5, 36, 35);
    [_switchKeyboardButton addTarget:self action:@selector(onClickSwitchKeyboardButton:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_switchKeyboardButton];
    _switchKeyboardButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    _switchKeyboardButton.tag = SWITCHBUTTON_TAG_INIT;
    [self updateSwitchKeyboardButtonIcon];
    
    // 设置TextView
    _expandingTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(45, 5, 220, 36)];
    [_expandingTextView setBackgroundColor:[UIColor whiteColor]];
    [_expandingTextView setFont:TEXTVIEW_FONT];
    [_expandingTextView setMinNumberOfLines:1];
    [_expandingTextView setMaxNumberOfLines:6];
    [_expandingTextView setReturnKeyType:UIReturnKeyDefault];
    [[_expandingTextView internalTextView] setScrollIndicatorInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [_expandingTextView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [_expandingTextView setDelegate:self];
    
    [_contentView addSubview:_expandingTextView];
    
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"InputTextfieldBG.png"];
    UIImage *entryBackground = [rawEntryBackground resizableImageWithCapInsets:UIEdgeInsetsMake(20, 15, 20, 15)];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(45, 0, 220, CONTENT_TEXTINPUT_HEIGHT);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:entryImageView];
    
    // 发送按钮
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setFrame:CGRectMake(self.width - 50, (44 - 35.0) / 2, 46, 35)];
    [commitButton setBackgroundImage:[[UIImage imageNamed:SEND_BUTTON] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
    [commitButton setTitle:@"发送" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(onClickCommitButton) forControlEvents:UIControlEventTouchUpInside];
    [[commitButton titleLabel] setFont:BUTTON_FONT];
    [commitButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin];
    [self addSubview:commitButton];
    
    // face select view
    _faceView = [[FaceSelectView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - FACESELECT_HEIGHT, kScreenWidth, FACESELECT_HEIGHT)];
    _faceView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_faceView];
    _faceView.delegate = self;
}

- (void)onKeyboardTypeChanged:(UIButton *)button
{
    
}

- (void) onClickCommitButton
{
    NSString* content = _expandingTextView.text;
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(content == nil && [content length] == 0)
        return;
    _expandingTextView.text = @"";
    _selectRange = _expandingTextView.selectedRange;
    if(_delegate && [_delegate respondsToSelector:@selector(onActionViewCommit:)]) {
        [_delegate onActionViewCommit:content];
    }
}


// 注册消息
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleKeyboardWillShowHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

}

#pragma mark - Notifications
- (void)handleKeyboardWillShowHideNotification:(NSNotification *)notification
{
    if([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        self.keyboard.hidden = NO;
    }
    else if([notification.name isEqualToString:UIKeyboardDidShowNotification]) {
        self.keyboard = _expandingTextView.internalTextView.inputAccessoryView.superview;
        self.keyboard.hidden = NO;
        
        if(_delegate && [_delegate respondsToSelector:@selector(keyboardDidShow)])
            [_delegate keyboardDidShow];
    }
    else if([notification.name isEqualToString:UIKeyboardDidHideNotification]) {
        self.keyboard.hidden = NO;
        [self resignFirstResponder];
    }
}

#pragma mark - Gestures
- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    if(!self.keyboard || self.keyboard.hidden)
        return;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    UIWindow *panWindow = [[UIApplication sharedApplication] keyWindow];
    CGPoint location = [pan locationInView:panWindow];
    CGPoint velocity = [pan velocityInView:panWindow];
    if(_inputType == InputType_Keyboard)
    {
        
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
                self.originalKeyboardY = self.keyboard.frame.origin.y;
                break;
            case UIGestureRecognizerStateEnded:
                if(velocity.y > 0 && self.keyboard.frame.origin.y > self.originalKeyboardY) {
                    
                    [UIView animateWithDuration:0.3
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseOut
                                     animations:^{
                                         self.keyboard.frame = CGRectMake(0.0f,
                                                                          screenHeight,
                                                                          self.keyboard.frame.size.width,
                                                                          self.keyboard.frame.size.height);
                                         
                                         if(_delegate && [_delegate respondsToSelector:@selector(keyboardWillBeDismissed)])
                                             [_delegate keyboardWillBeDismissed];
                                     }
                                     completion:^(BOOL finished) {
                                         self.keyboard.hidden = YES;
                                         self.keyboard.frame = CGRectMake(0.0f,
                                                                          self.originalKeyboardY,
                                                                          self.keyboard.frame.size.width,
                                                                          self.keyboard.frame.size.height);
                                         [self resignFirstResponder];
                                     }];
                }
                else { // gesture ended with no flick or a flick upwards, snap keyboard back to original position
                    [UIView animateWithDuration:0.2
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseOut
                                     animations:^{
                                         if(_delegate && [_delegate respondsToSelector:@selector(keyboardWillSnapBackToPoint:)]) {
                                             [_delegate keyboardWillSnapBackToPoint:CGPointMake(0.0f, self.originalKeyboardY)];
                                         }
                                         
                                         self.keyboard.frame = CGRectMake(0.0f,
                                                                          self.originalKeyboardY,
                                                                          self.keyboard.frame.size.width,
                                                                          self.keyboard.frame.size.height);
                                     }
                                     completion:^(BOOL finished){
                                     }];
                }
                break;
                
                // gesture is currently panning, match keyboard y to touch y
            default:
                if(location.y > self.keyboard.frame.origin.y || self.keyboard.frame.origin.y != self.originalKeyboardY) {
                    
                    CGFloat newKeyboardY = self.originalKeyboardY + (location.y - self.originalKeyboardY);
                    newKeyboardY = newKeyboardY < self.originalKeyboardY ? self.originalKeyboardY : newKeyboardY;
                    newKeyboardY = newKeyboardY > screenHeight ? screenHeight : newKeyboardY;
                    
                    self.keyboard.frame = CGRectMake(0.0f,
                                                     newKeyboardY,
                                                     self.keyboard.frame.size.width,
                                                     self.keyboard.frame.size.height);
                    
                    if(_delegate && [_delegate respondsToSelector:@selector(keyboardDidScrollToPoint:)])
                        [_delegate keyboardDidScrollToPoint:CGPointMake(0.0f, newKeyboardY)];
                }
                break;
        }

    }
    else
    {
        CGPoint superLocation = [self.superview convertPoint:location fromView:panWindow];
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
                self.originalKeyboardY = self.y;
                break;
            case UIGestureRecognizerStateEnded:
                if(superLocation.y > 0 && self.y > self.originalKeyboardY) {
                    
                    [UIView animateWithDuration:0.3
                                          delay:0
                                        options:UIViewAnimationOptionCurveEaseOut
                                     animations:^{
                                         self.y = self.superview.height - self.inputHeight;
                                         if(_delegate && [_delegate respondsToSelector:@selector(onActionViewYChanged:)])
                                             [_delegate onActionViewYChanged:self.superview.height - self.inputHeight];
                                     }
                                     completion:^(BOOL finished) {
                                         _inputType = InputType_Keyboard;
                                         self.keyboard = nil;
                                         [self resignFirstResponder];
                                     }];
                }
//                else { // gesture ended with no flick or a flick upwards, snap keyboard back to original position
//                    [UIView animateWithDuration:0.2
//                                          delay:0
//                                        options:UIViewAnimationOptionCurveEaseOut
//                                     animations:^{
//                                         if(_delegate && [_delegate respondsToSelector:@selector(onActionViewYChanged:)])
//                                             [_delegate onActionViewYChanged:self.originalKeyboardY];
//                                         self.y = self.originalKeyboardY;
//                                     }
//                                     completion:^(BOOL finished){
//                                     }];
//                }

                break;
            default:
                if(superLocation.y > self.y || self.y != self.originalKeyboardY) {
                    
                    CGFloat newKeyboardY = self.originalKeyboardY + (superLocation.y - self.originalKeyboardY);
                    newKeyboardY = newKeyboardY < self.originalKeyboardY ? self.originalKeyboardY : newKeyboardY;
                    newKeyboardY = newKeyboardY > screenHeight ? screenHeight : newKeyboardY;
                    
                    self.y = newKeyboardY;
                    if(_delegate && [_delegate respondsToSelector:@selector(onActionViewYChanged:)])
                        [_delegate onActionViewYChanged:newKeyboardY];
                }

                break;
        }
    }
}

#pragma mark - ContentActionInputDelegate
-(void)ContentActionInput_FaceSelect:(NSString*)face
{
    if (_selectRange.location > _expandingTextView.text.length) {
        _selectRange.location = _expandingTextView.text.length;
    }
    
    _expandingTextView.text = [_expandingTextView.text stringByReplacingCharactersInRange:_selectRange withString:face];
    if (_expandingTextView.text.length > 0) {
        [_expandingTextView scrollRangeToVisible:NSMakeRange(_expandingTextView.text.length - 1, 1)];
        _selectRange.location += [face length];
        _selectRange.length = 0;
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(onActionViewInputChange:)]) {
        [_delegate onActionViewInputChange:_expandingTextView.text];
    }
}

-(void)ContentActionInput_BackWord
{
    [_expandingTextView backspace];
    _selectRange = _expandingTextView.selectedRange;
}

-(void)ContentActionInput_ReturnEntered
{
    
}

#pragma mark - private function
- (void) onClickSwitchKeyboardButton:(id)sender
{
    [self switchKeyboardType];
}

- (void) switchKeyboardType
{
    
    if(_inputType == InputType_Keyboard) {
        _inputType = InputType_Face;
        _selectRange = _expandingTextView.selectedRange;
        [_expandingTextView.internalTextView resignFirstResponder]; 
        
        self.keyboard = _faceView;
        CGFloat originalY = self.y;
        [UIView animateWithDuration:0.25 animations:^{
            self.y = self.superview.height - self.height;
        }];
        if(_delegate && [_delegate respondsToSelector:@selector(onActionViewHeightChanged:)])
            [_delegate onActionViewHeightChanged:originalY - self.superview.height + self.height];
        
        
    }
    else {
        _inputType = InputType_Keyboard;
        NSString* text = [_expandingTextView text];
        if (_selectRange.location + _selectRange.length > [text length]) {
            _selectRange.location += [text length];
            _selectRange.length = 0;
        }
        _expandingTextView.selectedRange = _selectRange;
        [_expandingTextView.internalTextView becomeFirstResponder]; 
        _switchKeyboardButton.tag = SWITCHBUTTON_TAG_KEYBOARD;
    }      
    
    [self updateSwitchKeyboardButtonIcon];
}

- (void)updateSwitchKeyboardButtonIcon
{
    if (_inputType == InputType_Face) {
        [_switchKeyboardButton setBackgroundImage:[UIImage imageNamed:@"KeyboardIcon"] forState:UIControlStateNormal];
    }
    else {
        [_switchKeyboardButton setBackgroundImage:[UIImage imageNamed:@"FaceIcon"] forState:UIControlStateNormal];
    } 
}
@end

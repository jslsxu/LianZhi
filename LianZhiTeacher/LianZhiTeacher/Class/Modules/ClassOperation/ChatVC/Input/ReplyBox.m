//
//  ReplyBox.m
//


#import "ReplyBox.h"

@interface ReplyBox() <HPGrowingTextViewDelegate>
@property(nonatomic, strong)HPGrowingTextView*  hPGrowingTextView;
//@property(nonatomic, strong)UIImageView*        inputViewFG;
@property(nonatomic, strong)UIButton*           commitButton;
@property(nonatomic, strong)UIButton*           cancelButton;
@property(nonatomic, assign)NSRange             selectRange;
@end

@implementation ReplyBox

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self commonInitialiser];
    }
    
    return self;
}

- (void) dealloc
{
    [self unregisterNotification];
}

#pragma mark - public function
- (void) setText:(NSString *)text
{
    [self.hPGrowingTextView setText:text];
}

- (void) setTextAndBecomeFirstResponder:(NSString *)text
{
    [self.hPGrowingTextView becomeFirstResponder];
    [self.hPGrowingTextView setText:text];
}

- (void) setPlaceHolder:(NSString *)text
{
    [self.hPGrowingTextView setPlaceholder:text];
}

- (NSString*) getText
{
    return self.hPGrowingTextView.text;
}

- (void) assignFocus
{
    if(!self.cancelButton.superview) {
        [self.superview insertSubview:self.cancelButton belowSubview:self];
    }
    
    [self.hPGrowingTextView becomeFirstResponder];
}

- (void) resignFocus
{
    if(self.cancelButton.superview) {
        [self.cancelButton removeFromSuperview];
    }
    
    [self.hPGrowingTextView resignFirstResponder];
    self.frame = CGRectMake(0, self.superview.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    // notify move
    if(self.delegate && [self.delegate respondsToSelector:@selector(onActionViewMove:Duration:Type:)]) {
        [self.delegate onActionViewMove:self Duration:0 Type:ActionViewMoveByDefault];
    }
}

#pragma mark - HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.frame = r;
    
    // notify move
    if(self.delegate && [self.delegate respondsToSelector:@selector(onActionViewMove:Duration:Type:)]) {
        [self.delegate onActionViewMove:self Duration:0 Type:ActionViewMoveByDefault];
    }
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onActionViewInputChange:)]) {
        [self.delegate onActionViewInputChange:growingTextView.text];
    }
    
    if ([growingTextView.text length] > 0) {
        [self.commitButton setEnabled:YES];
    }
    else {
        [self.commitButton setEnabled:NO];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
    if ([text isEqualToString:@"\n"]) {
        [self onClickCommitButton];
        return NO;
    }
    
    if (text.length == 0 && range.location != NSNotFound && range.length == 1) {
        NSString * text = [growingTextView text];
        NSRange del = NSMakeRange(NSNotFound, 0);
        if (self.selectRange.length > 1) {
            if (self.selectRange.location + self.selectRange.length < [text length]) {
                del = self.selectRange;
            }
        }
        else if (self.selectRange.location <= [text length]) {
            if (self.selectRange.location > 2) {
                unichar ch = [text characterAtIndex:self.selectRange.location - 2];
                if (ch >= 0xD800 && ch <= 0xDFFF) {
                    del = NSMakeRange(self.selectRange.location - 2, 2);
                }
                else {
                    del = NSMakeRange(self.selectRange.location - 1, 1);
                }
            }
            else {
                del = NSMakeRange(self.selectRange.location - 1, 1);
            }
        }
        if (del.location != NSNotFound) {
            _selectRange.location = del.location;
            _selectRange.length = 0;
        }
    }
    
    return YES;
}

#pragma mark - private function
-(void)commonInitialiser
{
    [self registerNotification];
    
    [self setBackgroundColor:[UIColor colorWithHexString:@"fcfcfc"]];
    
    // 分割线
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    [line1 setBackgroundColor:[UIColor colorWithHexString:@"f5f5f5"]];
    [self addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    [line2 setBackgroundColor:[UIColor colorWithHexString:@"e0e0e0"]];
    [self addSubview:line2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    [line3 setBackgroundColor:[UIColor colorWithHexString:@"d5d5d5"]];
    [self addSubview:line3];
    
    // 发表按钮
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commitButton setFrame:CGRectMake(self.width - 10 - 55, 7.5, 55, 35)];
    [self.commitButton setTitle:@"发表" forState:UIControlStateNormal];
    [self.commitButton addTarget:self action:@selector(onClickCommitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.commitButton setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self.commitButton setBackgroundImage:[UIImage imageWithColor:kCommonParentTintColor size:CGSizeMake(55, 35) cornerRadius:2] forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"007bbe"] size:CGSizeMake(55, 35) cornerRadius:2] forState:UIControlStateHighlighted];
    [self.commitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"e5e5e5"] size:CGSizeMake(55, 35) cornerRadius:2] forState:UIControlStateDisabled];
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commitButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [self.commitButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [self addSubview:self.commitButton];
    [self.commitButton setEnabled:NO];
    
    // 输入框背景
//    UIView* inputBg = [[UIView alloc] initWithFrame:CGRectMake(10, 11, self.width - 47 - 13 - 10, 31)];
//    inputBg.backgroundColor = kColorFF;
//    inputBg.layer.borderColor = kColorD7D7D7.CGColor;
//    inputBg.layer.cornerRadius = inputBg.height / 2;
//    [self addSubview:inputBg];
    
    // 设置TextView
    self.hPGrowingTextView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 7.5, self.width - 10 - 10 - 55 - 10, 35)];
    [self.hPGrowingTextView setBackgroundColor:[UIColor clearColor]];
    self.hPGrowingTextView.layer.cornerRadius = 5.0f;
    self.hPGrowingTextView.layer.borderColor = [UIColor colorWithHexString:@"D7D7D7"].CGColor;
    [self.hPGrowingTextView setClipsToBounds:YES];
    self.hPGrowingTextView.layer.borderWidth = 0.5f;
    [self.hPGrowingTextView setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.hPGrowingTextView setFont:[UIFont systemFontOfSize:16]];
    [self.hPGrowingTextView setMinNumberOfLines:1];
    [self.hPGrowingTextView setMaxNumberOfLines:3];
    [self.hPGrowingTextView setReturnKeyType:UIReturnKeyDone];
    [self.hPGrowingTextView setMaxHeight:80];
    [[self.hPGrowingTextView internalTextView] setScrollsToTop:NO];
    [[self.hPGrowingTextView internalTextView] setScrollIndicatorInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [self.hPGrowingTextView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.hPGrowingTextView setDelegate:self];
    [self addSubview:self.hPGrowingTextView];
    
    // 输入前景 ImageView
//    self.inputViewFG = [[UIImageView alloc] initWithFrame:CGRectMake(left - 3, 1, width + 6, 43)];
//    [self.inputViewFG setImage:[[UIImage imageNamed:@"input_field.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:22]];
//    [self.inputViewFG setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
//    [self addSubview:self.inputViewFG];
    
    // cancel button
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.cancelButton addTarget:self action:@selector(onClickCancelButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void) onClickCancelButton
{
    [self resignFocus];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(onActionViewCancel)]) {
        [self.delegate onActionViewCancel];
    }
}

- (void) onClickCommitButton
{
    NSString* content = self.hPGrowingTextView.text;
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(content == nil && [content length] == 0) {
        return;
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(onActionViewCommit:)]) {
        [self.delegate onActionViewCommit:content];
    }
}

// 注册消息
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 注销消息
- (void)unregisterNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// 键盘将要显示
- (void)keyboardWillShow:(NSNotification *)notification
{
    if (![self.hPGrowingTextView isFirstResponder]) {
        return;
    }
    
    if(!self.cancelButton.superview) {
        [self.superview insertSubview:self.cancelButton belowSubview:self];
    }
    
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.superview convertRect:keyboardBounds toView:nil];

    
    // get a rect for the textView frame
    CGRect containerFrame = self.frame;
    containerFrame.origin.y = self.superview.bounds.size.height - keyboardBounds.size.height - self.frame.size.height;
    
#pragma mark - 第三方键盘的工具条跟随效果 去掉动画 - Lst
    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.frame = containerFrame;
    
    // commit animations
//    [UIView commitAnimations];
    
    // notify move
    if(self.delegate && [self.delegate respondsToSelector:@selector(onActionViewMove:Duration:Type:)]) {
        [self.delegate onActionViewMove:self Duration:duration.doubleValue Type:ActionViewMoveByKeyBoardWillShow];
    }
}

// 键盘消失
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (![self.hPGrowingTextView.internalTextView isFirstResponder]) {
        return;
    }
    
    if(self.cancelButton.superview) {
        [self.cancelButton removeFromSuperview];
    }
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.frame;
    
    containerFrame.origin.y = self.superview.bounds.size.height - self.frame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
    
    // notify move
    if(self.delegate && [self.delegate respondsToSelector:@selector(onActionViewMove:Duration:Type:)]) {
        [self.delegate onActionViewMove:self Duration:[duration doubleValue] Type:ActionViewMoveByKeyBoardWillHiden];
    }
}

@end

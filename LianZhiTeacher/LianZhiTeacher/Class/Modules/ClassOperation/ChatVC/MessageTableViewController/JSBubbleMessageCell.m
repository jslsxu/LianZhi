//
//  JSBubbleMessageCell.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSBubbleMessageCell.h"

#define kTopMargin                  6
#define TIMESTAMP_LABEL_HEIGHT      20
#define kInnerVMargin               4
#define kBottomMargin               10

@interface JSBubbleMessageCell()

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress;
- (void)handleMenuWillHideNotification:(NSNotification *)notification;
- (void)handleMenuWillShowNotification:(NSNotification *)notification;

@end



@implementation JSBubbleMessageCell
//@synthesize messageItem = _messageItem;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _createTimeView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_createTimeView setUserInteractionEnabled:NO];
        [_createTimeView setFrame:CGRectMake(0.0f,
                                             kTopMargin,
                                             self.bounds.size.width,
                                             TIMESTAMP_LABEL_HEIGHT)];
        [_createTimeView setBackgroundImage:[[UIImage imageNamed:@"MsgTimeBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
        [_createTimeView.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_createTimeView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_createTimeView];

        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(0, 0, kAvatarSize, kAvatarSize)];
        [self addSubview:_avatarView];
        
        _bubbleView = [[MsgBubbleView alloc] initWithFrame:CGRectMake(0, _createTimeView.bottom + kInnerVMargin + kInnerVMargin, 0, 0)];
        [self addSubview:_bubbleView];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicator setHidesWhenStopped:YES];
        [self addSubview:_indicator];
        
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(handleLongPress:)];
        [recognizer setMinimumPressDuration:0.4];
        [_bubbleView addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    MessageItem *messageItem = (MessageItem *)modelItem;
    [_createTimeView setTitle:messageItem.ctime forState:UIControlStateNormal];
    [_createTimeView.titleLabel sizeToFit];
    CGSize titleSize = _createTimeView.titleLabel.size;
    [_createTimeView setFrame:CGRectMake(self.width / 2 - titleSize.width / 2 - 10, kTopMargin, titleSize.width + 20, TIMESTAMP_LABEL_HEIGHT)];
    [_bubbleView setItem:messageItem];
    [_avatarView setImageWithUrl:[NSURL URLWithString:messageItem.userInfo.avatar]];
    if(messageItem.messageType == MessageTypeIncoming)
    {
        [_avatarView setOrigin:CGPointMake(10, kTopMargin + TIMESTAMP_LABEL_HEIGHT + kInnerVMargin)];
        [_bubbleView setOrigin:CGPointMake(kAvatarSize + 15, kTopMargin + TIMESTAMP_LABEL_HEIGHT + kInnerVMargin)];
    }
    else
    {
        [_avatarView setOrigin:CGPointMake(self.width - kAvatarSize - 10, kTopMargin + TIMESTAMP_LABEL_HEIGHT + kInnerVMargin)];
        [_bubbleView setOrigin:CGPointMake(self.width - kAvatarSize - 15 - _bubbleView.width, kTopMargin + TIMESTAMP_LABEL_HEIGHT + kInnerVMargin)];
        if(messageItem.messageState == MessageStateSending)
        {
            [_indicator setCenter:CGPointMake(_bubbleView.x - 5 - _indicator.width / 2, _bubbleView.y +  _bubbleView.height / 2)];
            [_indicator startAnimating];
        }
        else if(messageItem.messageState == MessageStateNormal || messageItem.messageState == MessageStateSendSuccess)
        {
            [_indicator setCenter:CGPointMake(_bubbleView.x - 5 - _indicator.width / 2, _bubbleView.y + _bubbleView.height / 2)];
            [_indicator stopAnimating];
        }
            
    }
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return [NSNumber numberWithFloat:(kTopMargin + TIMESTAMP_LABEL_HEIGHT + kInnerVMargin + [MsgBubbleView sizeForItem:(MessageItem *)modelItem].height + kBottomMargin)];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Copying
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(copy:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

- (void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:_bubbleView.item.content];
    [self resignFirstResponder];
}

#pragma mark - Touch events
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(![self isFirstResponder])
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
    [menu update];
    [self resignFirstResponder];
}

#pragma mark - Gestures
- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state != UIGestureRecognizerStateBegan
       || ![self becomeFirstResponder])
        return;
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    CGRect targetRect = [self convertRect:[_bubbleView bubbleFrame]
                                 fromView:_bubbleView];
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - Notification
- (void)handleMenuWillHideNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
    _bubbleView.selectedToShowCopyMenu = NO;
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
    
    _bubbleView.selectedToShowCopyMenu = YES;
}

@end
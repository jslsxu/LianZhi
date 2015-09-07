//
//  MsgBubbleView.m
//  MFWIOS
//
//  Created by jslsxu on 9/24/13.
//  Copyright (c) 2013 mafengwo. All rights reserved.
//

#import "MsgBubbleView.h"

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 6.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f
#define CONTENT_FONT            [UIFont systemFontOfSize:14]
#define CONTENT_COLOR_LEFT      [UIColor colorWithRed:0x7e/255. green:0x7e/255. blue:0x7e/255. alpha:1]
#define CONTENT_COLOR_RRIGHT    [UIColor colorWithRed:0x9c/255. green:0xa8/255. blue:0xac/255. alpha:1]
#define CONTENT_CLICK_COLOR     [UIColor colorWithRed:249.0/255 green:116.0/255 blue:21.0/255 alpha:1]

@implementation MsgBubbleView

@synthesize item = _item;
@synthesize selectedToShowCopyMenu = _selectedToShowCopyMenu;

#pragma mark - Setup

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        _contentLabel = [[ExpActionLabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setUserInteractionEnabled:NO];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:CONTENT_FONT];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_contentLabel];
    }
    return self;
}

+ (CGSize)sizeForItem:(MessageItem *)messageItem
{
    CGFloat leftMargin = (messageItem.messageType == MessageTypeIncoming) ? 20 : 10;
    CGFloat rightMargin = (messageItem.messageType == MessageTypeOutgoing) ? 10 : 20;
    CGFloat maxWidth = 250 - (kAvatarSize + 15)  - (leftMargin + rightMargin);
    
    CGSize contentSize;
    ExpText* expText = [[ExpText alloc] init];
    [expText setActionFont:CONTENT_FONT];
    [expText setTextFont:CONTENT_FONT];
    [expText setTextColor:CONTENT_COLOR_RRIGHT];
    [expText setWidth:maxWidth];
    expText.text = messageItem.content;
    expText.actionColor = CONTENT_CLICK_COLOR;
    contentSize = expText.contentSize;

    return CGSizeMake(MAX(30 + contentSize.width, 40), MAX(40, 20 + contentSize.height));
}

#pragma mark - Setters
- (void)setItem:(MessageItem *)item
{
    if(_item != item)
    {
        _item = item;
        [self update];
    }
}

- (void)setSelectedToShowCopyMenu:(BOOL)isSelected
{
    if(_selectedToShowCopyMenu != isSelected)
        _selectedToShowCopyMenu = isSelected;
    [self update];
}

- (CGRect)bubbleFrame
{
    return _contentLabel.frame;
}

- (UIImage *)bubbleImage
{
    return [MsgBubbleView bubbleImageForType:_item.messageType];
}

- (UIImage *)bubbleImageHighlighted
{
    
    return (_item.messageType == MessageTypeIncoming) ? [[UIImage imageNamed:@"MessageBGIncomingPressed.png" ] resizableImageWithCapInsets:UIEdgeInsetsMake(25.0f, 20.0f, 10.0f, 10.0f)] : [[UIImage imageNamed:@"MessageBGOutgoingPressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(25.0f, 10.0f, 10.0f, 20.0f)];
    
}

- (void)update
{
    CGFloat leftMargin = (_item.messageType == MessageTypeIncoming) ? 20 : 10;
    CGFloat rightMargin = (_item.messageType == MessageTypeOutgoing) ? 10 : 20;
    CGFloat maxWidth = 250 - (kAvatarSize + 15)  - (leftMargin + rightMargin);
    self.image = (self.selectedToShowCopyMenu) ? [self bubbleImageHighlighted] : [self bubbleImage];
    
    CGSize contentSize;
    ExpText* expText = [[ExpText alloc] init];
    [expText setActionFont:CONTENT_FONT];
    [expText setTextFont:CONTENT_FONT];
    [expText setTextColor:CONTENT_COLOR_RRIGHT];
    [expText setWidth:maxWidth];
    expText.text = _item.content;
    expText.actionColor = CONTENT_CLICK_COLOR;
    contentSize = expText.contentSize;


    [self setSize:CGSizeMake(MAX(30 + contentSize.width, 40), MAX(40, 20 + contentSize.height))];
    _contentLabel.expText = expText;
    [_contentLabel setFrame:CGRectMake(leftMargin, 10, contentSize.width, contentSize.height)];
    
}


#pragma mark - Bubble view
+ (UIImage *)bubbleImageForType:(MessageType)aType
{
    switch (aType) {
        case MessageTypeIncoming:
            return [self bubbleImageTypeIncoming];
            
        case MessageTypeOutgoing:
            return [self bubbleImageTypeOutgoing];
            
        default:
            return nil;
    }
}

+ (UIImage *)bubbleImageTypeIncoming
{
    return [[UIImage imageNamed:@"MessageBGIncoming.png" ] resizableImageWithCapInsets:UIEdgeInsetsMake(25.0f, 20.0f, 10.0f, 10.0f)];
}

+ (UIImage *)bubbleImageTypeOutgoing
{
    return [[UIImage imageNamed:@"MessageBGOutgoing.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(25.0f, 10.0f, 10.0f, 20.0f)];
    
}

@end

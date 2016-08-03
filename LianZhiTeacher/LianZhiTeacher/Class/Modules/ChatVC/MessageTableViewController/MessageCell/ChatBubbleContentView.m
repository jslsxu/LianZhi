//
//  ChatBubbleContentView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatBubbleContentView.h"

@implementation ChatBubbleContentView

- (instancetype)initWithModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    self = [super initWithFrame:CGRectZero];
    if(self){
        _messageItem = messageItem;
        _maxWidth = maxWidth;
        
        _bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_bubbleBackgroundView setUserInteractionEnabled:YES];
        [self addSubview:_bubbleBackgroundView];
        
    }
    return self;
}

- (void)setMessageItem:(MessageItem *)messageItem{
    _messageItem = messageItem;
    if(self.messageItem.isMyMessage){
        [_bubbleBackgroundView setImage:[[UIImage imageNamed:@"MessageSendedBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)]];
        [_bubbleBackgroundView setHighlightedImage:[[UIImage imageNamed:@"MessageSendedBGHighlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)]];
    }
    else{
        [_bubbleBackgroundView setImage:[[UIImage imageNamed:@"MessageReceivedBG"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)]];
        [_bubbleBackgroundView setHighlightedImage:[[UIImage imageNamed:@"MessageReceivedBGHighlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(26, 20, 8, 20)]];
    }

}

+ (CGFloat)contentHeightForModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    return 0;
}

@end

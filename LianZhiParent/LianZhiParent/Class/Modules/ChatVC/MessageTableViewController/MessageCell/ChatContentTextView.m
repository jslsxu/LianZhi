//
//  ChatTextCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatContentTextView.h"

#define kContentMaxMargin           15
#define kContentMinMargin           10

@implementation ChatContentTextView
- (instancetype)initWithModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    self = [super initWithModel:messageItem maxWidth:maxWidth];
    if(self){
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setNumberOfLines:0];
        [_bubbleBackgroundView addSubview:_contentLabel];
    }
    return self;
}

- (void)setMessageItem:(MessageItem *)messageItem{
    [super setMessageItem:messageItem];
    NSString *contentText = messageItem.content.text;
    if(messageItem.content.type != UUMessageTypeText){
        contentText = @"暂不支持此消息，请升级到最新版本重试";
    }
    CGSize contentSize = [contentText boundingRectWithSize:CGSizeMake(_maxWidth - kContentMaxMargin - kContentMinMargin, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
    [_contentLabel setText:contentText];
    if(self.messageItem.isMyMessage){
        [_contentLabel setTextColor:[UIColor whiteColor]];
        [_contentLabel setFrame:CGRectMake(kContentMinMargin, kContentMinMargin, contentSize.width, contentSize.height)];
    }
    else{
        [_contentLabel setTextColor:[UIColor blackColor]];
        [_contentLabel setFrame:CGRectMake(kContentMaxMargin, kContentMinMargin, contentSize.width , contentSize.height)];
    }
    [_bubbleBackgroundView setSize:CGSizeMake(contentSize.width + kContentMinMargin + kContentMaxMargin, contentSize.height + kContentMinMargin * 2)];
    [self setSize:_bubbleBackgroundView.size];
}

+ (CGFloat)contentHeightForModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    NSString *contentText = messageItem.content.text;
    if(messageItem.content.type != UUMessageTypeText){
        contentText = @"暂不支持此消息，请升级到最新版本重试";
    }
    CGSize contentSize = [contentText boundingRectWithSize:CGSizeMake(maxWidth - kContentMaxMargin - kContentMinMargin, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
    return contentSize.height + kContentMinMargin * 2;
}

@end

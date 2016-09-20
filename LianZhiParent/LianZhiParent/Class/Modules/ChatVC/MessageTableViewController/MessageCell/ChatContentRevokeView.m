//
//  ChatRevokeCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatContentRevokeView.h"

@implementation ChatContentRevokeView

- (instancetype)initWithModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    self = [super init];
    if(self){
        [self setSize:CGSizeMake(maxWidth, 32)];
        _revokeMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_revokeMessageLabel setNumberOfLines:0];
        [_revokeMessageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_revokeMessageLabel setTextAlignment:NSTextAlignmentCenter];
        [_revokeMessageLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [_revokeMessageLabel setTextColor:[UIColor whiteColor]];
        [_revokeMessageLabel setFont:[UIFont systemFontOfSize:13]];
        [_revokeMessageLabel.layer setCornerRadius:4];
        [_revokeMessageLabel.layer setMasksToBounds:YES];
        [self addSubview:_revokeMessageLabel];
    }
    return self;
}

- (void)setMessageItem:(MessageItem *)messageItem{
    _messageItem = messageItem;
    NSString *text = nil;
    if(_messageItem.from == UUMessageFromMe){
        text = @"你撤回了一条消息";
    }
    else{
        text = @"对方撤回了一条消息";
    }
    [_revokeMessageLabel setText:text];
    [_revokeMessageLabel sizeToFit];
    [_revokeMessageLabel setSize:CGSizeMake(_revokeMessageLabel.width + 10, _revokeMessageLabel.height + 4)];
    if(_messageItem.from == UUMessageFromMe){
        [_revokeMessageLabel setOrigin:CGPointMake((self.width - _revokeMessageLabel.width - 30) / 2, (self.height - _revokeMessageLabel.height) / 2)];
    }
    else{
        [_revokeMessageLabel setOrigin:CGPointMake((self.width - _revokeMessageLabel.width + 30) / 2, (self.height - _revokeMessageLabel.height) / 2)];
    }

}

+ (CGFloat)contentHeightForModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    return 32;
}

@end

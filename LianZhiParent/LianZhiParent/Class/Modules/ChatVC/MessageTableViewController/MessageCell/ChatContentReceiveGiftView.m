//
//  ChatReceiveGiftCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatContentReceiveGiftView.h"

@implementation ChatContentReceiveGiftView

- (instancetype)initWithModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    self = [super initWithModel:messageItem maxWidth:maxWidth];
    if(self){
        [_bubbleBackgroundView setHidden:YES];
        _giftMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_giftMessageLabel setNumberOfLines:0];
        [_giftMessageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_giftMessageLabel setTextAlignment:NSTextAlignmentCenter];
        [_giftMessageLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [_giftMessageLabel setTextColor:[UIColor whiteColor]];
        [_giftMessageLabel setFont:[UIFont systemFontOfSize:13]];
        [_giftMessageLabel.layer setCornerRadius:4];
        [_giftMessageLabel.layer setMasksToBounds:YES];
        [self addSubview:_giftMessageLabel];
    }
    return self;
}

- (void)setMessageItem:(MessageItem *)messageItem{
    [super setMessageItem:messageItem];
    NSMutableAttributedString *msg = [[NSMutableAttributedString alloc] init];
    if(UUMessageFromMe == messageItem.from) {//我接受礼物
        [msg appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"您领取了%@送的",messageItem.targetUser] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}]];
        if(messageItem.content.exinfo.presentName) {
            [msg appendAttributedString:[[NSAttributedString alloc] initWithString:messageItem.content.exinfo.presentName attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"fa9d3b"]}]];
        }
    }
    else {//对方接受礼物
        [msg appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"对方已领取您发送的%@,谢谢鼓励!",messageItem.content.exinfo.presentName] attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}]];
        [msg addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"fa9d3b"] range:NSMakeRange(9, messageItem.content.exinfo.presentName.length)];
    }
    [_giftMessageLabel setWidth:_maxWidth - 20];
    [_giftMessageLabel setAttributedText:msg];
    
    [_giftMessageLabel sizeToFit];
    CGFloat height = MAX(32, _giftMessageLabel.height + 4);
    [_giftMessageLabel setFrame:CGRectMake((_maxWidth - _giftMessageLabel.width - 10) / 2, (height - (_giftMessageLabel.height + 4)) / 2, _giftMessageLabel.width + 10, _giftMessageLabel.height + 4)];
    [self setSize:CGSizeMake(_maxWidth, height)];
}

+ (CGFloat)contentHeightForModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    return 32;
}

@end

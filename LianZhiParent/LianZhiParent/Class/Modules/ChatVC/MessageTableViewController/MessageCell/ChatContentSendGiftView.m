//
//  ChatGiftCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatContentSendGiftView.h"
NSString* const ReceiveGiftNotification = @"ReceiveGiftNotification";
NSString* const ReceiveGiftMessageKey = @"ReceiveGiftMessageKey";
@implementation ChatContentSendGiftView
- (instancetype)initWithModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    self = [super initWithModel:messageItem maxWidth:maxWidth];
    if(self){
        [_bubbleBackgroundView setHidden:YES];
        [self setBackgroundColor:[UIColor colorWithHexString:@"fa9d3b"]];
        [self.layer setCornerRadius:5];
        [self.layer setMasksToBounds:YES];
        
        _giftView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_giftView setClipsToBounds:YES];
        [_giftView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_giftView];
        
        _giftDetailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_giftDetailLabel setTextColor:[UIColor whiteColor]];
        [_giftDetailLabel setNumberOfLines:0];
        [_giftDetailLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_giftDetailLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onGiftTap)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setMessageItem:(MessageItem *)messageItem{
    [super setMessageItem:messageItem];
    [self setSize:CGSizeMake(180, 60)];
    [_giftView setFrame:CGRectMake(10, 5, 50, 50)];
    [_giftView sd_setImageWithURL:[NSURL URLWithString:messageItem.content.exinfo.imgs.small] placeholderImage:nil];
    
    [_giftDetailLabel setFrame:CGRectMake(_giftView.right + 10, 10, self.width - 10 - (_giftView.right + 10), 40)];
    if(messageItem.content.text.length > 0)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:6];
        NSMutableAttributedString *giftDetailStr = [[NSMutableAttributedString alloc] initWithString:messageItem.content.text attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSParagraphStyleAttributeName : paragraphStyle}];
        [giftDetailStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"点击查看" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSParagraphStyleAttributeName : paragraphStyle}]];
        [_giftDetailLabel setAttributedText:giftDetailStr];
    }

}

- (void)onGiftTap{
    if(self.messageItem.from == UUMessageFromOther) {
        //如果没有收
        if(self.messageItem.content.unread)
        {
            [GiftDetailView showWithImage:self.messageItem.content.exinfo.imgs.small title:[NSString stringWithFormat:@"%@给你送了%@",self.messageItem.targetUser, self.messageItem.content.exinfo.presentName] receiveCompletion:^{
                if(self.receiveGiftCallback){
                    self.receiveGiftCallback(self.messageItem);
                }
            } valid:YES];
        }
        else {
            [GiftDetailView showWithImage:self.messageItem.content.exinfo.imgs.small title:[NSString stringWithFormat:@"%@给您送了%@",self.messageItem.targetUser, self.messageItem.content.exinfo.presentName]receiveCompletion:^{
                
            } valid:NO];
            
        }
    }
    else {//自己发的
        [GiftDetailView showWithImage:self.messageItem.content.exinfo.imgs.small title:[NSString stringWithFormat:@"您给%@送了%@",self.messageItem.targetUser, self.messageItem.content.exinfo.presentName]];
    }
}

+ (CGFloat)contentHeightForModel:(MessageItem *)messageItem maxWidth:(CGFloat)maxWidth{
    return 60;
}

@end

//
//  ChatTopNewMessageView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatTopNewMessageView.h"

@implementation ChatTopNewMessageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:15];
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TopIndicator"]];
        [_contentView addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"28c4d8"]];
        [_contentView addSubview:_titleLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setMessageNum:(NSInteger)messageNum{
    _messageNum = messageNum;
    [_titleLabel setText:[NSString stringWithFormat:@"%zd条新消息",_messageNum]];
    [_titleLabel sizeToFit];
    [_contentView setSize:CGSizeMake(_imageView.width + _titleLabel.width + 6 + 12 * 2 + 15, 30)];
    [_imageView setOrigin:CGPointMake(12, (_contentView.height - _imageView.height) / 2)];
    [_titleLabel setOrigin:CGPointMake(_imageView.right + 6, (_contentView.height - _titleLabel.height) / 2)];
    [self setSize:CGSizeMake(_contentView.width - 15, 30)];
}

- (void)onTap{
    if(self.topNewMessageCallback){
        self.topNewMessageCallback();
    }
}

@end

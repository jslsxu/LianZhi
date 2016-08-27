//
//  ChatBottomNewMessageView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/25.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "ChatBottomNewMessageView.h"

@implementation ChatBottomNewMessageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChatBottomNewMessage"]];
        [self addSubview:_imageView];
        [self setSize:_imageView.size];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_numLabel setFont:[UIFont systemFontOfSize:14]];
        [_numLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_numLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setMessageNum:(NSInteger)messageNum{
    _messageNum = messageNum;
    NSString *text = nil;
    if(_messageNum <= 99){
        text = [NSString stringWithFormat:@"%zd",_messageNum];
    }
    else{
        text = @"99+";
    }
    [_numLabel setText:text];
    [_numLabel sizeToFit];
    [_numLabel setCenter:_imageView.center];
}

- (void)onTap{
    if(self.bottomNewCallback){
        self.bottomNewCallback();
    }
}

@end

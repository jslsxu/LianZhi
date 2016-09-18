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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 32)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView.layer setCornerRadius:16];
        [_contentView.layer setMasksToBounds:YES];
        [self addSubview:_contentView];
        
        _avatarView = [[AvatarView alloc] initWithRadius:14];
        [_avatarView setOrigin:CGPointMake(2, 2)];
        [_contentView addSubview:_avatarView];
        
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

- (void)showWithTargetItem:(MessageItem *)targetItem newMessageNum:(NSInteger)num{
    [self setTargetItem:targetItem];
    [_titleLabel setText:[NSString stringWithFormat:@"%zd条新消息",num]];
    [_titleLabel sizeToFit];
    [_avatarView setHidden:YES];
    [_contentView setSize:CGSizeMake(_imageView.width + _titleLabel.width + 6 + 12 * 2 + 15, 32)];
    [_imageView setOrigin:CGPointMake(12, (_contentView.height - _imageView.height) / 2)];
    [_titleLabel setOrigin:CGPointMake(_imageView.right + 6, (_contentView.height - _titleLabel.height) / 2)];
    [self setSize:CGSizeMake(_contentView.width - 15, 32)];
}

- (void)showAtWithTargetItem:(MessageItem *)targetItem{
    [self setTargetItem:targetItem];
    [_titleLabel setText:@"@我"];
    [_titleLabel sizeToFit];
    [_avatarView setHidden:NO];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_targetItem.user.avatar]];
    [_titleLabel setOrigin:CGPointMake(_avatarView.right + 6, (_contentView.height - _titleLabel.height) / 2)];
    [_imageView setOrigin:CGPointMake(_titleLabel.right + 5, (_contentView.height - _imageView.height) / 2)];
    [_contentView setSize:CGSizeMake(_imageView.right + 10 + 15, 32)];
    [self setSize:CGSizeMake(_contentView.width - 15, 32)];
}


- (void)onTap{
    if(self.topNewMessageCallback){
        self.topNewMessageCallback();
    }
}

@end

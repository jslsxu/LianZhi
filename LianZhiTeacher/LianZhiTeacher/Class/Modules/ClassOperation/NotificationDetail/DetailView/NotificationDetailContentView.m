//
//  NotificationDetailContentView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/30.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDetailContentView.h"

@interface  NotificationDetailContentView(){
    AvatarView*     _avatarView;
    UILabel*        _nameLabel;
    UILabel*        _statusLabel;
    UILabel*        _contentLabel;
    UIView*         _sepLine;
}

@end

@implementation NotificationDetailContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _avatarView = [[AvatarView alloc] initWithRadius:20];
        [_avatarView setOrigin:CGPointMake(10, 10)];
        [_avatarView setImageWithUrl:[NSURL URLWithString:@"http://www.pptbz.com/pptpic/UploadFiles_6909/201110/20111014111307895.jpg"] placeHolder:nil];
        [self addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setText:[UserCenter sharedInstance].userInfo.name];
        [_nameLabel sizeToFit];
        [_nameLabel setOrigin:CGPointMake(_avatarView.right + 5, _avatarView.centerY - 2 - _nameLabel.height)];
        [self addSubview:_nameLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_statusLabel setTextColor:kCommonTeacherTintColor];
        [_statusLabel setFont:[UIFont systemFontOfSize:12]];
        [_statusLabel setText:@"未发送"];
        [_statusLabel sizeToFit];
        [_statusLabel setOrigin:CGPointMake(_avatarView.right + 5, _avatarView.centerY + 2)];
        [self addSubview:_statusLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _avatarView.bottom + 5, self.width - 10 * 2, 0)];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setText:@"明天下午三点半是学校开放日，欢迎家长参加，园所已经为大家邀请了专业的设想是和摄影师，大家无需自带，谢谢配合，具体事项倾听我语音."];
        [_contentLabel sizeToFit];
        [self addSubview:_contentLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(10, _contentLabel.bottom + 10, self.width - 10 * 2, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];
        
        [self setHeight:_sepLine.bottom];
    }
    return self;
}

@end

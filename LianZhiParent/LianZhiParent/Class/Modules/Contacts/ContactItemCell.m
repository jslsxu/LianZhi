//
//  ContactItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ContactItemCell.h"
@implementation ContactItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        [_logoView setBorderColor:[UIColor whiteColor]];
        [_logoView setBorderWidth:2];
        [_logoView setCenter:CGPointMake(15 + _logoView.width / 2, 24)];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor lightGrayColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_nameLabel];
        
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_commentLabel setBackgroundColor:[UIColor clearColor]];
        [_commentLabel setTextColor:[UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:1.f]];
        [_commentLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_commentLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 48 - 0.5, self.width, 0.5)];
        [_sepLine setBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1.f]];
        [self addSubview:_sepLine];
    }
    return self;
}

- (void)setTeachInfo:(TeacherInfo *)teachInfo
{
    _teachInfo = teachInfo;
    [_logoView setImageWithUrl:[NSURL URLWithString:teachInfo.avatar]];
    
    [_nameLabel setText:_teachInfo.teacherName];
    [_nameLabel sizeToFit];
    [_nameLabel setFrame:CGRectMake(_logoView.right + 15, (self.height - _nameLabel.height) / 2, _nameLabel.width, _nameLabel.height)];
    
    [_commentLabel setText:[NSString stringWithFormat:@"(%@)",teachInfo.course]];
    [_commentLabel sizeToFit];
    [_commentLabel setOrigin:CGPointMake(_nameLabel.right + 15, (self.height - _commentLabel.height) / 2)];
}

@end

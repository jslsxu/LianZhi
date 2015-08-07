//
//  StudentGridView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/4.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "StudentGridView.h"

@implementation StudentGridView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [_bgImageView setImage:[[UIImage imageNamed:MJRefreshSrcName(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [self addSubview:_bgImageView];
        
        UIImageView *maskView = [[UIImageView alloc] initWithFrame:_bgImageView.bounds];
        [maskView setImage:[[UIImage imageNamed:MJRefreshSrcName(@"GrayBG.png")] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        
        _avatarView = [[UIImageView alloc] initWithFrame:_bgImageView.frame];
        [_avatarView.layer setMask:maskView.layer];
        [_avatarView.layer setMasksToBounds:YES];
        [self addSubview:_avatarView];
        
        _corner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FollowCorner.png"]];
        [_corner setOrigin:CGPointMake(self.width - _corner.width, 0)];
        [self addSubview:_corner];
        
        
        _coverImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"OperationSelectedBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_coverImage setFrame:_avatarView.frame];
        [_coverImage setHidden:YES];
        [self addSubview:_coverImage];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _avatarView.bottom, self.width, self.height - _avatarView.bottom)];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)setStudentInfo:(StudentInfo *)studentInfo
{
    _studentInfo = studentInfo;
    [_nameLabel setText:_studentInfo.name];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_studentInfo.avatar] placeholderImage:nil];
    _coverImage.hidden = !_studentInfo.selected;
    [_corner setHidden:!self.studentInfo.showFocus];
}
@end

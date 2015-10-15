//
//  ClassAppCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "ClassAppCell.h"

@implementation ClassAppCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self.layer setCornerRadius:10];
        [self.layer setMasksToBounds:YES];
        [self setBackgroundColor:[UIColor colorWithHexString:@"dbdbdb"]];
        _appImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 8, self.width - 18 * 2, self.width - 18 * 2)];
        [_appImageView setClipsToBounds:YES];
        [_appImageView  setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_appImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _appImageView.bottom, self.width, self.height - _appImageView.bottom)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:11]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    ClassAppItem *item = (ClassAppItem *)modelItem;
    [_appImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:nil];
    [_nameLabel setText:item.appName];
}

@end

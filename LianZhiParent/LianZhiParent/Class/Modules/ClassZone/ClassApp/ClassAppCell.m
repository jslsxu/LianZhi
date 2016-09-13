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
        CGFloat imageWidth = [ClassAppCell imageWidth];
        _appImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - imageWidth) / 2, 20, imageWidth, imageWidth)];
        [_appImageView setClipsToBounds:YES];
        [_appImageView  setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_appImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _appImageView.bottom + 5, self.width, 25)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:13]];
        [_nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_nameLabel];
        
        _indicator = [[NumIndicator alloc] initWithFrame:CGRectZero];
        [self addSubview:_indicator];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    ClassAppItem *item = (ClassAppItem *)modelItem;
    [_appImageView sd_setImageWithURL:[NSURL URLWithString:item.imageUrl] placeholderImage:nil];
    [_nameLabel setText:item.appName];
    [self setBadge:item.badge];
}

- (void)setBadge:(NSString *)badge
{
    _badge = badge;
    [_indicator setOrigin:CGPointMake(_appImageView.right, _appImageView.y)];
    [_indicator setHidden:!_badge];
    [_indicator setIndicator:_badge];
}

+ (CGFloat)imageWidth{
    return kScreenWidth * 30 / 320;
}

+ (CGFloat)cellHeight{
    CGFloat height = 0;
    height += 20;
    height += [self imageWidth];
    height += 5 + 25;
    return height;
}

@end

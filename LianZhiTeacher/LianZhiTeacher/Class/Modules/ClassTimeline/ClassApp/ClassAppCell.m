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
        _appImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_appImageView setClipsToBounds:YES];
        [_appImageView  setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_appImageView];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    ClassAppItem *appItem = (ClassAppItem *)modelItem;
    [_appImageView sd_setImageWithURL:[NSURL URLWithString:appItem.imageUrl]];
}

@end

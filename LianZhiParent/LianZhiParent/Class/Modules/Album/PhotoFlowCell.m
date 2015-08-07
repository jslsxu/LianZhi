//
//  PhotoFlowCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PhotoFlowCell.h"

@implementation PhotoFlowCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setClipsToBounds:YES];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView setBackgroundColor:[UIColor clearColor]];
        [_imageView setClipsToBounds:YES];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    PhotoItem *item = (PhotoItem *)modelItem;
    if(item.photoID.length && item.thumbnailUrl.length > 0)
    {
        [_imageView setImage:nil];
        [self setBackgroundColor:[UIColor lightGrayColor]];
        [_imageView setFrame:self.bounds];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:item.thumbnailUrl] placeholderImage:nil];
    }
    else
    {
        [_imageView setImage:nil];
        [self setBackgroundColor:kCommonParentTintColor];
        [_imageView setFrame:CGRectInset(self.bounds, 30, 30)];
        [_imageView setImage:[UIImage imageNamed:MJRefreshSrcName(@"PhotoFromAlbum.png")]];
    }
}
@end

//
//  CollectionImageCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/1/1.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "CollectionImageCell.h"

@implementation CollectionImageCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor lightGrayColor]];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setClipsToBounds:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_imageView];
        
        _uploadLabel = [[UILabel alloc] initWithFrame:_imageView.frame];
        [_uploadLabel setTextAlignment:NSTextAlignmentCenter];
        [_uploadLabel setNumberOfLines:0];
        [_uploadLabel setBackgroundColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.7]];
        [_uploadLabel setFont:[UIFont systemFontOfSize:14]];
        [_uploadLabel setTextColor:[UIColor whiteColor]];
        [_uploadLabel setText:@"等待\n上传"];
        [_uploadLabel setHidden:YES];
        [self addSubview:_uploadLabel];
    }
    return self;
}

- (void)setItem:(PhotoItem *)item
{
    _item = item;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_item.small] placeholderImage:_item.image options:SDWebImageRetryFailed|SDWebImageLowPriority];
    [_uploadLabel setHidden:!_item.publishImageItem];
}
@end

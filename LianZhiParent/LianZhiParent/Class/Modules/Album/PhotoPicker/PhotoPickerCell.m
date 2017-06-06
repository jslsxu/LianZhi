//
//  PhotoPickerCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/3/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PhotoPickerCell.h"

@implementation PhotoPickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setClipsToBounds:YES];
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setClipsToBounds:YES];
        [self addSubview:_imageView];
        
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        [_coverView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        [self addSubview:_coverView];
        
        _checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhotoPickerCheckMark.png"]];
        [self addSubview:_checkMark];
    }
    return self;
}

- (void)setItem:(PhotoPickerItem *)item
{
    _item = item;
    _coverView.hidden = !_item.selected;
    _checkMark.hidden = !_item.selected;
    [_imageView setFrame:self.bounds];
    [_imageView setImage:nil];
    [_coverView setFrame:self.bounds];
    [_checkMark setCenter:CGPointMake(self.width - 24, 24)];
    if(item.asset)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CGImageRef imageRef = [_item.asset aspectRatioThumbnail];
            UIImage* image = [UIImage imageWithCGImage:imageRef scale:1.f orientation:UIImageOrientationUp];
            [item.photoItem setImage:image];
            dispatch_async_on_main_queue(^{
                [_imageView setImage:image];
            });
        });
    }
    else
        [_imageView sd_setImageWithURL:[NSURL URLWithString:item.photoItem.small] placeholderImage:nil];
}



@end

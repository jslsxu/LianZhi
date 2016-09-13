//
//  EmptyHintView.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/12.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "EmptyHintView.h"

@implementation EmptyHintView

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title{
    self = [super init];
    if(self){
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"525252"]];
        [_titleLabel setText:title];
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
        
        CGFloat height = _imageView.height + 20 + _titleLabel.height;
        CGFloat width = MAX(_imageView.width, _titleLabel.width);
        [self setSize:CGSizeMake(width, height)];
        [_imageView setOrigin:CGPointMake((self.width - _imageView.width) / 2, 0)];
        [_titleLabel setOrigin:CGPointMake((self.width - _titleLabel.width) / 2, _imageView.bottom + 20)];
    }
    return self;
}

@end

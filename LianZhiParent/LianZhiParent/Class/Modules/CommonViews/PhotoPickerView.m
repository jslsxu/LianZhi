//
//  PhotoPickerView.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PhotoPickerView.h"


@implementation PhotoPickerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithHexString:@"D8D8D8"]];
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height / 6, self.width, self.height / 3)];
        [_hintLabel setTextColor:[UINavigationBar appearance].barTintColor];
        [_hintLabel setTextAlignment:NSTextAlignmentCenter];
        [_hintLabel setFont:[UIFont systemFontOfSize:14]];
        [_hintLabel setText:@"添加一张"];
        [self addSubview:_hintLabel];
        
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraBtn setImage:[UIImage imageNamed:@"PhotoPickerCamera"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(onCameraButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_cameraBtn setFrame:CGRectMake((self.width / 2 - 36) / 2, self.height / 2, 36, 36)];
        [self addSubview:_cameraBtn];
        
        _albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumBtn setImage:[UIImage imageNamed:@"PhotoPickerAlbum"] forState:UIControlStateNormal];
        [_albumBtn addTarget:self action:@selector(onAlbumButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_albumBtn setFrame:CGRectMake(self.width / 2 + (self.width / 2 - 36) / 2, _hintLabel.bottom + 5, 36, 36)];
        [self addSubview:_albumBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [_hintLabel setWidth:self.width];
    [_cameraBtn setFrame:CGRectMake(self.width / 4 - 36 / 2, _hintLabel.bottom + 5, 36, 36)];
    [_albumBtn setFrame:CGRectMake(self.width * 3 / 4 - 36 / 2, _hintLabel.bottom + 5, 36, 36)];
}

- (void)onCameraButtonClicked
{
    if([self.delegate respondsToSelector:@selector(photoPickerDidSelectCamera:)])
        [self.delegate photoPickerDidSelectCamera:self];
}

- (void)onAlbumButtonClicked
{
    if([self.delegate respondsToSelector:@selector(photoPickerDidSelectAlbum:)])
        [self.delegate photoPickerDidSelectAlbum:self];
}

@end


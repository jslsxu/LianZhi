//
//  TGMMddPhotoBrowserInfoBar.m
//  TravelGuideMdd
//
//  Created by CHANG LIU on 14/10/17.
//  Copyright (c) 2014年 mafengwo.com. All rights reserved.
//

#import "PhotoBrowserInfoBar.h"

@interface PhotoBrowserInfoBar()
{
    UILabel* _contentLabel;
}
@end

@implementation PhotoBrowserInfoBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width - 10, self.height)];
        [_contentLabel setTextColor:[UIColor whiteColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)setPhotoItem:(PhotoItem *)photoItem
{
    _photoItem = photoItem;
    [_contentLabel setText:_photoItem.comment];
}


@end

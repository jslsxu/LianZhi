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
    UIScrollView*   _scrollView;
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
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectInset(self.bounds, 10, 5)];
        [self addSubview:_scrollView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 0)];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setTextColor:[UIColor whiteColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_scrollView addSubview:_contentLabel];
    }
    return self;
}

- (void)setPhotoItem:(PhotoItem *)photoItem
{
    _photoItem = photoItem;
    [_contentLabel setWidth:_scrollView.width];
    [_contentLabel setText:_photoItem.words];
    [_contentLabel sizeToFit];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width, _contentLabel.height)];

}


@end

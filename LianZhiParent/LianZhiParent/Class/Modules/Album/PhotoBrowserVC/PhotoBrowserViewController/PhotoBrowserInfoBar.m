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
    UITextView*    _contentView;
    UIView*     _sepLine;
    UILabel*    _authorLabel;
    UILabel*    _timeLabel;
    UILabel*    _tagLabel;
}
@end

@implementation PhotoBrowserInfoBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        CGFloat margin = 10;
        _contentView = [[UITextView alloc] initWithFrame:CGRectMake(margin, margin, 190 - margin * 2, self.height - margin * 2)];
        _contentView.font = [UIFont boldSystemFontOfSize:14];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.textColor = [UIColor whiteColor];
        [_contentView setEditable:NO];
        [self addSubview:_contentView];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(_contentView.right, 0, 1, self.height)];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"353535"]];
        [self addSubview:_sepLine];
        
        CGFloat spaceXStart = _sepLine.right + margin;
        CGFloat width = self.width - margin - spaceXStart;
        
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, 20, width, 20)];
        _authorLabel.font = [UIFont systemFontOfSize:14];
        _authorLabel.backgroundColor = [UIColor clearColor];
        _authorLabel.textColor = [UIColor whiteColor];
        [self addSubview:_authorLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, _authorLabel.bottom, width, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:_timeLabel];
        
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(spaceXStart, _timeLabel.bottom, width, 20)];
        _tagLabel.font = [UIFont systemFontOfSize:14];
        _tagLabel.backgroundColor = [UIColor clearColor];
        _tagLabel.textColor = [UIColor whiteColor];
        [self addSubview:_tagLabel];
    }
    return self;
}

- (void)setPhotoItem:(PhotoItem *)photoItem
{
    _photoItem = photoItem;
    [_contentView setText:photoItem.comment];
    if([photoItem.tag length] > 0)
    {
        [_tagLabel setHidden:NO];
        [_tagLabel setText:[NSString stringWithFormat:@"成长标签:%@",photoItem.tag]];
    }
    else
        [_tagLabel setHidden:YES];
    [_timeLabel setText:photoItem.formatTimeStr];
    NSString *title = photoItem.userInfo.title;
    if([title length] == 0)
        title = photoItem.userInfo.name;
    [_authorLabel setText:title];
}


@end

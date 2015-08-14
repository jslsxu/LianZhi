//
//  SettingItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "SettingItemCell.h"

@implementation SettingItem


@end

@implementation SettingItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 60, self.height)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextColor:[UIColor colorWithRed:73 / 255.0 green:73 / 255.0 blue:73 / 255.0 alpha:1.f]];
        [_titleLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self addSubview:_titleLabel];
        
        _redDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"RedDot.png")]];
        [_redDot setCenter:CGPointMake(_titleLabel.right + 20, self.height / 2)];
        [self addSubview:_redDot];
        
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"BlueRightArrow.png")]];
        [_rightArrow setHighlightedImage:[UIImage imageNamed:(@"WhiteRightArrow.png")]];
        [_rightArrow setFrame:CGRectMake(self.width - 20 - _rightArrow.width, (self.height - _rightArrow.height) / 2, _rightArrow.width, _rightArrow.height)];
        [self addSubview:_rightArrow];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor grayColor]];
        [_contentLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)setItem:(SettingItem *)item
{
    _item = item;
    _rightArrow.hidden = NO;
    _contentLabel.hidden = YES;
    _titleLabel.text = item.title;
    _redDot.hidden = !_item.hasNew;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    _rightArrow.hidden = YES;
    _contentLabel.hidden = NO;
    _contentLabel.text = _content;
    [_contentLabel sizeToFit];
    [_contentLabel setOrigin:CGPointMake(self.width - 20 - _contentLabel.width, (self.height - _contentLabel.height) / 2)];
}

- (UIImage *)highlightedBGImageForCellType:(TableViewCellType)cellType
{
    NSString *imageStr = nil;
    if(cellType == TableViewCellTypeFirst)
        imageStr = (@"BlueBG.png");
    else if(cellType == TableViewCellTypeMiddle)
        imageStr = @"Middle_Selected.png";
    else if(cellType == TableViewCellTypeLast)
        imageStr = @"Last_Selected.png";
    else
        imageStr = (@"BlueBG.png");
    return [[UIImage imageNamed:imageStr] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
}
@end

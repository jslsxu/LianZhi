//
//  ClassZoneItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ClassZoneItemCell.h"
#import "CollectionImageCell.h"

NSString *const kClassZoneItemDeleteNotification = @"ClassZoneItemDeleteNotification";
NSString *const kClassZoneItemDeleteKey = @"ClassZoneItemDeleteKey";
@implementation ClassZoneItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"WhiteBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setUserInteractionEnabled:YES];
        [self addSubview:_bgImageView];
        
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        [_avatar setBorderColor:[UIColor colorWithWhite:0 alpha:0.2]];
        [_avatar setBorderWidth:2];
        [self addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self addSubview:_nameLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:16]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_bgImageView addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(0, 0, self.width - 50, 45)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView addSubview:_voiceButton];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(80, 80)];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setMinimumInteritemSpacing:5];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
        [_bgImageView addSubview:_collectionView];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_sepLine setBackgroundColor:kSepLineColor];
        [_bgImageView addSubview:_sepLine];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_bgImageView addSubview:_timeLabel];
    }
    return self;
}

- (void)onVoiceButtonClicked
{
    ClassZoneItem *item = (ClassZoneItem *)self.modelItem;
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:item.audioItem.audioUrl] withAutoPlay:YES];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ClassZoneItem *item = (ClassZoneItem *)self.modelItem;
    return item.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    ClassZoneItem *item = (ClassZoneItem *)self.modelItem;
    [cell setItem:item.photos[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassZoneItem *item = (ClassZoneItem *)self.modelItem;
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    [photoBrowser setBrowserType:PhotoBrowserTypeZone];
    NSMutableArray *photos = [NSMutableArray arrayWithArray:item.photos];
    for (PhotoItem *photoItem in photos) {
        [photoItem setUserInfo:item.userInfo];
        [photoItem setComment:item.content];
        [photoItem setFormatTimeStr:item.formatTime];
    }
    [photoBrowser setPhotos:photos];
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    ClassZoneItem *item = (ClassZoneItem *)self.modelItem;
    
    [_bgImageView setFrame:CGRectMake(12, 36, self.width - 12 * 2, 0)];
    [_avatar setImageWithUrl:[NSURL URLWithString:item.userInfo.avatar]];
    [_avatar setCenter:CGPointMake(45, _bgImageView.top)];
    [_nameLabel setText:item.userInfo.title];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_bgImageView.right - _nameLabel.width, _bgImageView.top - _nameLabel.height - 3)];
    
    CGSize contentSize = [item.content boundingRectWithSize:CGSizeMake(_bgImageView.width - 20 * 2, 0) andFont:_contentLabel.font];
    [_contentLabel setText:item.content];
    [_contentLabel setFrame:CGRectMake(20, 32, contentSize.width, contentSize.height)];
    
    CGFloat spaceYStart = _contentLabel.bottom;
    _collectionView.hidden = YES;
    _voiceButton.hidden = YES;
    if(item.photos.count > 0)
    {
        _collectionView.hidden = NO;
        [_collectionView setFrame:CGRectMake(20, spaceYStart+ 5, _bgImageView.width - 20 * 2, 80)];
        [_collectionView reloadData];
        spaceYStart += _collectionView.height + 15;
    }
    else
    {
        _collectionView.hidden = YES;
        [_voiceButton setAudioItem:item.audioItem];
        if(item.audioItem)
        {
            _voiceButton.hidden = NO;
            [_voiceButton setOrigin:CGPointMake(12, spaceYStart + 5)];
            spaceYStart += _voiceButton.height + 15;
        }
        else
        {
            _voiceButton.hidden = YES;
            spaceYStart += 10;
        }
    }
    
    [_sepLine setFrame:CGRectMake(0, spaceYStart, _bgImageView.width, 1)];
    
    [_timeLabel setText:item.formatTime];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_bgImageView.width - _timeLabel.width - 10, _sepLine.bottom + (30 - _timeLabel.height) / 2)];
    [_bgImageView setHeight:_sepLine.bottom + 30];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    CGFloat height = 36 + 32;
    ClassZoneItem *item = (ClassZoneItem *)modelItem;
    CGSize contentSize = [item.content boundingRectWithSize:CGSizeMake(width - 20 * 2 - 12 * 2, 0) andFont:[UIFont systemFontOfSize:16]];
    height += contentSize.height + 1 + 30;
    if(item.photos.count > 0)
        height += 80 + 10 + 5;
    else
    {
        if(item.audioItem)
        {
            height += 15 + 45;
        }
        else
            height += 10;
    }
    
    return @(height);
}
@end

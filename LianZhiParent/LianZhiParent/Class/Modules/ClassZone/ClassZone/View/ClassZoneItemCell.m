//
//  ClassZoneItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "ClassZoneItemCell.h"
#import "CollectionImageCell.h"
#define kInnerMargin                    8
#define kImageLeftMargin                55
#define kImageRightMargin               20

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
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        [self addSubview:_avatar];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_avatar.right + 10, 10, 0, 15)];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"a0a0a0"]];
        [self addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(kImageLeftMargin, 0, self.width - kImageLeftMargin - 30, 45)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_voiceButton];
        
        NSInteger collectionWidth = self.width - kImageLeftMargin - kImageRightMargin;
        NSInteger itemWidth = (collectionWidth - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (collectionWidth - itemWidth * 3) / 2;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(itemWidth, itemWidth)];
        [layout setMinimumInteritemSpacing:innerMargin];
        [layout setMinimumLineSpacing:innerMargin];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
        [self addSubview:_collectionView];
        
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressButton setTitleColor:[UIColor colorWithHexString:@"a0a0a0"] forState:UIControlStateNormal];
        [_addressButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_addressButton];
        
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setImage:[UIImage imageNamed:@"TimelineAction"] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(onActionClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_actionButton];
        
        _responseView = [[ResponseView alloc] initWithFrame:CGRectMake(kImageLeftMargin, 0, self.width - kImageLeftMargin - 10, 0)];
        [_responseView setDelegate:self];
        [self addSubview:_responseView];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_sepLine setBackgroundColor:kSepLineColor];
        [self addSubview:_sepLine];

    }
    return self;
}

- (void)onVoiceButtonClicked
{
    ClassZoneItem *item = (ClassZoneItem *)self.modelItem;
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:item.audioItem.audioUrl] withAutoPlay:YES];
}

- (void)onActionClicked
{
    if([self.delegate respondsToSelector:@selector(onActionClicked:)])
    {
        [self.delegate onActionClicked:self];
    }
}

#pragma mark -ResponseDelegate
- (void)onResponseItemClicked:(ResponseItem *)responseItem
{
    if([self.delegate respondsToSelector:@selector(onResponseClickedAtTarget: cell:)])
        [self.delegate onResponseClickedAtTarget:responseItem cell:self];
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
    [_avatar setImageWithUrl:[NSURL URLWithString:item.userInfo.avatar]];
    [_nameLabel setText:item.userInfo.title];
    [_nameLabel sizeToFit];
    
    [_timeLabel setText:item.formatTime];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_nameLabel.right + 5, _nameLabel.bottom - _timeLabel.height)];
    
    NSInteger contentWidth = self.width - kImageLeftMargin - kImageRightMargin;
    CGSize contentSize = [item.content boundingRectWithSize:CGSizeMake(contentWidth, 0) andFont:_contentLabel.font];
    [_contentLabel setText:item.content];
    [_contentLabel setFrame:CGRectMake(kImageLeftMargin, 30, contentSize.width, contentSize.height)];
    
    CGFloat spaceYStart = _contentLabel.bottom + 5;
    _collectionView.hidden = YES;
    _voiceButton.hidden = YES;
    NSInteger imageCount = item.photos.count;
    if(imageCount > 0)
    {
        NSInteger row = (item.photos.count + 2) / 3;
        NSInteger itemWidth = (contentWidth - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (contentWidth - itemWidth * 3) / 2;
        [_collectionView setHidden:NO];
        NSInteger imageWidth = (row > 1) ? contentWidth : (itemWidth * imageCount + innerMargin * (imageCount - 1));
        [_collectionView setFrame:CGRectMake(kImageLeftMargin, spaceYStart, imageWidth, itemWidth * row + innerMargin * (row - 1))];
        [_collectionView reloadData];
        spaceYStart += _collectionView.height + 10;
    }
    else
    {
        _collectionView.hidden = YES;
        [_voiceButton setAudioItem:item.audioItem];
        if(item.audioItem)
        {
            _voiceButton.hidden = NO;
            [_voiceButton setY:spaceYStart + 5];
            spaceYStart += _voiceButton.height + 15;
        }
        else
        {
            _voiceButton.hidden = YES;
            spaceYStart += 10;
        }
    }
    [_addressButton setTitle:item.position forState:UIControlStateNormal];
    CGSize titleSize = [[_addressButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    [_addressButton setFrame:CGRectMake(kImageLeftMargin, spaceYStart, titleSize.width, 20)];
    [_actionButton setFrame:CGRectMake(self.width - 40, spaceYStart, 40, 20)];
    spaceYStart += 20 + 10;
    
    [_responseView setFrame:CGRectMake(kImageLeftMargin, spaceYStart, self.width - kImageLeftMargin - 10, 100)];
    [_responseView setResponseModel:item.responseModel];
    if(_responseView.height > 0)
        spaceYStart += _responseView.height + 10;
    [_sepLine setFrame:CGRectMake(0, spaceYStart, self.width, kLineHeight)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    CGFloat height = 30;
    ClassZoneItem *item = (ClassZoneItem *)modelItem;
    CGSize contentSize = [item.content boundingRectWithSize:CGSizeMake(width - kImageLeftMargin - kImageRightMargin, 0) andFont:[UIFont systemFontOfSize:14]];
    height += contentSize.height + 5;
    if(item.photos.count > 0)
    {
        NSInteger bgWidth = width - kImageLeftMargin - kImageRightMargin;
        NSInteger itemWidth = (bgWidth - kInnerMargin * 2) / 3;
        NSInteger row = (item.photos.count + 2) / 3;
        NSInteger innerMargin = (bgWidth - itemWidth * 3) / 2;
        height += (itemWidth * row + innerMargin * (row - 1)) + 10;
    }
    else
    {
        if(item.audioItem)
        {
            height += 15 + 45;
        }
        else
            height += 10;
    }
    height += 20 + 10;
    NSInteger resposeHeight = [ResponseView responseHeightForResponse:item.responseModel forWidth:width - 20 * 2 - 12 * 2];
    if(resposeHeight > 0)
        height += resposeHeight + 10;
    return @(height);
}
@end

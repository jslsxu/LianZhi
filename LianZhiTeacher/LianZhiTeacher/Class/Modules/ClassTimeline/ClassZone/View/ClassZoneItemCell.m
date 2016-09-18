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
    { [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _avatar = [[AvatarView alloc] initWithFrame:CGRectMake(12, 10, 35, 35)];
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
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setFrame:CGRectMake(self.width - 40, 0, 40, 40)];
        [_deleteButton setImage:[UIImage imageNamed:@"ClassZoneTrash"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(onDeleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [self addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(50, 0, self.width - 10 - 50 - 60, 45)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_voiceButton];
        
        _spanLabel = [[UILabel alloc] initWithFrame:CGRectMake(_voiceButton.right, _voiceButton.y, 60, _voiceButton.height)];
        [_spanLabel setTextAlignment:NSTextAlignmentCenter];
        [_spanLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_spanLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_spanLabel];
        
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
        [_addressButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.5] size:CGSizeMake(10, 10)] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateHighlighted];
        [_addressButton addTarget:self action:@selector(onAddressClicked) forControlEvents:UIControlEventTouchUpInside];
        [_addressButton setTitleColor:[UIColor colorWithHexString:@"9a9a9a"] forState:UIControlStateNormal];
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

- (void)onDeleteButtonClicked
{
    if([self.delegate respondsToSelector:@selector(onClassZoneItemDelete:)]){
        [self.delegate onClassZoneItemDelete:(ClassZoneItem *)self.modelItem];
    }
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

- (void)onAddressClicked
{
    ClassZoneItem *item = (ClassZoneItem *)self.modelItem;
    if(item.position.length > 0)
    {
        DestinationVC *destinationVC = [[DestinationVC alloc] init];
        [destinationVC setPosition:item.position];
        [destinationVC setLongitude:item.longitude];
        [destinationVC setLatitude:item.latitude];
        [CurrentROOTNavigationVC pushViewController:destinationVC animated:YES];
    }
}

#pragma mark -ResponseDelegate
- (void)onResponseItemClicked:(ResponseItem *)responseItem
{
    if([self.delegate respondsToSelector:@selector(onResponseClickedAtTarget:cell:)])
        [self.delegate onResponseClickedAtTarget:responseItem cell:self];
}

- (void)onDetailClicked
{
    if([self.delegate respondsToSelector:@selector(onShowDetail:)])
        [self.delegate onShowDetail:(ClassZoneItem *)self.modelItem];
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
    NSMutableArray *photos = [NSMutableArray arrayWithArray:item.photos];
    for (PhotoItem *photoItem in photos) {
        [photoItem setUser:item.userInfo];
        [photoItem setWords:item.content];
        [photoItem setTime_str:item.formatTime];
    }
    [photoBrowser setDelegate:self];
    [photoBrowser setPhotos:photos];
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    ClassZoneItem *item = (ClassZoneItem *)self.modelItem;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:item.userInfo.avatar]];
    if([item.userInfo.uid isEqualToString:[UserCenter sharedInstance].userInfo.uid])
        [_nameLabel setText:@"我"];
    else
        [_nameLabel setText:item.userInfo.title];
    [_nameLabel sizeToFit];
    
    [_timeLabel setText:item.formatTime];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_nameLabel.right + 5, _nameLabel.bottom - _timeLabel.height)];
    
    _deleteButton.hidden = !([item.userInfo.uid isEqualToString:[UserCenter sharedInstance].userInfo.uid]) || item.newSent || item.isUploading;
    
    NSInteger contentWidth = self.width - kImageLeftMargin - kImageRightMargin;
    CGSize contentSize = [item.content boundingRectWithSize:CGSizeMake(contentWidth, 0) andFont:_contentLabel.font];
    [_contentLabel setText:item.content];
    [_contentLabel setFrame:CGRectMake(kImageLeftMargin, 34, contentSize.width, contentSize.height)];
    
    CGFloat spaceYStart = _contentLabel.bottom + 5;
    _collectionView.hidden = YES;
    _voiceButton.hidden = YES;
    _spanLabel.hidden = YES;
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
        spaceYStart += _collectionView.height + 5;
    }
    else
    {
        _collectionView.hidden = YES;
        [_voiceButton setAudioItem:item.audioItem];
        if(item.audioItem)
        {
            _voiceButton.hidden = NO;
            _spanLabel.hidden = NO;
            [_voiceButton setOrigin:CGPointMake(50, spaceYStart + 5)];
            [_spanLabel setY:_voiceButton.y];
            [_spanLabel setText:[Utility formatStringForTime:item.audioItem.timeSpan]];
            spaceYStart += 45 + 5;
        }
        else
        {
            _voiceButton.hidden = YES;
        }
    }
    [_addressButton setTitle:item.position forState:UIControlStateNormal];
    CGSize titleSize = [[_addressButton titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    [_addressButton setFrame:CGRectMake(kImageLeftMargin, spaceYStart, titleSize.width, 20)];
    [_actionButton setFrame:CGRectMake(self.width - 40, spaceYStart, 40, 25)];
    if(item.newSent)
    {
        [_actionButton setHidden:YES];
        NSLog(@"hidden action button \n\n\n");
    }
    else
        [_actionButton setHidden:NO];
    spaceYStart += 25;
    
    [_responseView setFrame:CGRectMake(kImageLeftMargin, spaceYStart, self.width - kImageLeftMargin - 10, 100)];
    [_responseView setResponseModel:item.responseModel];
    if(_responseView.height > 0)
        spaceYStart += _responseView.height + 10;
    [_sepLine setFrame:CGRectMake(0, spaceYStart, self.width, kLineHeight)];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    CGFloat height = 34;
    ClassZoneItem *item = (ClassZoneItem *)modelItem;
    CGSize contentSize = [item.content boundingRectWithSize:CGSizeMake(width - kImageLeftMargin - kImageRightMargin, 0) andFont:[UIFont systemFontOfSize:14]];
    height += contentSize.height + 5;
    if(item.photos.count > 0)
    {
        NSInteger bgWidth = width - kImageLeftMargin - kImageRightMargin;
        NSInteger itemWidth = (bgWidth - kInnerMargin * 2) / 3;
        NSInteger row = (item.photos.count + 2) / 3;
        NSInteger innerMargin = (bgWidth - itemWidth * 3) / 2;
        height += (itemWidth * row + innerMargin * (row - 1)) + 5;
    }
    else
    {
        if(item.audioItem)
        {
            height += 5 + 45;
        }
    }
    height += 20 + 5;
    NSInteger resposeHeight = [ResponseView responseHeightForResponse:item.responseModel forWidth:width - kImageLeftMargin - 10];
    if(resposeHeight > 0)
        height += resposeHeight + 10;
    return @(height);
}
#pragma mark - PhotoBrowserDelegate
- (void)photoBrowserFinished:(NSArray *)resultArray
{
    NSMutableArray *removedItems = [NSMutableArray array];
    ClassZoneItem *zoneItem = (ClassZoneItem *)self.modelItem;
    for (PhotoItem *item in zoneItem.photos) {
        BOOL has = NO;
        for (PhotoItem *remainItem in resultArray) {
            if([remainItem.photoID isEqualToString:item.photoID])
                has = YES;
        }
        if(!has)
            [removedItems addObject:item];
    }
    [zoneItem.photos removeObjectsInArray:removedItems];
    [self onReloadData:self.modelItem];
}
@end

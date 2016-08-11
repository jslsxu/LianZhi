//
//  TreeHouseCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/21.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TreeHouseCell.h"
#import "CollectionImageCell.h"
#import "DestinationVC.h"
#define kInnerMargin                        8

NSString *const kTreeHouseItemDeleteNotification = @"TreeHouseItemDeleteNotification";
NSString *const kTreeHouseItemTagDeleteNotification = @"TreeHouseItemTagDeleteNotification";
NSString *const kTreeHouseItemTagSelectNotification = @"TreeHouseItemTagSelectNotification";
NSString *const kTreeHouseItemKey = @"TreeHouseItemKey";

@interface TreeHouseCell ()<PhotoBrowserDelegate>

@end
@implementation TreeHouseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_icon];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_dateLabel setTextAlignment:NSTextAlignmentRight];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setNumberOfLines:0];
        [_dateLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_dateLabel];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(72, 5, self.width - 72 - 12, 0)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:10];
        [self addSubview:_bgView];
        
        
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_authorLabel setBackgroundColor:[UIColor clearColor]];
        [_authorLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_authorLabel setFont:[UIFont systemFontOfSize:14]];
        [_bgView addSubview:_authorLabel];

        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_bgView addSubview:_timeLabel];
        
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressButton setBackgroundImage:[[UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.5] size:CGSizeMake(10, 10)] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateHighlighted];
        [_addressButton addTarget:self action:@selector(onPositionTap) forControlEvents:UIControlEventTouchUpInside];
        [_addressButton setTitleColor:[UIColor colorWithHexString:@"9a9a9a"] forState:UIControlStateNormal];
        [_addressButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_bgView addSubview:_addressButton];
        
        _trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_trashButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_trashButton setImage:[UIImage imageNamed:@"TimelineTrash"] forState:UIControlStateNormal];
        [_trashButton addTarget:self action:@selector(onTrashClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_trashButton];
        
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_tagLabel setBackgroundColor:[UIColor clearColor]];
        [_bgView addSubview:_tagLabel];
        
        _tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tagButton addTarget:self action:@selector(onTagButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_tagButton];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setFont:[UIFont systemFontOfSize:14]];
        [_infoLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_infoLabel setNumberOfLines:0];
        [_infoLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_bgView addSubview:_infoLabel];
        
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setSize:CGSizeMake(40, 25)];
        [_actionButton setImage:[UIImage imageNamed:@"TimelineAction"] forState:UIControlStateNormal];
        [_actionButton addTarget:self action:@selector(onActionClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_actionButton];
        
        NSInteger itemWidth = (_bgView.width - 10 * 2 - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (_bgView.width - 10 * 2 - itemWidth * 3) / 2;
        _layout = [[UICollectionViewFlowLayout alloc] init];
        [_layout setItemSize:CGSizeMake(itemWidth, itemWidth)];
        [_layout setMinimumInteritemSpacing:innerMargin];
        [_layout setMinimumLineSpacing:innerMargin];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, _bgView.width - 10 * 2, 0) collectionViewLayout:_layout];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_bgView addSubview:_collectionView];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(10, 0, _bgView.width - 10 * 2 - 60, 40)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_voiceButton];
        
        _spanLabel = [[UILabel alloc] initWithFrame:CGRectMake(_voiceButton.right, 0, 60, 40)];
        [_spanLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_spanLabel setFont:[UIFont systemFontOfSize:14]];
        [_spanLabel setTextAlignment:NSTextAlignmentCenter];
        [_bgView addSubview:_spanLabel];
    
        _responseView = [[ResponseView alloc] initWithFrame:CGRectMake(10, 0, _bgView.width - 10 * 2, 0)];
        [_responseView setDelegate:self];
        [_bgView addSubview:_responseView];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    TreehouseItem *item = (TreehouseItem *)modelItem;
    
    NSString *time = item.time;
    NSString *date = [time substringWithRange:NSMakeRange(8, 2)];
    NSString *month = [time substringWithRange:NSMakeRange(5, 2)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@月",date,month]];
    [attrStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17],NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, 3)];
    [attrStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor colorWithHexString:@"999999"]} range:NSMakeRange(3, 3)];
    [_dateLabel setAttributedText:attrStr];
    [_dateLabel sizeToFit];
    [_dateLabel setOrigin:CGPointMake(16, 8)];
    
    if([item.tag length] > 0)
    {
        [_icon setImage:[UIImage imageNamed:@"TimelineMedal.png"]];
        [_icon setFrame:CGRectMake(50 - 24 / 2.0, 12, 24, 30)];
    }
    else
    {
        [_icon setImage:[UIImage imageNamed:@"TimelinePoint.png"]];
        [_icon setFrame:CGRectMake(50 - 9 / 2.0, 12 + 11 - 4.5, 9, 9)];
    }
    
    if(item.newSend)
        [_authorLabel setText:@"我"];
    else
        [_authorLabel setText:item.user.title];
    [_authorLabel sizeToFit];
    [_authorLabel setOrigin:CGPointMake(10, 10)];
    
    [_timeLabel setText:item.timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_authorLabel.right + 5, _authorLabel.bottom - _timeLabel.height)];
    
    [_trashButton setFrame:CGRectMake(_bgView.width - 30 - 10, 5, 30, 30)];
    [_trashButton setHidden:!item.canEdit || item.newSend || item.isUploading];
    
    NSInteger spaceYStart ;
    if(item.position.length > 0)
    {
        _addressButton.hidden = NO;
        [_addressButton setTitle:item.position forState:UIControlStateNormal];
        CGSize positionSize = [item.position sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
        [_addressButton setFrame:CGRectMake(10, 27, positionSize.width, positionSize.height)];
        spaceYStart = 45;
    }
    else
    {
        _addressButton.hidden = YES;
        spaceYStart = 30;
    }

    NSInteger bgWidth = self.width - 12 - 72 - 20;
    CGSize detailSize = [item.detail boundingRectWithSize:CGSizeMake(bgWidth, 0) andFont:[UIFont systemFontOfSize:14]];

    [_infoLabel setText:item.detail];
    [_infoLabel setFrame:CGRectMake(10, spaceYStart, detailSize.width, detailSize.height)];
    
    spaceYStart += detailSize.height + 5;
    
    
    [_collectionView setHidden:YES];
    [_voiceButton setHidden:YES];
    [_spanLabel setHidden:YES];
    if(item.photos.count > 0)
    {
        NSInteger row = (item.photos.count + 2) / 3;
        NSInteger itemWidth = _layout.itemSize.width;
        NSInteger innerMargin = (bgWidth - itemWidth * 3) / 2;
        [_collectionView setHidden:NO];
        [_collectionView setFrame:CGRectMake(10, spaceYStart, bgWidth, itemWidth * row + innerMargin * (row - 1))];
        [_collectionView reloadData];
        
        spaceYStart += _collectionView.height;
    }
    else
    {
        if(item.audioItem)
        {
            [_voiceButton setHidden:NO];
            [_spanLabel setHidden:NO];
            [_voiceButton setAudioItem:item.audioItem];
            [_voiceButton setOrigin:CGPointMake(10, spaceYStart)];
            [_spanLabel setText:[Utility formatStringForTime:item.audioItem.timeSpan]];
            [_spanLabel setY:_voiceButton.y];
            spaceYStart += _voiceButton.height;
        }
        else
            [_voiceButton setHidden:YES];
    }
    
    if(item.tag.length > 0)
    {
        _tagLabel.hidden = NO;
        NSString *tagStr = [NSString stringWithFormat:@"标签:%@",item.tag];
        NSMutableAttributedString *attrTagStr = [[NSMutableAttributedString alloc] initWithString:tagStr];
        [attrTagStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, 3)];
        [attrTagStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14],NSUnderlineColorAttributeName:[UIColor colorWithHexString:@"00a274"],NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"00a274"]} range:NSMakeRange(3, item.tag.length)];
        [_tagLabel setAttributedText:attrTagStr];
        [_tagLabel sizeToFit];
        [_tagLabel setFrame:CGRectMake(10, spaceYStart, _tagLabel.width, 30)];
        
    }
    else if(item.canEdit && !item.newSend)
    {
        _tagLabel.hidden = NO;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"添加标签"];
        [str setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"00a274"], NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, str.length)];
        [_tagLabel setAttributedText:str];
        [_tagLabel sizeToFit];
        [_tagLabel setFrame:CGRectMake(10, spaceYStart, _tagLabel.width, 30)];
    }
    else
        _tagLabel.hidden = YES;
    
    [_tagButton setFrame:_tagLabel.frame];
    [_actionButton setOrigin:CGPointMake(_bgView.width - _actionButton.width, spaceYStart + (30 - _actionButton.height) / 2)];
    if(item.newSend || item.isUploading)
        [_actionButton setHidden:YES];
    else
        [_actionButton setHidden:NO];
    spaceYStart += 30;
    
    [_responseView setResponseModel:item.responseModel];
    [_responseView setY:spaceYStart];
    
    spaceYStart += _responseView.height + 10;
    [_bgView setHeight:spaceYStart];
}

- (void)onPositionTap
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    if(item.position.length > 0)
    {
        DestinationVC *destinationVC = [[DestinationVC alloc] init];
        [destinationVC setPosition:item.position];
        [destinationVC setLongitude:item.longitude];
        [destinationVC setLatitude:item.latitude];
        [CurrentROOTNavigationVC pushViewController:destinationVC animated:YES];
    }
}

- (void)onActionClicked
{
    if([self.delegate respondsToSelector:@selector(onActionClicked:)])
    {
        [self.delegate onActionClicked:self];
    }
}

- (void)onDetailClicked
{
    if([self.delegate respondsToSelector:@selector(onShowDetail:)])
        [self.delegate onShowDetail:(TreehouseItem *)self.modelItem];
}

#pragma mark - ResponseViewDelegate
- (void)onResponseItemClicked:(ResponseItem *)responseItem
{
    if([self.delegate respondsToSelector:@selector(onResponseClickedAtTarget: cell:)])
        [self.delegate onResponseClickedAtTarget:responseItem cell:self];
}

- (void)onVoiceButtonClicked
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:item.audioItem.audioUrl] withAutoPlay:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    return item.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    NSArray *photos = item.photos;
    [cell setItem:[photos objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    
    NSMutableArray *photos = [[NSMutableArray alloc] initWithArray:item.photos];
    for (PhotoItem *photoItem in photos) {
        [photoItem setTag:item.tag];
        [photoItem setTime_str:item.timeStr];
        [photoItem setUser:item.user];
        [photoItem setWords:item.detail];
    }
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    [photoBrowser setPhotos:photos];
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    [photoBrowser setDelegate:self];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}


- (void)onTrashClicked
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    if(item.canEdit)
        [[NSNotificationCenter defaultCenter] postNotificationName:kTreeHouseItemDeleteNotification object:nil userInfo:@{kTreeHouseItemKey : item}];
}

- (void)onTagButtonClicked
{
    TreehouseItem *item = (TreehouseItem *)self.modelItem;
    if(item.canEdit)
    {
        if(item.tag.length > 0)
        {
            //删除标间
            [[NSNotificationCenter defaultCenter] postNotificationName:kTreeHouseItemTagDeleteNotification object:nil userInfo:@{kTreeHouseItemKey : item}];
        }
        else if(!item.newSend)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kTreeHouseItemTagSelectNotification object:nil userInfo:@{kTreeHouseItemKey : item}];
        }
    }
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    TreehouseItem *item = (TreehouseItem *)modelItem;
    CGFloat bgWidth = width - 12 - 72 - 20;
    CGSize detailSize = [item.detail boundingRectWithSize:CGSizeMake(bgWidth, 0) andFont:[UIFont systemFontOfSize:14]];
    
    NSInteger authHeight = 45;
    if(item.position.length == 0)
        authHeight = 30;
    
    CGFloat extraHeight = 0;
    if(item.photos.count > 0)
    {
        NSInteger itemWidth = (bgWidth - kInnerMargin * 2) / 3;
        NSInteger row = (item.photos.count + 2) / 3;
        NSInteger innerMargin = (bgWidth - itemWidth * 3) / 2;
        extraHeight = (itemWidth * row + innerMargin * (row - 1));
    }
    else if(item.audioItem)
        extraHeight = 40;
    NSInteger resposeHeight = [ResponseView responseHeightForResponse:item.responseModel forWidth:bgWidth];
    return @(5 + authHeight + detailSize.height + 5 + 30 + extraHeight + resposeHeight + 10 + 10);
}

#pragma mark - PhotoBrowserDelegate
- (void)photoBrowserEditFinished:(NSArray *)resultArray
{
    NSMutableArray *removedItems = [NSMutableArray array];
    TreehouseItem *treeItem = (TreehouseItem *)self.modelItem;
    for (PhotoItem *item in treeItem.photos) {
        BOOL has = NO;
        for (PhotoItem *remainItem in resultArray) {
            if([remainItem.photoID isEqualToString:item.photoID])
                has = YES;
        }
        if(!has)
            [removedItems addObject:item];
    }
    [treeItem.photos removeObjectsInArray:removedItems];
    [self onReloadData:self.modelItem];
}
@end

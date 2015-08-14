//
//  TreeHouseCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/21.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TreeHouseCell.h"
#import "CollectionImageCell.h"

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
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_dateLabel setTextAlignment:NSTextAlignmentRight];
        [_dateLabel setBackgroundColor:[UIColor clearColor]];
        [_dateLabel setNumberOfLines:0];
        [_dateLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self addSubview:_dateLabel];
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_icon];
        
        _bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"WhiteBG.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
        [_bgImageView setUserInteractionEnabled:YES];
        [self addSubview:_bgImageView];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_infoLabel setBackgroundColor:[UIColor clearColor]];
        [_infoLabel setFont:[UIFont systemFontOfSize:16]];
        [_infoLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_infoLabel setNumberOfLines:0];
        [_infoLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_bgImageView addSubview:_infoLabel];
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        [_layout setItemSize:CGSizeMake(60, 60)];
        [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [_layout setMinimumInteritemSpacing:5];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_bgImageView addSubview:_collectionView];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(0, 0, 215, 40)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView addSubview:_voiceButton];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_sepLine setBackgroundColor:kSepLineColor];
        [_bgImageView addSubview:_sepLine];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_bgImageView addSubview:_timeLabel];
        
        
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_authorLabel setBackgroundColor:[UIColor clearColor]];
        [_authorLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_authorLabel setFont:[UIFont systemFontOfSize:13]];
        [_bgImageView addSubview:_authorLabel];
        
        _trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_trashButton setImage:[UIImage imageNamed:@"TimelineGrayTrash.png"] forState:UIControlStateNormal];
        [_trashButton addTarget:self action:@selector(onTrashClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView addSubview:_trashButton];
        
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_tagLabel setBackgroundColor:[UIColor clearColor]];
        [_bgImageView addSubview:_tagLabel];
        
        _tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tagButton addTarget:self action:@selector(onTagButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView addSubview:_tagButton];
        
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
        [_icon setFrame:CGRectMake(50 - 22 / 2.0, 12, 22, 22)];
    }
    else
    {
        [_icon setImage:[UIImage imageNamed:@"TimelinePoint.png"]];
        [_icon setFrame:CGRectMake(50 - 9 / 2.0, 12 + 11 - 4.5, 9, 9)];
    }
    
    CGFloat bgWidth = self.width - 12 - 72 - 40;
    CGSize detailSize = [item.detail boundingRectWithSize:CGSizeMake(bgWidth, 0) andFont:[UIFont systemFontOfSize:16]];

    [_infoLabel setText:item.detail];
    CGFloat spaceYStart = 12;
    [_infoLabel setFrame:CGRectMake(20, spaceYStart, detailSize.width, detailSize.height)];
    
    spaceYStart += detailSize.height + 5;
    
    [_collectionView setHidden:YES];
    [_voiceButton setHidden:YES];
    
    if(item.photos.count > 0)
    {
        [_collectionView setHidden:NO];
        [_collectionView setFrame:CGRectMake(20, spaceYStart, bgWidth, 60)];
        [_collectionView reloadData];
        
        spaceYStart += 60 + 5;
    }
    else
    {
        if(item.audioItem)
        {
            [_voiceButton setHidden:NO];
            [_voiceButton setAudioItem:item.audioItem];
            [_voiceButton setOrigin:CGPointMake(10, spaceYStart)];
            spaceYStart += _voiceButton.height + 5;
        }
        else
            [_voiceButton setHidden:YES];
    }
    spaceYStart += 5;
    
    [_sepLine setFrame:CGRectMake(0, spaceYStart, self.width - 12 - 72, 1)];
    spaceYStart += 1;
    
    [_bgImageView setFrame:CGRectMake(72, 5, self.width - 12 - 72, spaceYStart + 30)];
    
    if(item.tag.length > 0)
    {
        _tagLabel.hidden = NO;
        NSString *tagStr = [NSString stringWithFormat:@"标签:%@",item.tag];
        NSMutableAttributedString *attrTagStr = [[NSMutableAttributedString alloc] initWithString:tagStr];
        [attrTagStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithHexString:@"999999"]} range:NSMakeRange(0, 3)];
        [attrTagStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14],NSUnderlineColorAttributeName:[UIColor colorWithHexString:@"00a274"],NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSForegroundColorAttributeName: [UIColor colorWithHexString:@"00a274"]} range:NSMakeRange(3, item.tag.length)];
        [_tagLabel setAttributedText:attrTagStr];
        [_tagLabel sizeToFit];
        [_tagLabel setOrigin:CGPointMake(_bgImageView.width - _tagLabel.width - 10, _sepLine.bottom + (30 - _tagLabel.height) / 2)];

    }
    else if(item.canEdit && !item.newSend)
    {
        _tagLabel.hidden = NO;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"添加标签"];
        [str setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"00a274"], NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0, str.length)];
        [_tagLabel setAttributedText:str];
        [_tagLabel sizeToFit];
        [_tagLabel setOrigin:CGPointMake(_bgImageView.width - _tagLabel.width - 10, _sepLine.bottom + (30 - _tagLabel.height) / 2)];
    }
    else
        _tagLabel.hidden = YES;


    [_timeLabel setText:item.timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(15, _sepLine.bottom + (30 - _timeLabel.height) / 2)];
    
    if(item.newSend)
        [_authorLabel setText:@"我"];
    else
        [_authorLabel setText:item.user.title];
    [_authorLabel sizeToFit];
    [_authorLabel setOrigin:CGPointMake(_timeLabel.right + 5, _sepLine.bottom + (30 - _authorLabel.height) / 2)];

    [_trashButton setFrame:CGRectMake(_authorLabel.right, _sepLine.bottom, 30, 30)];
    [_trashButton setHidden:!item.canEdit];
    
    [_tagButton setFrame:CGRectMake(_trashButton.right, _sepLine.bottom, _bgImageView.width - _trashButton.right, _bgImageView.height - _sepLine.bottom)];
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
        [photoItem setFormatTimeStr:item.timeStr];
        [photoItem setUserInfo:item.user];
        [photoItem setComment:item.detail];
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
    CGFloat bgWidth = width - 12 - 72 - 40;
    CGSize detailSize = [item.detail boundingRectWithSize:CGSizeMake(bgWidth, 0) andFont:[UIFont systemFontOfSize:16]];
    CGFloat extraHeight = 0;
    if(item.photos.count > 0)
        extraHeight = 60 + 5;
    else if(item.audioItem)
        extraHeight = 40 + 5;
    return @(detailSize.height + 12 * 2 + 5 + 1 + 30 + 5 + extraHeight);
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

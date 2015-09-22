//
//  MessageDetailItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageDetailItemCell.h"

NSString *const  kMessageDeleteNotitication = @"MessageDeleteNotitication";
NSString *const  kMessageDeleteModelItemKey = @"MessageDeleteModelItemKey";
#define kContentFont            [UIFont systemFontOfSize:14]

#define kBGTopMargin            20
#define kBGBottomMargin         10
#define kOperationHeight        32
#define kBGViewHMargin          10
#define kContentHMargin         10

@implementation MessageDetailItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(kBGViewHMargin, kBGTopMargin, self.width - kBGViewHMargin * 2, 0)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:15];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(20, 5, 45, 45)];
        [_logoView setBorderColor:[UIColor whiteColor]];
        [_logoView setBorderWidth:2];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_logoView.right + 10, 0, 100, kOperationHeight)];
        [_nameLabel setFont:[UIFont systemFontOfSize:13]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_bgView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:14]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_bgView addSubview:_timeLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, kOperationHeight, _bgView.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [_bgView addSubview:_sepLine];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentHMargin, kOperationHeight + kContentHMargin, _bgView.width - kContentHMargin * 2, 0)];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:kContentFont];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_bgView addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(10, 0, _bgView.width - 10 * 2, 45)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_voiceButton];
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setItemSize:CGSizeMake(60, 60)];
        [flowLayout setMinimumInteritemSpacing:5];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, _sepLine.bottom + 10, _bgView.width - 10 * 2, 60) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_bgView addSubview:_collectionView];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    MessageDetailItem *item = (MessageDetailItem *)modelItem;
    [_nameLabel setText:item.author];
    CGFloat height = kContentHMargin + kOperationHeight;
    [_voiceButton setHidden:YES];
    [_collectionView setHidden:YES];
    NSString *content = item.content;
    if(content.length == 0 && item.audioItem)
    {
        content = @"这是一条语音内容，点击播放:";
    }
    if(content.length > 0)
    {
        [_contentLabel setHidden:NO];
        [_contentLabel setText:content];
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(_contentLabel.width, CGFLOAT_MAX) andFont:_contentLabel.font];
        [_contentLabel setHeight:contentSize.height];
        height += contentSize.height + kContentHMargin;
    }
    else
        [_contentLabel setHidden:YES];
    
    if(item.audioItem)
    {
        [_voiceButton setHidden:NO];
        [_voiceButton setAudioItem:item.audioItem];
        [_voiceButton setOrigin:CGPointMake(kContentHMargin, height)];
        height += _voiceButton.height + kContentHMargin;
    }
    else if(item.pictureArray)//图片
    {
        [_collectionView setHidden:NO];
        [_collectionView reloadData];
        height += _collectionView.height + kContentHMargin;
    }
    [_bgView setHeight:height];
    [_timeLabel setText:item.timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setFrame:CGRectMake(_bgView.width - kContentHMargin - _timeLabel.width, (kOperationHeight - _timeLabel.height) / 2, _timeLabel.width, _timeLabel.height)];
    
}

- (void)onVoiceButtonClicked
{
    MessageDetailItem *item = (MessageDetailItem *)self.modelItem;
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:item.audioItem.audioUrl] withAutoPlay:YES];
}

- (void)onMessageDeleteButtonClicked
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageDeleteNotitication object:nil userInfo:@{kMessageDeleteModelItemKey : self.modelItem}];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    NSInteger height = kBGTopMargin + kOperationHeight + kContentHMargin;
    MessageDetailItem *item = (MessageDetailItem *)modelItem;
    NSString *content = item.content;
    if(content.length == 0 && item.audioItem)
    {
        content = @"这是一条语音内容，点击播放:";
    }
    if(content.length > 0)
    {
        CGSize contentSize = [content boundingRectWithSize:CGSizeMake(width - kContentHMargin * 4, CGFLOAT_MAX) andFont:kContentFont];
        height += contentSize.height + kContentHMargin;
    }
    if(item.audioItem)
    {
        height += 45 + kContentHMargin;
    }
    else if(item.pictureArray)
    {
        height += 60 + kContentHMargin;
    }
    
    height += kBGBottomMargin;
    
    return @(height);
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MessageDetailItem *item = (MessageDetailItem *)self.modelItem;
    return item.pictureArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailItem *item = (MessageDetailItem *)self.modelItem;
    PhotoItem *photoItem = item.pictureArray[indexPath.row];
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    [cell setItem:photoItem];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailItem *item = (MessageDetailItem *)self.modelItem;
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    [photoBrowser setPhotos:[NSMutableArray arrayWithArray:item.pictureArray]];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}

@end

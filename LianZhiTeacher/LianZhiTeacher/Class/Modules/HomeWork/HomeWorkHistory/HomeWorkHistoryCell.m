//
//  HomeWorkHistoryCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkHistoryCell.h"
#import "CollectionImageCell.h"
@implementation HomeWorkHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
        [_dateLabel setTextColor:[UIColor colorWithHexString:@"9f9f9f"]];
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_dateLabel];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, _dateLabel.bottom, self.width - 10 * 2, 0)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:5];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _courseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_courseLabel setFont:[UIFont systemFontOfSize:12]];
        [_courseLabel setTextColor:[UIColor colorWithHexString:@"969696"]];
        [_bgView addSubview:_courseLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"969696"]];
        [_bgView addSubview:_timeLabel];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 28, _bgView.width, 0.5)];
        [_sepLine setBackgroundColor:[UIColor colorWithHexString:@"ebebeb"]];
        [_bgView addSubview:_sepLine];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_bgView addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(50, 0, self.width - 10 - 50 - 60, 45)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_voiceButton];
        
        _spanLabel = [[UILabel alloc] initWithFrame:CGRectMake(_voiceButton.right, _voiceButton.y, 60, _voiceButton.height)];
        [_spanLabel setTextAlignment:NSTextAlignmentCenter];
        [_spanLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_spanLabel setFont:[UIFont systemFontOfSize:14]];
        [_bgView addSubview:_spanLabel];
        
        NSInteger collectionWidth = _bgView.width - 15 * 2;
        NSInteger innerMargin = 3;
        NSInteger itemWidth = (collectionWidth - innerMargin * 2) / 3;
        innerMargin = (collectionWidth - itemWidth * 3) / 2;
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
        [_bgView addSubview:_collectionView];
        
        _likeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_likeImageView setImage:[UIImage imageNamed:@"HomeworkCollectionOn"]];
        [_likeImageView setUserInteractionEnabled:YES];
        [_bgView addSubview:_likeImageView];

        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton addTarget:self action:@selector(onMoreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setImage:[UIImage imageNamed:@"HomeWorkItemMore"] forState:UIControlStateNormal];
        [_bgView addSubview:_moreButton];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    HomeWorkHistoryItem *historyItem = (HomeWorkHistoryItem *)modelItem;
    [_dateLabel setText:@"星期一"];
    [_courseLabel setText:@"英语"];
    [_timeLabel setText:@"12月10日17：30"];
    CGFloat spaceYStart = 30;
    [_contentLabel setWidth:_bgView.width - 10 * 2];
    [_contentLabel setText:@"英语课后习题作业，第六章第二节we are family 第三段语文背诵及抄写"];
    [_contentLabel sizeToFit];
    [_contentLabel setY:30 + 18];

    if(historyItem.words.length > 0)
        spaceYStart = _contentLabel.bottom;
    else
        spaceYStart = 30;
    spaceYStart += 15;
    [_voiceButton setHidden:YES];
    [_collectionView setHidden:YES];
    [_spanLabel setHidden:YES];
    if(historyItem.audioItem)
    {
        [_voiceButton setHidden:NO];
        [_voiceButton setY:spaceYStart];
        [_spanLabel setHidden:NO];
        [_spanLabel setText:[Utility formatStringForTime:historyItem.audioItem.timeSpan]];
        spaceYStart += _voiceButton.bottom;
    }
    else if(historyItem.photoArray.count > 0)
    {
        NSInteger imageCount = historyItem.photoArray.count;
        _collectionView.width = _bgView.width - 15 * 2;
        NSInteger contentWidth = _collectionView.width;
        NSInteger innerMargin = 3;
        NSInteger row = (historyItem.photoArray.count + 2) / 3;
        NSInteger itemWidth = (contentWidth - innerMargin * 2) / 3;
        innerMargin = (contentWidth - itemWidth * 3) / 2;
        [_collectionView setHidden:NO];
        NSInteger imageWidth = (row > 1) ? contentWidth : (itemWidth * imageCount + innerMargin * (historyItem.photoArray.count - 1));
        [_collectionView setFrame:CGRectMake(15, spaceYStart, imageWidth, itemWidth * row + innerMargin * (row - 1))];
        [_collectionView reloadData];
        spaceYStart = _collectionView.bottom;
    }
    
    [_likeImageView setY:spaceYStart + 20];
    spaceYStart = _likeImageView.bottom;
    [_bgView setHeight:spaceYStart + 10];
}

- (void)onMoreButtonClicked
{
    
}

- (void)onCollectionClicked
{
    
}

- (void)onVoiceButtonClicked
{
    HomeWorkHistoryItem *item = (HomeWorkHistoryItem *)self.modelItem;
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:item.audioItem.audioUrl] withAutoPlay:YES];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    return @(100);
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    HomeWorkHistoryItem *item = (HomeWorkHistoryItem *)self.modelItem;
    PhotoItem *photoItem = item.photoArray[indexPath.row];
    [cell setItem:photoItem];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeWorkHistoryItem *item = (HomeWorkHistoryItem *)self.modelItem;
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray arrayWithArray:item.photoArray];
    for (PhotoItem *photoItem in photos) {
//        [photoItem setUserInfo:];
        [photoItem setComment:item.words];
        [photoItem setFormatTimeStr:item.ctime];
    }
    [photoBrowser setPhotos:photos];
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}

@end

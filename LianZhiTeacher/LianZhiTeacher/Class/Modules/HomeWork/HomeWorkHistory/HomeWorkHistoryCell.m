//
//  HomeWorkHistoryCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkHistoryCell.h"
#import "CollectionImageCell.h"
NSString *const kAddFavNotification = @"kAddFavNotification";
NSString *const kPractiseItemKey = @"kPractiseItemKey";
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
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(0, 0, _bgView.width - 150, 45)];
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
        
        _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeButton setSize:CGSizeMake(25, 20)];
        [_likeButton addTarget:self action:@selector(onCollectionClicked) forControlEvents:UIControlEventTouchUpInside];
        [_likeButton setImage:[UIImage imageNamed:@"HomeworkCollectionOn"] forState:UIControlStateNormal];
        [_bgView addSubview:_likeButton];

        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton addTarget:self action:@selector(onMoreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setImage:[UIImage imageNamed:@"HomeWorkItemMore"] forState:UIControlStateNormal];
        [_bgView addSubview:_moreButton];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    HomeWorkItem *historyItem = (HomeWorkItem *)modelItem;
    [_dateLabel setText:historyItem.weekday];
    [_courseLabel setText:historyItem.courseName];
    [_courseLabel sizeToFit];
    [_courseLabel setOrigin:CGPointMake(10, (30 - _courseLabel.height) / 2)];
    [_timeLabel setText:historyItem.timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_bgView.width - _timeLabel.width - 10, (30 - _timeLabel.height) / 2)];
    CGFloat spaceYStart = 28;
    [_contentLabel setHidden:historyItem.words.length == 0];
    [_contentLabel setWidth:_bgView.width - 15 * 2];
    [_contentLabel setText:historyItem.words];
    [_contentLabel sizeToFit];
    [_contentLabel setOrigin:CGPointMake(10, spaceYStart + 10)];

    if(historyItem.words.length > 0)
        spaceYStart = _contentLabel.bottom;
    [_voiceButton setHidden:YES];
    [_collectionView setHidden:YES];
    [_spanLabel setHidden:YES];
    if(historyItem.audioItem)
    {
        spaceYStart += 10;
        [_voiceButton setHidden:NO];
        [_voiceButton setOrigin:CGPointMake(15, spaceYStart)];
        [_spanLabel setHidden:NO];
        [_spanLabel setFrame:CGRectMake(_voiceButton.right + 10, _voiceButton.y, 50, _voiceButton.height)];
        [_spanLabel setText:[Utility formatStringForTime:historyItem.audioItem.timeSpan]];
        spaceYStart += _voiceButton.height;
    }
    else if(historyItem.photoArray.count > 0)
    {
        spaceYStart += 10;
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
        spaceYStart += _collectionView.height;
    }
    
    [_likeButton setOrigin:CGPointMake(10, spaceYStart + 10)];
    [_likeButton setImage:[UIImage imageNamed:historyItem.fav ? @"HomeworkCollectionOn" :@"HomeworkCollectionOff"] forState:UIControlStateNormal];
     [_likeButton setImage:[UIImage imageNamed:historyItem.fav ? @"HomeworkCollectionOn" :@"HomeworkCollectionOff"] forState:UIControlStateHighlighted];
    spaceYStart = _likeButton.bottom;
    [_bgView setHeight:spaceYStart + 10];
}

- (void)onMoreButtonClicked
{
    
}

- (void)onCollectionClicked
{
    HomeWorkItem *item = (HomeWorkItem *)self.modelItem;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:item.homeworkId forKey:@"practice_id"];
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"practice/set_fav" method:REQUEST_GET type:REQUEST_REFRESH withParams:params observer:nil completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        item.fav = !item.fav;
        [[NSNotificationCenter defaultCenter] postNotificationName:kAddFavNotification object:nil userInfo:@{kPractiseItemKey : item}];
    } fail:^(NSString *errMsg) {
        
    }];
}

- (void)onVoiceButtonClicked
{
    HomeWorkItem *item = (HomeWorkItem *)self.modelItem;
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:item.audioItem.audioUrl] withAutoPlay:YES];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    HomeWorkItem *item = (HomeWorkItem *)modelItem;
    NSInteger height = 30;
    CGFloat spaceYStart = 28;
    NSInteger bgWidth = width - 10 * 2;
    if(item.words.length > 0)
    {
        CGSize wordsSize = [item.words boundingRectWithSize:CGSizeMake(bgWidth - 15 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        spaceYStart += 10 + wordsSize.height;
    }
    if(item.audioItem)
    {
        spaceYStart += 10 + 45;
    }
    else if(item.photoArray.count > 0)
    {
        NSInteger imageCount = item.photoArray.count;
        NSInteger contentWidth = bgWidth - 15 * 2;
        NSInteger innerMargin = 3;
        NSInteger row = (imageCount + 2) / 3;
        NSInteger itemWidth = (contentWidth - innerMargin * 2) / 3;
        innerMargin = (contentWidth - itemWidth * 3) / 2;
        NSInteger collectionHeight = itemWidth * row + innerMargin * (row - 1);
        spaceYStart += 10 + collectionHeight;
    }
    spaceYStart += 10 + 30 + 10;
    height += spaceYStart;
    return @(height);
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    HomeWorkItem *item = (HomeWorkItem *)self.modelItem;
    return item.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    HomeWorkItem *item = (HomeWorkItem *)self.modelItem;
    PhotoItem *photoItem = item.photoArray[indexPath.row];
    [cell setItem:photoItem];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeWorkItem *item = (HomeWorkItem *)self.modelItem;
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray arrayWithArray:item.photoArray];
    for (PhotoItem *photoItem in photos) {
//        [photoItem setUserInfo:];
        [photoItem setComment:item.words];
        [photoItem setFormatTimeStr:item.timeStr];
    }
    [photoBrowser setPhotos:photos];
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}

@end

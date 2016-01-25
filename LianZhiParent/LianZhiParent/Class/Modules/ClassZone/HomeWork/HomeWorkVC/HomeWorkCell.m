//
//  HomeWorkCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkCell.h"
#import "HomeWorkListModel.h"
#import "CollectionImageCell.h"
@implementation HomeWorkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 45, 30)];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:13]];
        [self addSubview:_dateLabel];
        
        _courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 18, 30, 30)];
        [_courseLabel setTextAlignment:NSTextAlignmentCenter];
        [_courseLabel.layer setCornerRadius:15];
        [_courseLabel.layer setMasksToBounds:YES];
        [_courseLabel setFont:[UIFont systemFontOfSize:13]];
        [_courseLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_courseLabel];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(85, 18, kScreenWidth - 10 - 85, 0)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:5];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_bgView addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(0, 0, _bgView.width - 150, 45)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_voiceButton];
        
        _timespanLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timespanLabel setFont:[UIFont systemFontOfSize:12]];
        [_timespanLabel setTextColor:[UIColor colorWithHexString:@"7a7a7a"]];
        [_bgView addSubview:_timespanLabel];
        
        NSInteger collectionWidth = _bgView.width - 10 * 2;
        NSInteger innerMargin = 3;
        NSInteger itemWidth = (collectionWidth - innerMargin * 2) / 3;
        innerMargin = (collectionWidth - itemWidth * 3) / 2;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setItemSize:CGSizeMake(itemWidth, itemWidth)];
        [layout setMinimumInteritemSpacing:innerMargin];
        [layout setMinimumLineSpacing:innerMargin];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, _bgView.width - 10 * 2, 0) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
        [_collectionView registerClass:[CollectionImageCell class] forCellWithReuseIdentifier:@"CollectionImageCell"];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        
        [_bgView addSubview:_collectionView];
        
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, kLineHeight)];
        [_bottomLine setBackgroundColor:kSepLineColor];
        [_bgView addSubview:_bottomLine];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"7a7a7a"]];
        [_bgView addSubview:_timeLabel];
        
        _fromLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_fromLabel setFont:[UIFont systemFontOfSize:14]];
        [_fromLabel setTextColor:[UIColor colorWithHexString:@"7a7a7a"]];
        [_bgView addSubview:_fromLabel];

    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    HomeWorkItem *homeWorkItem = (HomeWorkItem *)modelItem;
    NSInteger spaceYStart = 15;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:homeWorkItem.ctime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [formatter stringFromDate:date];
    BOOL isToday = [date isToday];
    [_courseLabel setBackgroundColor:isToday ? [UIColor colorWithHexString:@"02ca94"] : [UIColor colorWithHexString:@"7a7a7a"]];
    [_dateLabel setTextColor:isToday ? [UIColor colorWithHexString:@"02ca94"] : [UIColor colorWithHexString:@"7a7a7a"]];
    [_dateLabel setText:isToday ? @"今天" : dateStr];
    
    [_dateLabel setText:dateStr];
    
    [_courseLabel setText:homeWorkItem.courseName];
    [_contentLabel setHidden:YES];
    [_voiceButton setHidden:YES];
    [_timespanLabel setHidden:YES];
    [_collectionView setHidden:YES];
    if(homeWorkItem.words.length > 0)
    {
        [_contentLabel setHidden:NO];
        [_contentLabel setFrame:CGRectMake(10, spaceYStart, _bgView.width - 10 * 2, 0)];
        [_contentLabel setText:homeWorkItem.words];
        [_contentLabel sizeToFit];
        spaceYStart += _contentLabel.height + 15;
    }
    
    if(homeWorkItem.audioItem)
    {
        [_voiceButton setHidden:NO];
        [_timespanLabel setHidden:NO];
        [_voiceButton setFrame:CGRectMake(10, spaceYStart, _bgView.width - 10 * 2 - 60, 45)];
        [_timespanLabel setFrame:CGRectMake(_voiceButton.right + 10, _voiceButton.y, 50, 45)];
        [_timespanLabel setText:[Utility formatStringForTime:homeWorkItem.audioItem.timeSpan]];
        spaceYStart += 15 + 45;
    }
    else if (homeWorkItem.photoArray.count > 0)
    {
        [_collectionView setHidden:NO];
        NSInteger imageCount = homeWorkItem.photoArray.count;
        _collectionView.width = _bgView.width - 10 * 2;
        NSInteger contentWidth = _collectionView.width;
        NSInteger innerMargin = 3;
        NSInteger row = (homeWorkItem.photoArray.count + 2) / 3;
        NSInteger itemWidth = (contentWidth - innerMargin * 2) / 3;
        innerMargin = (contentWidth - itemWidth * 3) / 2;
        [_collectionView setHidden:NO];
        NSInteger imageWidth = (row > 1) ? contentWidth : (itemWidth * imageCount + innerMargin * (homeWorkItem.photoArray.count - 1));
        [_collectionView setFrame:CGRectMake(10, spaceYStart, imageWidth, itemWidth * row + innerMargin * (row - 1))];
        [_collectionView reloadData];
        spaceYStart += _collectionView.height + 15;
    }
    [_bottomLine setFrame:CGRectMake(0, spaceYStart, _bgView.width, kLineHeight)];
    
    [_fromLabel setFrame:CGRectMake(10, spaceYStart, _bgView.width / 2 - 10, 30)];
    [_fromLabel setText:[NSString stringWithFormat:@"来自%@老师",homeWorkItem.teacherName]];
    [_timeLabel setFrame:CGRectMake(_bgView.width / 2, spaceYStart, _bgView.width / 2 - 10, 30)];
    [_timeLabel setText:timeStr];
    [_bgView setFrame:CGRectMake(85, 18, kScreenWidth - 10 - 85, spaceYStart + 30)];
}

- (void)onVoiceButtonClicked
{
    HomeWorkItem *item = (HomeWorkItem *)self.modelItem;
    [_voiceButton setVoiceWithURL:[NSURL URLWithString:item.audioItem.audioUrl] withAutoPlay:YES];
}

#pragma mark - 
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

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    HomeWorkItem *homeWorkItem = (HomeWorkItem *)modelItem;
    NSInteger bgViewWidth = width - 85 - 10;
    NSInteger spaceYStart = 15;
    if(homeWorkItem.words.length > 0)
    {
        CGSize contentSize = [homeWorkItem.words boundingRectWithSize:CGSizeMake(bgViewWidth - 10 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:14]];
        spaceYStart += 15 + contentSize.height;
    }
    
    if(homeWorkItem.audioItem)
        spaceYStart += 15 + 45;
    else if(homeWorkItem.photoArray.count > 0)
    {
        NSInteger imageCount = homeWorkItem.photoArray.count;
        NSInteger contentWidth = bgViewWidth - 10 * 2;
        NSInteger innerMargin = 3;
        NSInteger row = (imageCount + 2) / 3;
        NSInteger itemWidth = (contentWidth - innerMargin * 2) / 3;
        innerMargin = (contentWidth - itemWidth * 3) / 2;
        spaceYStart += itemWidth * row + innerMargin * (row - 1) + 15;

    }
    spaceYStart += 30;
    return @(spaceYStart + 18);
}
@end

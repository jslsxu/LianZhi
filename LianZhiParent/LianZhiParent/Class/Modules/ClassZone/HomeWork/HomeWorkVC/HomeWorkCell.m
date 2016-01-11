//
//  HomeWorkCell.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "HomeWorkCell.h"
#import "HomeWorkListModel.h"
@implementation HomeWorkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _photoViewArray = [NSMutableArray array];
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_dateLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_dateLabel];
        
        _courseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_courseLabel setFont:[UIFont systemFontOfSize:14]];
        [_courseLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_courseLabel];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(85, 0, kScreenWidth - 10 - 85, 0)];
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
        
        _voiceButton = [MessageVoiceButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_voiceButton];
        
        _timespanLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timespanLabel setFont:[UIFont systemFontOfSize:12]];
        [_timespanLabel setTextColor:[UIColor colorWithHexString:@"7a7a7a"]];
        [_bgView addSubview:_timespanLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, _bgView.width - 10 * 2, 0) collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        
        [_bgView addSubview:_collectionView];
        
        
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, kLineHeight)];
        [_bottomLine setBackgroundColor:kSepLineColor];
        [_bgView addSubview:_bottomLine];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
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
//    HomeWorkItem *homeWorkItem = (HomeWorkItem *)modelItem;
//    NSInteger height = 15;
//    if(homeWorkItem.content.length > 0)
//    {
//        [_contentLabel setHidden:NO];
//        CGSize contentSize = [homeWorkItem.content boundingRectWithSize:CGSizeMake(self.width - 16 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
//        [_contentLabel setText:homeWorkItem.content];
//        [_contentLabel setFrame:CGRectMake(16, 15, contentSize.width, contentSize.height)];
//        height += contentSize.height + 10;
//    }
//    else
//    {
//        [_contentLabel setHidden:YES];
//    }
//    [_photoView setHidden:YES];
//    [_voiceButton setHidden:YES];
//    [_timeLabel setHidden:YES];
//    if(homeWorkItem.photoItem)
//    {
//        [_photoView setHidden:NO];
//        [_photoView setFrame:CGRectMake(16, height, self.width - 16 * 2, 100)];
//        [_photoView sd_setImageWithURL:[NSURL URLWithString:homeWorkItem.photoItem.originalUrl] placeholderImage:nil];
//        height += 100 + 10;
//    }
//    else if(homeWorkItem.audioItem)
//    {
//        [_voiceButton setHidden:NO];
//        [_timeLabel setHidden:NO];
//        [_voiceButton setFrame:CGRectMake(16, height, 200, 34)];
//        height += 34 + 10;
//    }
//    height += 5;
//    [_bottomLine setFrame:CGRectMake(0, height - kLineHeight, self.width, kLineHeight)];
//    
}

- (void)onVoiceButtonClicked
{
    
}


+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    HomeWorkItem *homeWorkItem = (HomeWorkItem *)modelItem;
    NSInteger height = 15;
    if(homeWorkItem.content.length > 0)
    {
        CGSize contentSize = [homeWorkItem.content boundingRectWithSize:CGSizeMake(width - 16 * 2, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
        height += contentSize.height + 10;
    }
    
    if(homeWorkItem.photoItem)
        height += 100 + 10;
    else if(homeWorkItem.audioItem)
        height += 34 + 10;
    height += 5;
    return @(height);
}
@end

//
//  MessageDetailItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageDetailItemCell.h"
#import "CollectionImageCell.h"
 NSString *const  kMessageDeleteNotitication = @"MessageDeleteNotitication";
 NSString *const  kMessageDeleteModelItemKey = @"MessageDeleteModelItemKey";
#define kContentFont            [UIFont systemFontOfSize:14]

#define kBGTopMargin            20
#define kBGBottomMargin         20
#define kOperationHeight        32
#define kBGViewHMargin          10
#define kContentHMargin         10
#define kInnerMargin            8
#define kVoiceButtonHeight      40

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
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress)];
        [longGesture setMinimumPressDuration:1];
        [_bgView addGestureRecognizer:longGesture];
        
        _logoView = [[LogoView alloc] initWithFrame:CGRectMake(20, 5, 45, 45)];
        [_logoView setBorderColor:[UIColor whiteColor]];
        [_logoView setBorderWidth:2];
        [self addSubview:_logoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 100, kOperationHeight)];
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
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentHMargin, kOperationHeight + 10, _bgView.width - kContentHMargin * 2, 0)];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:kContentFont];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_bgView addSubview:_contentLabel];
        
        _voiceButton = [[MessageVoiceButton alloc] initWithFrame:CGRectMake(10, 0, _bgView.width - 10 * 2 - 60, kVoiceButtonHeight)];
        [_voiceButton addTarget:self action:@selector(onVoiceButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_voiceButton];
        
        _voiceSpanLabel = [[UILabel alloc] initWithFrame:CGRectMake(_voiceButton.right, _voiceButton.y, 60, _voiceButton.height)];
        [_voiceSpanLabel setTextAlignment:NSTextAlignmentCenter];
        [_voiceSpanLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_voiceSpanLabel setFont:[UIFont systemFontOfSize:14]];
        [_bgView addSubview:_voiceSpanLabel];
        
        NSInteger collectionWidth = _bgView.width - 10 * 2;
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
        [_bgView addSubview:_collectionView];
    }
    return self;
}

- (void)onLongPress
{
    MessageDetailItem *messageItem = (MessageDetailItem *)self.modelItem;
    if(messageItem.content.length > 0)
    {
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:_contentLabel.frame inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(copy:));
}

-(void)copy:(id)sender
{
    MessageDetailItem *messageItem = (MessageDetailItem *)self.modelItem;
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = messageItem.content;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    MessageDetailItem *item = (MessageDetailItem *)modelItem;
    [_nameLabel setText:item.author];
    [_logoView setImageWithUrl:[NSURL URLWithString:item.avatarUrl]];
    [_timeLabel setText:item.timeStr];
    [_timeLabel sizeToFit];
    [_timeLabel setFrame:CGRectMake(_bgView.width - kContentHMargin - _timeLabel.width, (kOperationHeight - _timeLabel.height) / 2, _timeLabel.width, _timeLabel.height)];
    CGFloat height = kOperationHeight + 10;
    NSString *content = item.content;
    if(item.audioItem)
        content = @"这是一条语音内容，点击播放:";
    if(item.content.length > 0)
    {
        [_contentLabel setHidden:NO];
        [_contentLabel setText:item.content];
        CGSize contentSize = [item.content boundingRectWithSize:CGSizeMake(_contentLabel.width, CGFLOAT_MAX) andFont:_contentLabel.font];
        [_contentLabel setHeight:contentSize.height];
        height += contentSize.height + 10;
    }
    else
        [_contentLabel setHidden:YES];
    [_collectionView setHidden:YES];
    [_voiceButton setHidden:YES];
    [_voiceSpanLabel setHidden:YES];
    if(item.photos.count > 0)
    {
        [_collectionView setHidden:NO];
        NSInteger imageCount = item.photos.count;
        NSInteger contentWidth = _bgView.width - 10 * 2;
        NSInteger row = (item.photos.count + 2) / 3;
        NSInteger itemWidth = (contentWidth - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (contentWidth - itemWidth * 3) / 2;
        NSInteger imageWidth = (row > 1) ? contentWidth : (itemWidth * imageCount + innerMargin * (imageCount - 1));
        [_collectionView setFrame:CGRectMake(10, height, imageWidth, itemWidth * row + innerMargin * (row - 1))];
        [_collectionView reloadData];
        height += _collectionView.height + 10;
    }
    else if(item.audioItem)
    {
        [_voiceButton setHidden:NO];
        [_voiceSpanLabel setHidden:NO];
        [_voiceButton setAudioItem:item.audioItem];
        [_voiceButton setOrigin:CGPointMake(kContentHMargin, height)];
        [_voiceSpanLabel setText:[Utility formatStringForTime:item.audioItem.timeSpan]];
        [_voiceSpanLabel setY:_voiceButton.y];
        height += kVoiceButtonHeight + kContentHMargin;
    }
    else
    {
        height += kContentHMargin;
    }
    [_bgView setHeight:height];
    height += kBGBottomMargin + kBGTopMargin;
    
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

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MessageDetailItem *messageItem = (MessageDetailItem *)self.modelItem;
    return messageItem.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailItem *messageItem = (MessageDetailItem *)self.modelItem;
    CollectionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionImageCell" forIndexPath:indexPath];
    [cell setItem:messageItem.photos[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageDetailItem *item = (MessageDetailItem *)self.modelItem;
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    [photoBrowser setCurrentPhotoIndex:indexPath.row];
    [photoBrowser setPhotos:[NSMutableArray arrayWithArray:item.photos]];
    [CurrentROOTNavigationVC pushViewController:photoBrowser animated:YES];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    MessageDetailItem *item = (MessageDetailItem *)modelItem;
    NSInteger height = kBGTopMargin + kBGBottomMargin + kOperationHeight + 10;
    NSString *content = item.content;
    if(item.audioItem)
        content = @"这是一条语音内容，点击播放:";
    if(item.content.length > 0)
    {
        CGSize contentSize = [item.content boundingRectWithSize:CGSizeMake(width - kBGViewHMargin * 4, CGFLOAT_MAX) andFont:kContentFont];
        height += contentSize.height + 10;
    }
    
    if(item.photos.count > 0)
    {
        NSInteger imageCount = item.photos.count;
        NSInteger contentWidth = width - kBGViewHMargin * 4;
        NSInteger row = (imageCount + 2) / 3;
        NSInteger itemWidth = (contentWidth - kInnerMargin * 2) / 3;
        NSInteger innerMargin = (contentWidth - itemWidth * 3) / 2;
        height += itemWidth * row + innerMargin * (row - 1) + 10;
    }
    else if(item.audioItem)
    {
        height += kVoiceButtonHeight + 10;
    }
    else
    {
        height += 10;
    }
    return @(height);
}
@end

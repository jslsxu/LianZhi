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

@implementation HomeworkExtraInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIView* topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLineHeight)];
        [topLine setBackgroundColor:kSepLineColor];
        [self addSubview:topLine];
        
        _courseLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_courseLabel setTextColor:kCommonParentTintColor];
        [_courseLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_courseLabel];
        
        _imageTypeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_hasPhoto"]];
        [self addSubview:_imageTypeView];
        
        _voiceTypeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_hasAudio"]];
        [self addSubview:_voiceTypeView];
        
        _videoTypeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_hasVideo"]];
        [self addSubview:_videoTypeView];
        
        _redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        [_redDot.layer setCornerRadius:3];
        [_redDot.layer setMasksToBounds:YES];
        [self addSubview:_redDot];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_statusLabel setTextColor:kCommonParentTintColor];
        [_statusLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:_statusLabel];
        
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray_expand_indicator"]];
        [_rightArrow setOrigin:CGPointMake(self.width - 10 - _rightArrow.width, (self.height - _rightArrow.height) / 2)];
        [self addSubview:_rightArrow];
    }
    return self;
}

- (void)setHomeworkItem:(HomeworkItem *)homeworkItem{
    _homeworkItem = homeworkItem;
    NSInteger spaceXStart = 10;
    NSInteger spaceXEnd = _rightArrow.left - 5;
    [_courseLabel setText:@"语文作业"];
    [_courseLabel sizeToFit];
    [_courseLabel setOrigin:CGPointMake(spaceXStart, (self.height - _courseLabel.height) / 2)];
    spaceXStart = _courseLabel.right + 10;
    
    [_imageTypeView setOrigin:CGPointMake(spaceXStart, (self.height - _imageTypeView.height) / 2)];
    spaceXStart = _imageTypeView.right + 10;
    [_voiceTypeView setOrigin:CGPointMake(spaceXStart, (self.height - _voiceTypeView.height) / 2)];
    spaceXStart = _voiceTypeView.right + 10;
    [_videoTypeView setOrigin:CGPointMake(spaceXStart, (self.height - _videoTypeView.height) / 2)];
    
    [_statusLabel setText:@"已发送"];
    [_statusLabel sizeToFit];
    [_statusLabel setOrigin:CGPointMake(spaceXEnd - _statusLabel.width, (self.height - _statusLabel.height) / 2)];
    
    spaceXEnd = _statusLabel.left - 2;
    [_redDot setOrigin:CGPointMake(spaceXEnd - _redDot.width, (self.height - _redDot.height) / 2)];
}

@end

@implementation HomeWorkCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, self.width - 15 * 2, 0)];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        [_bgView.layer setCornerRadius:10];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _avatarView = [[AvatarView alloc] initWithRadius:18];
        [_avatarView setOrigin:CGPointMake(10, 10)];
        [_bgView addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont systemFontOfSize:14]];
        [_nameLabel setTextColor:kCommonParentTintColor];
        [_bgView addSubview:_nameLabel];
        
        _roleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_roleLabel setFont:[UIFont systemFontOfSize:14]];
        [_roleLabel setTextColor:kCommonParentTintColor];
        [_bgView addSubview:_roleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setFont:[UIFont systemFontOfSize:12]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_bgView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _avatarView.bottom + 10, _bgView.width - 10 * 2, 0)];
        [_contentLabel setFont:[UIFont systemFontOfSize:14]];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_bgView addSubview:_contentLabel];
        
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_endTimeLabel setTextColor:kCommonParentTintColor];
        [_endTimeLabel setFont:[UIFont systemFontOfSize:12]];
        [_bgView addSubview:_endTimeLabel];

        _extraInfoView = [[HomeworkExtraInfoView alloc] initWithFrame:CGRectMake(0, _endTimeLabel.bottom, _bgView.width, 45)];
        [_bgView addSubview:_extraInfoView];
    }
    return self;
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    HomeworkItem *homeworkItem = (HomeworkItem *)modelItem;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:@"http://img6.bdstatic.com/img/image/smallpic/dongman1014.jpg"] placeholderImage:nil];
    [_nameLabel setText:@"吴枕着"];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, _avatarView.top)];
    [_roleLabel setText:@"教师"];
    [_roleLabel sizeToFit];
    [_roleLabel setOrigin:CGPointMake(_nameLabel.right + 5, _avatarView.top)];
    [_timeLabel setText:@"发布时间:06-01 14:53"];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_avatarView.right + 10, _avatarView.bottom - _timeLabel.height)];
    
    CGFloat spaceYStart = _avatarView.bottom + 10;
    NSString *words = homeworkItem.words;
    if(words.length > 0){
        [_contentLabel setHidden:NO];
        [_contentLabel setWidth:_bgView.width - 10 * 2];
        [_contentLabel setText:words];
        [_contentLabel sizeToFit];
        [_contentLabel setOrigin:CGPointMake(10, spaceYStart)];
        spaceYStart = _contentLabel.bottom + 10;
    }
    else{
        [_contentLabel setHidden:YES];
    }
    [_endTimeLabel setText:@"截止时间:06-02 10:00"];
    [_endTimeLabel sizeToFit];
    [_endTimeLabel setOrigin:CGPointMake(10, spaceYStart)];
    spaceYStart = _endTimeLabel.bottom + 10;
    [_extraInfoView setOrigin:CGPointMake(0, spaceYStart)];
    [_extraInfoView setHomeworkItem:homeworkItem];
    [_bgView setHeight:_extraInfoView.bottom];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width{
    HomeworkItem *homeworkItem = (HomeworkItem *)modelItem;
    CGFloat height = 36 + 10 * 2;
    NSString *words = homeworkItem.words;
    if(words.length > 0){
        CGSize contentSize = [words sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(width - 15 * 2 - 10 * 2, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
        height += contentSize.height + 10;
    }
    NSString *endStr = @"截止时间";
    CGSize endTimeSize = [endStr sizeForFont:[UIFont systemFontOfSize:12] size:CGSizeMake(width - 15 * 2 - 10 * 2, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    height += endTimeSize.height + 10;
    height += 45;
    return @(height + 15);
}

@end

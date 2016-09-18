//
//  MessageDetailItemCell.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "MessageDetailItemCell.h"
#import "CollectionImageCell.h"
#import "MessageDetailModel.h"
NSString *const  kMessageDeleteNotitication = @"MessageDeleteNotitication";
NSString *const  kMessageDeleteModelItemKey = @"MessageDeleteModelItemKey";
#define kContentFont            [UIFont systemFontOfSize:14]

#define kBGTopMargin            12
#define kOperationHeight        32
#define kBGViewHMargin          10
#define kContentHMargin         10
#define kInnerMargin            8
#define kExtraInfoHeight        48

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
        [_bgView.layer setCornerRadius:10];
        [_bgView.layer setMasksToBounds:YES];
        [self addSubview:_bgView];
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(10, 10, 46, 46)];
        [_bgView addSubview:_avatarView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 25, 100, kOperationHeight)];
        [_nameLabel setFont:[UIFont systemFontOfSize:15]];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_bgView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeLabel setBackgroundColor:[UIColor clearColor]];
        [_timeLabel setFont:[UIFont systemFontOfSize:13]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"9a9a9a"]];
        [_bgView addSubview:_timeLabel];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setFrame:CGRectMake(_bgView.width - 50, 0, 50, 50)];
        [_deleteButton setImage:[UIImage imageNamed:@"MessageDetailTrash"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(onMessageDeleteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_deleteButton];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentHMargin, 0, _bgView.width - kContentHMargin * 2, 0)];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:kContentFont];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_bgView addSubview:_contentLabel];
        
        _extraView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, kExtraInfoHeight)];
        [_bgView addSubview:_extraView];
        
        _sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, kLineHeight)];
        [_sepLine setBackgroundColor:kSepLineColor];
        [_extraView addSubview:_sepLine];
        
        _voiceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_hasAudio"]];
        [_extraView addSubview:_voiceImageView];
        
        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_hasVideo"]];
        [_extraView addSubview:_videoImageView];
        
        _photoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_hasPhoto"]];
        [_extraView addSubview:_photoImageView];
        
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gray_expand_indicator"]];
        [_extraView addSubview:_rightArrow];
    }
    return self;
}

- (void)setFromInfo:(MessageFromInfo *)fromInfo{
    _fromInfo = fromInfo;
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:_fromInfo.logoUrl]];
    [_nameLabel setText:_fromInfo.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, _avatarView.y + 5)];
}

- (void)onReloadData:(TNModelItem *)modelItem
{
    MessageDetailItem *item = (MessageDetailItem *)modelItem;
    if(item.is_new){
        [_bgView setBackgroundColor:[UIColor colorWithHexString:@"f4f9fa"]];
    }
    else{
        [_bgView setBackgroundColor:[UIColor whiteColor]];
    }
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:item.from_user.avatar]];
    [_nameLabel setText:item.from_user.name];
    [_nameLabel sizeToFit];
    [_nameLabel setOrigin:CGPointMake(_avatarView.right + 10, _avatarView.y + 5)];
    [_timeLabel setText:item.time_str];
    [_timeLabel sizeToFit];
    [_timeLabel setOrigin:CGPointMake(_avatarView.right + 10, _avatarView.bottom - 5 - _timeLabel.height)];
    CGFloat height = _avatarView.bottom + 15;
    NSString *content = item.words;
    [_contentLabel setWidth:_bgView.width - kContentHMargin * 2];
    if(content.length > 0){
        [_contentLabel setHidden:NO];
        [_contentLabel setText:content];
        if(item.type == ChatTypeLianZhiBroadcast || item.type == ChatTypeDoorEntrance){
            [_contentLabel sizeToFit];
        }
        else{
            [MessageDetailItemCell dynamicCalculationLabelHight:_contentLabel];
        }
        [_contentLabel setY:height];
        height += _contentLabel.height + 10;
    }
    else{
        [_contentLabel setHidden:YES];
    }
    
    if(item.type == ChatTypeLianZhiBroadcast || item.type == ChatTypeDoorEntrance){
        [_extraView setHidden:YES];
    }
    else{
        [_extraView setHidden:NO];
        [_extraView setY:height];
        
        
        CGFloat spaceXStart = kContentHMargin;
        [_voiceImageView setHidden:!item.hasAudio];
        [_photoImageView setHidden:!item.hasPhoto];
        [_videoImageView setHidden:!item.hasVideo];
        if(item.hasAudio){
            [_voiceImageView setOrigin:CGPointMake(spaceXStart, (kExtraInfoHeight - _voiceImageView.height) / 2)];
            spaceXStart += _voiceImageView.width + 15;
        }
        if(item.hasVideo){
            [_videoImageView setOrigin:CGPointMake(spaceXStart, (kExtraInfoHeight - _videoImageView.height) / 2)];
            spaceXStart += _videoImageView.width + 15;
        }
        if(item.hasPhoto){
            [_photoImageView setOrigin:CGPointMake(spaceXStart,  (kExtraInfoHeight - _photoImageView.height) / 2)];
            spaceXStart += _photoImageView.width + 15;
        }
        
        [_rightArrow setOrigin:CGPointMake(_bgView.width - 12 - _rightArrow.width, (kExtraInfoHeight - _rightArrow.height) / 2)];
         height += kExtraInfoHeight;
    }
    [_bgView setHeight:height];

}

- (void)onMessageDeleteButtonClicked
{
    if(self.deleteCallback){
        self.deleteCallback();
    }
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    MessageDetailItem *item = (MessageDetailItem *)modelItem;
    NSInteger height = kBGTopMargin + 46 + 15;
    NSString *content = item.words;
    if(content.length > 0){
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kContentHMargin, 0, width - kBGViewHMargin * 2 - kContentHMargin * 2, 0)];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [contentLabel setNumberOfLines:0];
        [contentLabel setFont:kContentFont];
        [contentLabel setText:content];
        if(item.type == ChatTypeLianZhiBroadcast || item.type == ChatTypeDoorEntrance){
            [contentLabel sizeToFit];
        }
        else{
            [MessageDetailItemCell dynamicCalculationLabelHight:contentLabel];
        }
        height += contentLabel.height + 10;
    }
    if(item.type == ChatTypeLianZhiBroadcast || item.type == ChatTypeDoorEntrance){
        
    }
    else{
        height += kExtraInfoHeight;
    }
    height +=  kBGTopMargin;
    return @(height);
}

+ (void)dynamicCalculationLabelHight:(UILabel*) label{
    NSInteger n = 3;
    CGSize labelSize = {0, 0};
    labelSize = [self ZFYtextHeightFromTextString:label.text width:label.frame.size.width fontSize:label.font.pointSize];
    // NSLog(@"%f",label.font.pointSize);//获取 label的字体大小 //NSLog(@"%f",label.font.lineHeight);//获取label的在不同字体下的时候所需要的行高 //NSLog(@"%f",labelSize.height);//label计算行高
    CGFloat rate = label.font.lineHeight; //每一行需要的高度
    CGRect frame= label.frame;
    if (labelSize.height>rate*n)
    {
        frame.size.height = rate*n;
    }
    else
    {
        frame.size.height = labelSize.height;
    }
    label.frame = frame;
}

+ (CGSize)ZFYtextHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size{
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:size]};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    CGSize size1 = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]}];
    return CGSizeMake(size1.width, rect.size.height);
}

@end

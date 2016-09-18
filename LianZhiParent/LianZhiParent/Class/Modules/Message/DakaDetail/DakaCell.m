//
//  DakaCell.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/28.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "DakaCell.h"
#import "MessageDetailItem.h"
#define kContentFont            [UIFont systemFontOfSize:14]

#define kBGTopMargin            12
#define kOperationHeight        32
#define kBGViewHMargin          10
#define kContentHMargin         10
#define kInnerMargin            8
#define kExtraInfoHeight        48
@implementation DakaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
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
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setFont:kContentFont];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_bgView addSubview:_contentLabel];

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
        [_contentLabel sizeToFit];
        [_contentLabel setY:height];
        height += _contentLabel.height + 10;
    }
    else{
        [_contentLabel setHidden:YES];
    }
    [_bgView setHeight:height];
    if(item.is_new){
        [_bgView setBackgroundColor:[UIColor colorWithHexString:@"f4f9fa"]];
    }
    else{
        [_bgView setBackgroundColor:[UIColor whiteColor]];
    }
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
    NSInteger height = kBGTopMargin + 10 + 46 + 15;
    NSString *content = item.words;
    if(content.length > 0){
        CGSize contentSize = [item.words boundingRectWithSize:CGSizeMake(width - kBGViewHMargin * 2 - kContentHMargin * 2, CGFLOAT_MAX) andFont:kContentFont];
        height += contentSize.height + 10;
    }
    return @(height);
}


@end

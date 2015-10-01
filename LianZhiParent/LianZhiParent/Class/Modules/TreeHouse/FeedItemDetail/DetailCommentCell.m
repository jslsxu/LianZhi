//
//  DetailCommentCell.m
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/1.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "DetailCommentCell.h"

@implementation DetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.width = kScreenWidth - 12 * 2;
        [self setBackgroundColor:[UIColor colorWithHexString:@"F0F0F0"]];
        
        _commentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DetailCommentIcon"]];
        [_commentImageView setOrigin:CGPointMake(6, 10)];
        [self addSubview:_commentImageView];
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kLineHeight)];
        [topLine setBackgroundColor:[UIColor colorWithHexString:@"E0E0E0"]];
        [self addSubview:topLine];
        
        _avatarView = [[AvatarView alloc] initWithFrame:CGRectMake(30, 9, 22, 22)];
        [self addSubview:_avatarView];
        
        _nameLabel= [[UILabel alloc] initWithFrame:CGRectMake(55, 9, 150, 12)];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"395c9d"]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 8 - 100, 8, 100, 12)];
        [_timeLabel setFont:[UIFont systemFontOfSize:10]];
        [_timeLabel setTextColor:[UIColor colorWithHexString:@"afafaf"]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 24, self.width - 55 - 10, 0)];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"2c2c2c"]];
        [_contentLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:_contentLabel];
    }
    return self;
}

- (void)setResponseItem:(ResponseItem *)responseItem
{
    _responseItem = responseItem;
    [_avatarView setImageWithUrl:[NSURL URLWithString:_responseItem.sendUser.avatar]];
    [_nameLabel setText:_responseItem.sendUser.name];
    [_timeLabel setText:[_responseItem.commentItem.ctime substringFromIndex:5]];
    NSMutableString *content = [[NSMutableString alloc] init];
    NSString *toUser = responseItem.commentItem.toUser;
    if(toUser.length > 0)
    {
        [content appendFormat:@"回复%@: ",toUser];
    }
    [content appendString:_responseItem.commentItem.content];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor colorWithHexString:@"2c2c2c"]}];
    [attributedStr addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"395c9d"]} range:NSMakeRange(2, toUser.length)];
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(_contentLabel.width, CGFLOAT_MAX) andFont:_contentLabel.font];
    [_contentLabel setHeight:contentSize.height];
    [_contentLabel setAttributedText:attributedStr];
}

- (void)setCellType:(TableViewCellType)cellType
{
    _cellType = cellType;
    [_commentImageView setHidden:_cellType != TableViewCellTypeFirst];
}

+ (NSNumber *)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    ResponseItem *responseItem = (ResponseItem *)modelItem;
    NSMutableString *content = [[NSMutableString alloc] init];
    NSString *toUser = responseItem.commentItem.toUser;
    if(toUser.length > 0)
    {
        [content appendFormat:@"回复%@: ",toUser];
    }
    [content appendString:responseItem.commentItem.content];
    CGSize contentSize = [content boundingRectWithSize:CGSizeMake(width - 55 - 10, CGFLOAT_MAX) andFont:[UIFont systemFontOfSize:12]];
    return @(24 + contentSize.height + 8);
}

@end

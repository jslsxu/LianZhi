//
//  DetailCommentCell.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/1.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"

@interface DetailCommentCell : TNTableViewCell
{
    UIView*         _topLine;
    UIImageView*    _commentImageView;
    AvatarView* _avatarView;
    UILabel*    _nameLabel;
    UILabel*    _timeLabel;
    UILabel*    _contentLabel;
}
@property (nonatomic, assign)TableViewCellType cellType;
@property (nonatomic, strong)ResponseItem *responseItem;
@end

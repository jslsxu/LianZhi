//
//  NewMessageCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "NewMessageModel.h"
@interface NewMessageCell : TNTableViewCell
{
    AvatarView*     _avatarView;
    UILabel*        _authorLabel;
    UILabel*        _contentLabel;
    UILabel*        _timeLabel;
    UIImageView*    _contentImageView;
    UIView*         _sepLine;
}
@end

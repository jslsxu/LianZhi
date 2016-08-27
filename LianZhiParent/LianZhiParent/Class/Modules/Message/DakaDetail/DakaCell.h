//
//  DakaCell.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/28.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"

@interface DakaCell : TNTableViewCell{
    UIView*                 _bgView;
    AvatarView*             _avatarView;
    UIButton*               _deleteButton;
    UILabel*                _nameLabel;
    UILabel*                _timeLabel;
    UILabel*                _contentLabel;
}
@property (nonatomic, strong)MessageFromInfo *fromInfo;
@property (nonatomic, copy)void (^deleteCallback)();
@end

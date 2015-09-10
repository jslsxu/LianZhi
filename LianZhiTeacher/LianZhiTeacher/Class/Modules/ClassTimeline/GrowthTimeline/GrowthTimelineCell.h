//
//  GrowthTimelineCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "GrowthTimelineModel.h"
@interface GrowthTimelineCell : TNTableViewCell
{
    UIView*         _bgView;
    UIView*         _statusView;
    AvatarView*     _avatarView;
    UILabel*        _nickNameLabel;
    UIView*         _contentView;
    UILabel*        _contentLabel;
    NSMutableArray* _statusArray;
}
@end

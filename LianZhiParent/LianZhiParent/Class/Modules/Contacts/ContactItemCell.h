//
//  ContactItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "UserCenter.h"
@interface ContactItemCell : TNTableViewCell
{
    AvatarView*           _logoView;
    UILabel*            _nameLabel;
    UILabel*            _commentLabel;
    UIView*             _sepLine;
}
@property (nonatomic, strong)UserInfo *userInfo;
@end

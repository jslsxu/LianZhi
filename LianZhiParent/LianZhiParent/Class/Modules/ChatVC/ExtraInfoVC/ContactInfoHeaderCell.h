//
//  ContactInfoCell.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"

@interface ContactInfoHeaderCell : TNTableViewCell{
    AvatarView* _avatarView;
    UILabel*    _nameLabel;
}
@property (nonatomic, strong)UserInfo*  userInfo;
@end

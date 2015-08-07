//
//  ContactItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/18.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "ContactModel.h"
#import "SchoolInfo.h"
@interface ClassItemCell : UITableViewCell
{
    LogoView*   _logoView;
    UILabel*    _nameLabel;
    UIView*     _sepLine;
}
@property (nonatomic, strong)ClassInfo *classInfo;

@end

@interface ContactItemCell : UITableViewCell
{
    MSCircleImageView*  _avatar;
    UILabel*            _nameLabel;
    UILabel*            _commentLabel;
    UIImageView*        _genderImageView;
    UIView*             _sepLine;
}
@property (nonatomic, strong)UserInfo *userInfo;
@end

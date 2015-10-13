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
    LogoView*           _logoView;
    UILabel*            _nameLabel;
    UILabel*            _commentLabel;
    UIView*             _sepLine;
    UIButton*           _chatButton;
}
@property (nonatomic, assign)BOOL studetsParentsCell;
@property (nonatomic, strong)TeacherInfo *teachInfo;
@property (nonatomic, strong)SchoolInfo *schoolInfo;
@end

//
//  ChatExtraInfoVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ChatExtraUserCell : TNTableViewCell
{
    AvatarView*     _avatarView;
    UILabel*        _nameLabel;
    UILabel*        _nickLabel;
}
@property (nonatomic, strong)UserInfo*  userInfo;
@end

@interface ChatExtraIndividualInfoVC : TNBaseViewController{
    
}
@property (nonatomic, strong)UserInfo* userInfo;
@end

//
//  ChatExtraInfoVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "SchoolInfo.h"

typedef void(^ClearChatFinished)(BOOL success);

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
@property (nonatomic, assign)ChatType chatType;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *toObjid;
@property (nonatomic, assign)BOOL quietModeOn;
@property (nonatomic, copy)void (^alertChangeCallback)(BOOL quietModeOn);
@property (nonatomic, copy)void (^clearChatRecordCallback)(ClearChatFinished clearChatFinished);
@end

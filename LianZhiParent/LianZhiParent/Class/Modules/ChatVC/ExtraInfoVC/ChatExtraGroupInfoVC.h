//
//  ChatExtraGroupInfoVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/3.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "ChatExtraIndividualInfoVC.h"
@interface ChatExtraGroupInfoCell : TNTableViewCell{
    LogoView*        _logoView;
}

@end

@interface ChatExtraGroupInfoVC : TNBaseViewController
@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, assign)ChatType chatType;
@property (nonatomic, assign)BOOL soundOn;
@property (nonatomic, copy)void (^alertChangeCallback)(BOOL soundOn);
@property (nonatomic, copy)void (^clearChatRecordCallback)(ClearChatFinished clearChatFinished);
@end

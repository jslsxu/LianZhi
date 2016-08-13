//
//  ChatExtraGroupInfoVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/3.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ChatExtraGroupInfoCell : TNTableViewCell{
    LogoView*        _logoView;
}
@property (nonatomic, readonly)LogoView *logoView;
@end

@interface ChatExtraGroupInfoVC : TNBaseViewController
@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, assign)ChatType chatType;
@end

//
//  NotificationTargetListVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/31.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTargetHeaderView : UITableViewHeaderFooterView{
    LogoView*       _logoView;
    UILabel*        _titleLabel;
    UILabel*        _stateLabel;
    UIImageView*    _arrowImageView;
}
@property (nonatomic, assign)BOOL expand;
@end

@interface NotificationSendTargetCell : TNTableViewCell{
    AvatarView*     _avatarView;
    UILabel*        _titleLabel;
    UILabel*        _stateLabel;
    UIImageView*    _stateImageView;
}
@property (nonatomic, strong)UserInfo*  userInfo;
@end

@interface NotificationTargetListView : UIView

@end

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
@property (nonatomic, strong)id group;
@property (nonatomic, assign)BOOL expand;
@property (nonatomic, copy)void (^expandCallback)();
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
@property (nonatomic, strong)NotificationItem* notificationItem;
@property (nonatomic, copy)void (^notificationRefreshCallback)(NotificationItem *notification);
@end

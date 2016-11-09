//
//  HomeworkTargetListView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkItem.h"
@interface HomeworkTargetHeaderView : UITableViewHeaderFooterView{
    LogoView*       _logoView;
    UILabel*        _titleLabel;
    UIView*         _redDot;
    UILabel*        _stateLabel;
    UIImageView*    _arrowImageView;
    UIButton*       _alertButton;
}
@property (nonatomic, assign)BOOL etype;
@property (nonatomic, strong)HomeworkClassStatus* classInfo;
@property (nonatomic, assign)BOOL expand;
@property (nonatomic, copy)void (^expandCallback)();
@property (nonatomic, copy)void (^alertCallback)();
@end

@interface HomeworkSendTargetCell : TNTableViewCell{
    AvatarView*     _avatarView;
    UILabel*        _titleLabel;
    UILabel*        _stateLabel;
    UIView*         _redDot;
    UIImageView*    _mobileImageView;
    UIImageView*    _rightArrow;
}
@property (nonatomic, assign)BOOL etype;
@property (nonatomic, strong)HomeworkStudentInfo*  userInfo;
@end
@interface HomeworkTargetListView : UIView
@property (nonatomic, strong)HomeworkItem *homeworkItem;
@property (nonatomic, assign)BOOL hasNew;
@property (nonatomic, copy)void (^homeworkRefreshCallback)(HomeworkItem *homework);
@end

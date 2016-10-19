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
    UILabel*        _stateLabel;
    UIImageView*    _arrowImageView;
}
@property (nonatomic, strong)id group;
@property (nonatomic, assign)BOOL expand;
@property (nonatomic, copy)void (^expandCallback)();
@end

@interface HomeworkSendTargetCell : TNTableViewCell{
    AvatarView*     _avatarView;
    UILabel*        _titleLabel;
    UILabel*        _stateLabel;
    UIImageView*    _stateImageView;
}
@property (nonatomic, strong)UserInfo*  userInfo;
@end
@interface HomeworkTargetListView : UIView
@property (nonatomic, strong)HomeworkItem *homeworkItem;
@property (nonatomic, copy)void (^homeworkRefreshCallback)(HomeworkItem *homework);
@end

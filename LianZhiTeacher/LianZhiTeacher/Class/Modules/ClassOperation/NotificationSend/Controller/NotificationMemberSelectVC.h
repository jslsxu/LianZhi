//
//  NotificationTargetSelectVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

typedef NS_ENUM(NSInteger, UserType){
    UserTypeStudent,
    UserTypeTeacher
};

@interface NotificationMemberHeaderView : UITableViewHeaderFooterView
{
    UIImageView*    _stateImageView;
    UIImageView*    _logoView;
    UILabel*        _nameLabel;
    UILabel*        _numLabel;
    UIButton*       _allSelectButton;
    UIView*         _bottomLine;
}
@property (nonatomic, copy)void (^headerExpandClick)();
@property (nonatomic, copy)void (^allSelectClick)();
@property (nonatomic, assign)BOOL expand;
@property (nonatomic, strong)id groupInfo;
@end

@interface NotificationMemberItemCell : UITableViewCell{
    UIImageView*    _stateImageView;
    AvatarView*    _avatarView;
    UILabel*        _nameLabel;
    UIView*         _sepLine;
}
@property (nonatomic, strong)UserInfo *userInfo;
+ (CGFloat)cellHeight;
@end


@interface NotificationMemberView : UIView{
    UITableView*    _tableView;
    UIView*         _actionView;
    UIButton*       _selectAllButton;
    UILabel*        _stateLabel;
}
@property (nonatomic, assign)UserType userType;
@property (nonatomic, strong)NSArray *dataSource;
- (instancetype)initWithFrame:(CGRect)frame;
@end

typedef NS_ENUM(NSInteger, MemberSelectStyle){
    MemberSelectStyleNotification = 0,      //通知
    MemberSelectStyleHomeWork               //作业
};

@interface NotificationMemberSelectVC : TNBaseViewController{
    NotificationMemberView* _studentView;
    NotificationMemberView* _teacherView;
}
@property (nonatomic, assign)MemberSelectStyle memberSelectStyle;
@property (nonatomic, copy)void (^selectCompletion)(NSArray *classArray, NSArray* groupArray);
- (instancetype)initWithOriginalArray:(NSArray *)sourceArray;
@end

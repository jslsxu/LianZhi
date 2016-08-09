//
//  ContactParentsView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/4.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactParentItemCell : TNTableViewCell{
    AvatarView*     _avatarView;
    UILabel*        _nameLabel;
    UILabel*        _relationLabel;
    UIButton*       _chatButton;
    UIButton*       _phoneButton;
    UIView*         _sepLine;
}
@property (nonatomic, strong)FamilyInfo*    familyInfo;
@property (nonatomic, copy)void (^chatCallback)();
@property (nonatomic, copy)void (^phoneCallback)();
@end

@interface ContactParentsView : UIView
@property (nonatomic, strong)StudentInfo*   studentInfo;
@end

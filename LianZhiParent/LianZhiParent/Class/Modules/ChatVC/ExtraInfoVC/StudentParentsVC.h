//
//  StudentParentsVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/14.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ContactGroup : NSObject
@property (nonatomic, copy)NSString *key;
@property (nonatomic, strong)NSMutableArray *contacts;

@end

@interface StudentParentCell : DAContextMenuCell
{
    AvatarView* _avatarView;
    UILabel*    _nameLabel;
    UIButton*   _chatButton;
    UIView*     _sepLine;
}
@property (nonatomic, strong)FamilyInfo *familyInfo;
@property (nonatomic, assign)BOOL isInBlackList;
@end

@interface StudentParentsVC : DAContextMenuTableViewController
{
    
}
@property (nonatomic, strong)ChildInfo *childInfo;
@end

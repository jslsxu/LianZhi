//
//  ChildrenSelectVC.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/8/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ChildrenCell : TNTableViewCell
{
    AvatarView*     _avatar;
    UILabel*        _nameLabel;
    UIView*         _redDot;
    UILabel*        _statusLabel;
    UIImageView*    _arrowImage;
    UIView*         _sepLine;
}
@property (nonatomic, strong)ChildInfo* childInfo;
@property (nonatomic, assign)BOOL isCurChild;
@property (nonatomic, assign)BOOL hasNew;
@end

@interface ChildrenSelectVC : TNBaseViewController
+ (void)showChildrenSelectWithCompletion:(void (^)())completion;
@end

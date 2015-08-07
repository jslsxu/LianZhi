//
//  IndividualOperationView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageOperationVC.h"

@interface IndividualOperationView : UIView
{
    UIButton*       _bgButton;
    UIImageView*    _bgImageView;
    AvatarView*     _avatar;
    UILabel*        _nameLabel;
    UIView*         _sepLine;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, strong)StudentInfo *studentInfo;
- (instancetype)initWithFrame:(CGRect)frame andClassInfo:(ClassInfo *)classInfo;
- (void)fadeIn;
@end

//
//  ClassOperationHeaderView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/4.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassOperationHeaderView;
@protocol ClassOperationDelegate <NSObject>
- (void)classSwitch:(ClassOperationHeaderView *)headerView;

@end

@interface ClassOperationHeaderView : UIView
{
    UIImageView*    _bgImageView;
    LogoView*       _logoView;
    UILabel*        _nameLabel;
    UIButton*       _classButton;
    UIButton*       _switchButton;
}
@property (nonatomic, weak)id<ClassOperationDelegate> delegate;
@property (nonatomic, strong)ClassInfo *classInfo;
@end

//
//  ClassZoneClassSwitchView.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildInfo.h"
@protocol ClassZoneSwitchDelegate <NSObject>
- (void)classZoneSwitch;

@end

@interface ClassZoneClassSwitchView : UIView
{
    UILabel*        _classNameLabel;
    UIButton*       _switchButton;
}
@property (nonatomic, strong)ChildInfo *curChild;
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, assign)id<ClassZoneSwitchDelegate> delegate;
@end

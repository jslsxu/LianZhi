//
//  ClassZoneClassSwitchView.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SchoolInfo.h"
@protocol ClassZoneSwitchDelegate <NSObject>
- (void)classZoneSwitch:(ClassInfo *)classInfo;

@end

@interface ClassZoneClassSwitchView : UIView
{
    UILabel*        _classNameLabel;
    UIButton*       _arrowButton;
    UIButton*       _coverButton;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, assign)id<ClassZoneSwitchDelegate> delegate;
@end

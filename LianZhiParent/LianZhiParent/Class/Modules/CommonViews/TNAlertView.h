//
//  TNAlertView.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNActionSheet.h"

@interface TNAlertView : UIView
{
    UIView*         _bgView;
    UIView*         _buttonView;
    UILabel*        _titleLabel;
}

- (instancetype)initWithTitle:(NSString *)title buttonItems:(NSArray *)items;
- (void)show;
@end

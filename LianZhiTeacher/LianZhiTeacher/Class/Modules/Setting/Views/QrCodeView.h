//
//  QrCodeView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/4/28.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QrCodeView : UIView
{
    UIButton*   _coverButton;
    UIView*     _contentView;
}
- (void)showInView:(UIView *)viewParent;
@end

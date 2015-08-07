//
//  NewEditionPreview.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/3/1.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewEditionPreview : UIView
{
    UIView*         _bgView;
    UIView*         _contentView;
    UIView*         _rootView;
    UIScrollView*   _scrollView;
    UIButton*       _confirmButton;
}
- (void)show;
- (void)dismiss;
@end

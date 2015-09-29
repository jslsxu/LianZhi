//
//  ActionView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Action)(NSInteger index);

@interface ActionView : UIView
{
    UIButton*   _coverButton;
    UIView*     _contentView;
    UIButton*   _praiseButton;
    UIButton*   _commentButton;
    UIButton*   _shareButton;
}
@property (nonatomic, assign)CGPoint point;
- (instancetype)initWithPoint:(CGPoint)point praised:(BOOL)praised action:(Action)action;
- (void)show;
@end

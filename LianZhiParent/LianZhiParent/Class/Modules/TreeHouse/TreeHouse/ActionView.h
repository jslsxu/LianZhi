//
//  ActionView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionView : UIView
{
    UIButton*   _praiseButton;
    UIButton*   _commentButton;
    UIButton*   _shareButton;
}
@property (nonatomic, assign)CGPoint point;
- (instancetype)initWithPoint:(CGPoint)point;
@end

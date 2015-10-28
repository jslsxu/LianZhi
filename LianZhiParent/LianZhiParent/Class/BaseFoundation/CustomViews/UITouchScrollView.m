//
//  UITouchScrollView.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/28.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "UITouchScrollView.h"

@implementation UITouchScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end

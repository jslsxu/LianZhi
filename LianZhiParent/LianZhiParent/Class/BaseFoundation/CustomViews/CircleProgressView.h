//
//  CircleProgressView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView
@property(nonatomic, assign)CGFloat fProgress;
- (instancetype)initWithRadius:(CGFloat)radius;
@end

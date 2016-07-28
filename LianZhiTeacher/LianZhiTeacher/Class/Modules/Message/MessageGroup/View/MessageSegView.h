//
//  MessageSegView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/27.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSegButton : LZTabBarButton

@end

@interface MessageSegView : UIView
@property (nonatomic, assign)NSInteger selectedIndex;
- (instancetype)initWithItems:(NSArray *)items valueChanged:(void (^)(NSInteger selectedIndex))callback;
- (void)setShowBadge:(NSString *)badge atIndex:(NSInteger)index;
- (void)startLoading;
- (void)endLoading;
@end

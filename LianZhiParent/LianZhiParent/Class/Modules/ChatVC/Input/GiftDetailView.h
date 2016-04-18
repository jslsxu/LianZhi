//
//  GiftDetailView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/13.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftDetailView : UIView
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIView *contentView;
@property (nonatomic, strong)UIView *borderView;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, strong)UIButton *actionButton;
@property (nonatomic, copy)void (^completion)();
@property (nonatomic, assign)BOOL valid;

+ (void)showWithImage:(NSString *)imageUrl title:(NSString *)title;
+ (void)showWithImage:(NSString *)imageUrl title:(NSString *)title receiveCompletion:(void (^)())completion valid:(BOOL)valid;
@end

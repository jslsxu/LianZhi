//
//  ResourceBaseVC.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/29.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZHeadLineView.h"

@interface ResourceBaseVC : TNBaseViewController

@property(nonatomic, weak) UIViewController *baseRootVC;
@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,strong) UIView *emptydataView;

-(void)setTitleArray:(NSArray *)titleArray;
-(void)setHeadViewCurrentIndex:(NSInteger)CurrentIndex;
-(void)initViewCurrentIndex;
-(void)showAlert:(NSString *)message;
@end

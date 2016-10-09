//
//  NumOperationView.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumOperationView : UIView{
    UIButton*   _decreaseButton;
    UITextField*    _contentField;
    UIButton*   _increaseButton;
}
@property (nonatomic, assign)NSInteger num;
- (instancetype)initWithMin:(NSInteger)min max:(NSInteger)max;
@end

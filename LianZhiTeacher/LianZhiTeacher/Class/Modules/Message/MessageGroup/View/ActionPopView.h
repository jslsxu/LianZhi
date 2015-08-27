//
//  ActionPopView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActionPopViewDelegate <NSObject>
- (void)popActionViewDidSelectedAtIndex:(NSInteger)index;

@end
@interface ActionPopView : UIView
{
    UIImageView*    _bgImageView;
    UIView*         _contentView;
}
@property (nonatomic, weak)id<ActionPopViewDelegate> delegate;
- (void)show;
@end

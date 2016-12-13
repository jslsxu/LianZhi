//
//  ResourceMainVC.h
//  LianZhiParent
//
//  Created by Chen Qi on 2016/9/28.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ChildrenSelectView.h"

@interface ResourceMainVC : UITabBarController//<ChildrenSelectDelegate>
{
    NSMutableArray* _tabbarButtons;
}
- (void)setClassInfo:(ClassInfo *)classInfo;
- (void)selectAtIndex:(NSInteger)index;
@end

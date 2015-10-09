//
//  LZTabBarButton.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumIndicator.h"
@interface LZTabBarButton : UIButton
{
    NumIndicator*   _numIndicator;
}
@property (nonatomic, copy)NSString *badgeValue;
@property (nonatomic, assign)CGFloat spacing;
@end

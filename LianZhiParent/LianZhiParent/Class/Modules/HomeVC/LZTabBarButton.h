//
//  LZTabBarButton.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZTabBarButton : UIButton
{
    UIImageView*    _redDot;
}
@property (nonatomic, assign)BOOL hasNew;
@property (nonatomic, assign)BOOL presenting;
@end

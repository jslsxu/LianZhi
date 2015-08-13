//
//  WelcomeView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/2/6.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WelComeViewDelegate <NSObject>
- (void)welcomeViewDidFinished;

@end
@interface WelcomeView : UIWindow<UIScrollViewDelegate>
{
    UIScrollView*   _scrollView;
    UIPageControl*  _pageControl;
}
@property (nonatomic, weak)id<WelComeViewDelegate> welcomeDelegate;
+ (void)showWelcome;
@end

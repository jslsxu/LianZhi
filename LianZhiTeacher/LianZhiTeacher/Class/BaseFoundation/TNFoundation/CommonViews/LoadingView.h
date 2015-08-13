//
//  LoaingView.h
//  app
//
//  Created by jslsxu on 14/12/7.
//  Copyright (c) 2014年 Related Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
{
    CALayer *   _animationLayer;
    UILabel*    _loadingLabel;
}

- (void)startAnimating;
- (void)stopAnimating;
@end

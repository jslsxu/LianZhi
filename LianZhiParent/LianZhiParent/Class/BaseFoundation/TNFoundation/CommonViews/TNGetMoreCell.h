//
//  SVGetMoreCell.h
//  SViPad
//
//  Created by jslsxu on 14-3-26.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNGetMoreCell : UITableViewCell
{
    UIActivityIndicatorView *   _indicatorView;
    UILabel*                    _textLabel;
}

- (void)startLoading;
- (void)stopLoading;
- (BOOL)isLoading;
@end

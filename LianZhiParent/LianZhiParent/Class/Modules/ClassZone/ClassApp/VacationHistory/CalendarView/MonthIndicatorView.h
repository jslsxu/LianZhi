//
//  MonthIndicatorView.h
//  YouYao
//
//  Created by jslsxu on 15/6/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+convenience.h"
@protocol MonthIndicatorDelegate <NSObject>
- (void)monthIndicatorDidChangeMonth:(NSDate *)date;

@end

@interface MonthIndicatorView : UIView
{
    UIButton*   _preButton;
    UILabel*    _monthLabel;
    UIButton*   _nextButton;
}
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, weak)id<MonthIndicatorDelegate> delegate;
@end

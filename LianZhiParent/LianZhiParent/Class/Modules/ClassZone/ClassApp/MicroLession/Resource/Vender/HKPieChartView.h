//
//  HKPieChartView.h
//  PieChart
//
//  Created by hukaiyin on 16/6/20.
//  Copyright © 2016年 HKY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKPieChartView : UIView

- (void)updateTrackColor:(UIColor *)color;
- (void)updatePercent:(NSString *)percent animation:(BOOL)animationed;
- (void)setChartColor:(UIColor *)color  LabelString:(NSString *)string;

@end

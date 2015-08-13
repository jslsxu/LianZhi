//
//  WWBadgeLabel.h
//  WengWeng5
//
//  Created by HanFeng on 19/05/14.
//  Copyright (c) 2014 mafengwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeLabel : UILabel

@property (nonatomic, readonly) NSLayoutConstraint *top_margin;
@property (nonatomic, readonly) NSLayoutConstraint *right_margin;

@end

@interface RedDot : UIView

@property (nonatomic, readonly) NSLayoutConstraint *top_margin;
@property (nonatomic, readonly) NSLayoutConstraint *right_margin;

@end


@interface UIView (BadgeLabel)

@property (nonatomic, readonly) BadgeLabel *badgeLabel;
@property (nonatomic, readonly) RedDot *newDotTip;

- (RedDot *)newDotTipWithWidth:(CGFloat)width;

@end
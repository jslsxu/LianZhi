//  Created by HanFeng on 13-11-18.
//  Copyright (c) 2013年 mafengwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

+ (UIColor *)colorWithHexString:(NSString *)hex; // not support alpha now
+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha;

- (NSString *)hexARGBValue;
- (NSString *)hexRGBValue;

- (BOOL)isGrayLikeColor;

@end

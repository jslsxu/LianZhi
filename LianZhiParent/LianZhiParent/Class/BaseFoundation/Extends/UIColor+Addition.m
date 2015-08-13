//  Created by HanFeng on 13-11-18.
//  Copyright (c) 2013年 mafengwo. All rights reserved.
//

#import "UIColor+Addition.h"


static inline NSUInteger integerValueFromHex(NSString *s)
{
	int result = 0;
	sscanf([s UTF8String], "%x", &result);
	return result;
}

@implementation UIColor (Addition)

+ (UIColor *)colorWithHexString:(NSString *)hex
{
	if ([hex length]!=6 && [hex length]!=3)
	{
		return nil;
	}
	
	NSUInteger digits = [hex length]/3;
	CGFloat maxValue = (digits==1)?15.0:255.0;
	
	CGFloat red = integerValueFromHex([hex substringWithRange:NSMakeRange(0, digits)])/maxValue;
	CGFloat green = integerValueFromHex([hex substringWithRange:NSMakeRange(digits, digits)])/maxValue;
	CGFloat blue = integerValueFromHex([hex substringWithRange:NSMakeRange(2*digits, digits)])/maxValue;
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha
{
    if (hexValue > 0xffffff) return nil;
    return [UIColor colorWithRed:((hexValue >> 16) / 255.0)
                           green:((hexValue >> 8 & 0xff)  / 255.0)
                            blue:((hexValue & 0xff) / 255.0) alpha:(alpha)];
}

- (NSString *)hexARGBValue
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [NSString stringWithFormat:@"#%02x%02x%02x%02x",(int)(a*255), (int)(r*255), (int)(g*255), (int)(b*255)];
}

- (NSString *)hexRGBValue
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [NSString stringWithFormat:@"#%02x%02x%02x", (int)(r*255), (int)(g*255), (int)(b*255)];
}

- (BOOL)isGrayLikeColor
{
    CGFloat r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r==g && g==b;
}


@end

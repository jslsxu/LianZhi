//
//  NSString+EnDeCoding.h
//  Being
//
//  Created by xiaofeng on 15/10/15.
//  Copyright © 2015年 Being Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EnDeCoding)

/**
 *	@see stringByEscapingForURLArgument
 *
 *	@return	escapted string
 */
- (NSString*)urlEncode;

/**
 *	@see stringByUnescapingFromURLArgument
 *
 *	@return	unescapted string
 */
- (NSString*)urlDecode;

/**
 *	url argument escaping
 *
 *	@return	escapted string
 */
- (NSString*)stringByEscapingForURLArgument;

/**
 *	url argument unescaping
 *
 *	@return	unescapted string
 */
- (NSString*)stringByUnescapingFromURLArgument;

/**
 *  md5 encoding
 *
 *  @return lowercase encoding string
 */
- (NSString*)md5Encode;

/**
 *  md5 encoding
 *
 *  @return uppercase encoding string
 */
- (NSString*)MD5Encode;

@end

//
//  NSString+EnDeCoding.m
//  Being
//
//  Created by xiaofeng on 15/10/15.
//  Copyright © 2015年 Being Inc. All rights reserved.
//

#import "NSString+EnDeCoding.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (EnDeCoding)

- (NSString*)urlEncode {
    return [self stringByEscapingForURLArgument];
}

- (NSString*)urlDecode {
    return [self stringByUnescapingFromURLArgument];
}

- (NSString*)stringByEscapingForURLArgument {
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    CFStringRef escaped =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    NSString *res = [NSString stringWithString:(__bridge NSString *)(escaped)];
    CFRelease(escaped);
    return res;
}

- (NSString*)stringByUnescapingFromURLArgument {
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    [resultString replaceOccurrencesOfString:@"+"
                                  withString:@" "
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [resultString length])];
    return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (NSString*)md5Encode {
    return [[self MD5Encode] lowercaseString];
}

- (NSString*)MD5Encode {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    const char *cStr = [self cStringUsingEncoding:enc];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end

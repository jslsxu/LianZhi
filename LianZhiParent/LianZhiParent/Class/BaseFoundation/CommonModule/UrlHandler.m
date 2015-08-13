//
//  UrlHandler.m
//  LianZhiParent
//
//  Created by jslsxu on 15/2/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "UrlHandler.h"

@implementation UrlHandler

SYNTHESIZE_SINGLETON_FOR_CLASS(UrlHandler)
- (BOOL)processUrl:(NSString *)actionUrl
{
    if([actionUrl length] == 0)
        return NO;
    NSURL* hyperlink = [NSURL URLWithString:actionUrl];
    if (!hyperlink) {
        return NO;
    }
    
//    NSString *scheme = hyperlink.scheme;
    NSString *host = hyperlink.host;
    
    // get entryKey(host+path)
    NSString* entryKey = [NSString stringWithFormat:@"%@%@", host, hyperlink.path];
    if (!entryKey || [entryKey length] <= 0) {
        return NO;
    }
    
    // get entry class name
    NSString* entryClassName = [self.entryMap valueForKey:entryKey];
    if (!entryClassName || [entryClassName length] <= 0) {
        return NO;
    }
    return YES;
    
//    // make entry class
//    Class entryClass = NSClassFromString(entryClassName);
//    if(entryClass) {
//        
//    }

}
@end

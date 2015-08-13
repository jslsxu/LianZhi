//
//  UrlHandler.h
//  LianZhiParent
//
//  Created by jslsxu on 15/2/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UrlHandlerProtocol <NSObject>


@end

@interface UrlHandler : NSObject
@property (nonatomic, strong)NSDictionary *entryMap;
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(UrlHandler)
- (BOOL)processUrl:(NSString *)actionUrl;
@end

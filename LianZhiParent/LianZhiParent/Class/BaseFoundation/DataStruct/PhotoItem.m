//
//  PhotoItem.m
//  LianZhiParent
//
//  Created by jslsxu on 14/12/22.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PhotoItem.h"

#define kThumbnailUrl           @"small"
#define kMiddleUrl              @"middle"
#define kOriginalUrl            @"big"

@implementation PhotoItem

- (id)initWithDataWrapper:(TNDataWrapper *)dataWrapper
{
    self = [super init];
    if(self)
    {
        [self parseData:dataWrapper];
    }
    return self;
}

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{@"photoID" : @"id",
             };
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"user" : [UserInfo class]};
}
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"publishImageItem"];
}
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
    
}
//- (NSString *)big{
//    if([_big hasPrefix:@"/var/mobile"]){
//        NSInteger index = 0;
//        NSInteger homeIndex = 0;
//        for (NSInteger i = 0; i < _big.length; i++) {
//            NSString *s = [_big substringWithRange:NSMakeRange(i, 1)];
//            if([s isEqualToString:@"/"]){
//                index++;
//                if(index == 7){
//                    homeIndex = i;
//                    break;
//                }
//            }
//        }
//        NSString *relativePath = [_big substringFromIndex:homeIndex + 1];
//        return [NSHomeDirectory() stringByAppendingPathComponent:relativePath];
//    }
//    else{
//        return _big;
//    }
//}

@end

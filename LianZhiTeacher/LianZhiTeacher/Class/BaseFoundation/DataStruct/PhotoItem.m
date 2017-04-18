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
    return @[@"publishImageItem",@"image",
             @"", @""];
}
- (void)parseData:(TNDataWrapper *)dataWrapper
{
    [self modelSetWithJSON:dataWrapper.data];
    
}

- (BOOL)isLocal{
    return self.photoID.length == 0;
}

- (BOOL)isSame:(PhotoItem *)object{
    if([self.photoID isEqualToString:object.photoID]){
        return YES;
    }
    if([self.big isEqualToString:object.big]){
        return YES;
    }
    return NO;
}

- (NSString *)big{
    NSInteger spaceCount = iOS8Later ? 7 : 5;
    if([_big hasPrefix:@"/var/mobile"]){
        NSInteger index = 0;
        NSInteger homeIndex = 0;
        for (NSInteger i = 0; i < _big.length; i++) {
            NSString *s = [_big substringWithRange:NSMakeRange(i, 1)];
            if([s isEqualToString:@"/"]){
                index++;
                if(index == spaceCount){
                    homeIndex = i;
                    break;
                }
            }
        }
        NSString *relativePath = [_big substringFromIndex:homeIndex + 1];
        return [NSHomeDirectory() stringByAppendingPathComponent:relativePath];
    }
    else{
        return _big;
    }
}

- (NSString *)day{
    if([self.time length] > 10){
        return [self.time substringToIndex:10];
    }
    return self.time;
}

@end

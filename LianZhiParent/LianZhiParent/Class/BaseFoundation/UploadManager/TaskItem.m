//
//  TaskItem.m
//  LianZhiParent
//
//  Created by jslsxu on 15/3/25.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TaskItem.h"

#define kTaskFilePath               @"TaskFilePath"
#define kTargetUrl                  @"TargetUrl"
#define kParams                     @"Params"
#define kImagesData                 @"ImagesData"

NSString *const kTaskItemSuccessNotification = @"kTaskItemSuccessNotification";

@implementation TaskItem
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.targetUrl = [aDecoder decodeObjectForKey:kTargetUrl];
        self.params = [aDecoder decodeObjectForKey:kParams];
        self.images = [aDecoder decodeObjectForKey:kImagesData];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.targetUrl forKey:kTargetUrl];
    [aCoder encodeObject:self.params forKey:kParams];
    [aCoder encodeObject:self.images forKey:kImagesData];
}

- (void)startUpload
{
    Reachability* curReach = ApplicationDelegate.hostReach;
    NetworkStatus status = [curReach currentReachabilityStatus];
    if(status == ReachableViaWiFi || (status == ReachableViaWWAN && ![UserCenter sharedInstance].personalSetting.wifiSend))
    {
        [self.uploadTask cancel];
        self.uploadTask = [[HttpRequestEngine sharedInstance] makeSessionRequestFromUrl:self.targetUrl withParams:self.params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSArray *allkeys = self.images.allKeys;
            for (NSString *key in allkeys)
            {
                NSData *imagedata = self.images[key];
                [formData appendPartWithFileData:imagedata name:key fileName:key mimeType:@"image/jpeg"];
            }
        } completion:^(NSURLSessionDataTask *task, TNDataWrapper *responseObject) {
            [[TaskUploadManager sharedInstance] removeTask:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:kTaskItemSuccessNotification object:nil];
        } fail:^(NSString *errMsg) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startUpload];
            });
        }];
    }
}

@end

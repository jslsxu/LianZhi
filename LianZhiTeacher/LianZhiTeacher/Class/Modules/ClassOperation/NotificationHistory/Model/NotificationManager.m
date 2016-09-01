//
//  NotificationManager.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationManager.h"
#import "NotificationItem.h"
#import "NotificationDraftManager.h"
NSString *kNotificationManagerChangedNotification = @"NotificationManagerChanged";
NSString *kNotificationSendSuccessNotification = @"NotificationSendSuccessNotification";
NSString *kNewNotificationToSend = @"NewNotificationToSend";
@interface NotificationManager ()
@property (nonatomic, strong)NSMutableArray *notificationArray;
@end

@implementation NotificationManager
SYNTHESIZE_SINGLETON_FOR_CLASS(NotificationManager)

- (instancetype)init{
    self  = [super init];
    if(self){
        [self loadSendingData];
    }
    return self;
}

- (NSArray *)sendingNotificationArray{
    return self.notificationArray;
}

- (void)clearSendingList{
    [self.notificationArray removeAllObjects];
//    [[LZKVStorage userKVStorage] saveStorageValue:nil forKey:kSendingNotificationKey];
}

- (void)save{
//    [[LZKVStorage userKVStorage] saveStorageValue:self.sendingNotificationArray forKey:kSendingNotificationKey];
}

- (void)loadSendingData{
//    NSArray *sendingArray = [[LZKVStorage userKVStorage] storageValueForKey:kSendingNotificationKey];
//    self.notificationArray = [NSMutableArray arrayWithArray:sendingArray];
    self.notificationArray = [NSMutableArray array];
}

- (void)sendNotificationValueChanged{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationManagerChangedNotification object:nil];
}

- (void)addNotification:(NotificationSendEntity *)notificationSendEntity{
//    //判断网络，如果无网，则直接仿佛草稿箱,否则上传
//    YYReachability *reachability = [YYReachability reachability];
//    YYReachabilityStatus status = reachability.status;
//    if(status == YYReachabilityStatusNone){
//        [[NotificationDraftManager sharedInstance] addDraft:notificationSendEntity];
//        [ProgressHUD showHintText:@"网络异常，存入到草稿"];
//    }
//    else{
        @synchronized (self) {
            [self.notificationArray insertObject:notificationSendEntity atIndex:0];
            [notificationSendEntity sendWithProgress:^(CGFloat progress) {
                
            } success:^(NotificationItem *notification){
                [self.notificationArray removeObject:notificationSendEntity];
                if(notification){
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSendSuccessNotification object:nil userInfo:@{kNewNotificationToSend : notification}];
                }
            } fail:^{
                
            }];
            [self sendNotificationValueChanged];
        }
//    }
}

- (void)removeNotification:(NotificationSendEntity *)notificationSendEntity{
    @synchronized (self) {
        [self.notificationArray removeObject:notificationSendEntity];
//        [self save];
        [self sendNotificationValueChanged];
    }
}
@end

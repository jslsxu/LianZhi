//
//  NotificationManager.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationManager.h"
#import "NotificationItem.h"
#define kSendingNotificationKey         @"SendingNotification"
#define kSendedNotificationKey          @"SendedNotification"

NSString *kNotificationManagerChangedNotification = @"NotificationManagerChanged";

@interface NotificationManager ()
@property (nonatomic, strong)NSMutableArray*    sendingNotificationArray;
@property (nonatomic, strong)NSArray*           sendedNotificationArray;
@property (nonatomic, strong)NSMutableArray*    notificationArray;
@end

@implementation NotificationManager
SYNTHESIZE_SINGLETON_FOR_CLASS(NotificationManager)

- (instancetype)init{
    self  = [super init];
    if(self){
        [self loadSendingData];
        [self loadLocalData];
        [self requestNotificationRecord];
    }
    return self;
}

- (void)save{
    [[LZKVStorage userKVStorage] saveStorageValue:self.sendingNotificationArray forKey:kSendingNotificationKey];
}

- (void)loadSendingData{
    NSArray *sendingArray = [[LZKVStorage userKVStorage] storageValueForKey:kSendingNotificationKey];
    self.sendingNotificationArray = [NSMutableArray arrayWithArray:sendingArray];
}

- (void)loadLocalData{
    self.sendedNotificationArray = [[LZKVStorage userKVStorage] storageValueForKey:kSendedNotificationKey];
    
}

- (void)requestNotificationRecord{
    @weakify(self)
    [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/my_send_list" method:REQUEST_GET type:REQUEST_REFRESH withParams:nil observer:self completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        @strongify(self)
        self.sendedNotificationArray = [NotificationItem nh_modelArrayWithJson:[responseObject getDataWrapperForKey:@"list"].data];
        [[LZKVStorage userKVStorage] saveStorageValue:self.sendedNotificationArray forKey:kSendedNotificationKey];
    } fail:^(NSString *errMsg) {
    }];
}

- (void)sendNotificationValueChanged{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationManagerChangedNotification object:nil];
}
@end

//
//  HomeworkManager.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkManager.h"

NSString *kHomeworkManagerChangedNotification = @"HomeworkManagerChanged";
NSString *kHomeworkSendSuccessNotification = @"HomeworkSendSuccessNotification";
NSString *kNewHomeworkToSend = @"NewHomeworkToSend";
@interface HomeworkManager ()
@property (nonatomic, strong)NSMutableArray *homeworkArray;
@end

@implementation HomeworkManager
SYNTHESIZE_SINGLETON_FOR_CLASS(HomeworkManager)

- (instancetype)init{
    self  = [super init];
    if(self){
        [self loadSendingData];
    }
    return self;
}

- (NSArray *)sendingHomeworkArray{
    return self.homeworkArray;
}

- (void)clearSendingList{
    [self.homeworkArray removeAllObjects];
    //    [[LZKVStorage userKVStorage] saveStorageValue:nil forKey:kSendingNotificationKey];
}

- (void)save{
    //    [[LZKVStorage userKVStorage] saveStorageValue:self.sendingNotificationArray forKey:kSendingNotificationKey];
}

- (void)loadSendingData{
    //    NSArray *sendingArray = [[LZKVStorage userKVStorage] storageValueForKey:kSendingNotificationKey];
    //    self.notificationArray = [NSMutableArray arrayWithArray:sendingArray];
    self.homeworkArray = [NSMutableArray array];
}

- (void)sendNotificationValueChanged{
    [[NSNotificationCenter defaultCenter] postNotificationName:kHomeworkManagerChangedNotification object:nil];
}

- (void)addHomework:(HomeWorkEntity *)homeworkSendEntity{
    //    //判断网络，如果无网，则直接仿佛草稿箱,否则上传
    //    YYReachability *reachability = [YYReachability reachability];
    //    YYReachabilityStatus status = reachability.status;
    //    if(status == YYReachabilityStatusNone){
    //        [[NotificationDraftManager sharedInstance] addDraft:notificationSendEntity];
    //        [ProgressHUD showHintText:@"网络异常，存入到草稿"];
    //    }
    //    else{
    @synchronized (self) {
        [self.homeworkArray insertObject:homeworkSendEntity atIndex:0];
        [homeworkSendEntity sendWithProgress:^(CGFloat progress) {
            
        } success:^(HomeworkItem *homework){
            [self.homeworkArray removeObject:homeworkSendEntity];
            if(homework){
                [[NSNotificationCenter defaultCenter] postNotificationName:kHomeworkSendSuccessNotification object:nil userInfo:@{kNewHomeworkToSend : homework}];
            }
        } fail:^{
            
        }];
        [self sendNotificationValueChanged];
    }
    //    }
}

- (void)removeHomework:(HomeWorkEntity *)homeworkSendEntity{
    @synchronized (self) {
        [self.homeworkArray removeObject:homeworkSendEntity];
        //        [self save];
        [self sendNotificationValueChanged];
    }
}
@end


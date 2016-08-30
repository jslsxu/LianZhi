//
//  NotificationDraftManager.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/7.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationDraftManager.h"
NSString* kDraftNotificationChanged = @"DraftNotificationChanged";
#define kNotificationDraft     @"NotificationDraft"

@interface NotificationDraftManager ()
@property (nonatomic, strong)NSMutableArray *draftNotificationArray;
@end

@implementation NotificationDraftManager
SYNTHESIZE_SINGLETON_FOR_CLASS(NotificationDraftManager)
- (instancetype)init{
    self = [super init];
    if(self){
        NSArray *draft = [[LZKVStorage userKVStorage] storageValueForKey:kNotificationDraft];
        self.draftNotificationArray = [NSMutableArray arrayWithArray:draft];
    }
    return self;
}
- (void)addDraft:(NotificationSendEntity *)sendEntity{
    if(sendEntity){
        [self.draftNotificationArray insertObject:sendEntity atIndex:0];
        [[LZKVStorage userKVStorage] saveStorageValue:self.draftArray forKey:kNotificationDraft];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDraftNotificationChanged object:nil];
    }
}

- (void)removeDraft:(NotificationSendEntity *)sendEntity{
    [self.draftNotificationArray removeObject:sendEntity];
    [[LZKVStorage userKVStorage] saveStorageValue:self.draftArray forKey:kNotificationDraft];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDraftNotificationChanged object:nil];
}

- (void)updateDraft:(NotificationSendEntity *)sendEntity{
    if(sendEntity){
        for (NotificationSendEntity *entity in self.draftNotificationArray) {
            if([entity.clientID isEqualToString:sendEntity.clientID]){
                NSInteger index = [self.draftNotificationArray indexOfObject:entity];
                [self.draftNotificationArray replaceObjectAtIndex:index withObject:sendEntity];
                [[LZKVStorage userKVStorage] saveStorageValue:self.draftArray forKey:kNotificationDraft];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDraftNotificationChanged object:nil];
                return;
            }
        }
    }
}

- (NSArray *)draftArray{
    return self.draftNotificationArray;
}

- (void)clearDraft{
    [self.draftNotificationArray removeAllObjects];
    [[LZKVStorage userKVStorage] saveStorageValue:nil forKey:kNotificationDraft];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDraftNotificationChanged object:nil];
}
@end

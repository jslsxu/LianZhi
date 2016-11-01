//
//  HomeworkDraftManager.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkDraftManager.h"

NSString* kDraftHomeworkChanged = @"DraftHomeworkChanged";
#define kHomeworkDraft          @"HomeworkDraft"

@interface HomeworkDraftManager ()
@property (nonatomic, copy)NSString *userStoragePath;
@property (nonatomic, strong)NSMutableArray *draftHomeworkArray;
@end

@implementation HomeworkDraftManager

+ (instancetype)sharedInstance{
    static HomeworkDraftManager *draftManager = nil;
    @synchronized (self) {
        NSString *storagePath = [NHFileManager localCurrentUserStoragePath];
        
        if ([storagePath isEqualToString:draftManager.userStoragePath]) {
            return draftManager;
        }
        
        draftManager = [[HomeworkDraftManager alloc] init];
        [draftManager setUserStoragePath:storagePath];
    }
    return draftManager;
}
- (instancetype)init{
    self = [super init];
    if(self){
        NSArray *draft = [[LZKVStorage userKVStorage] storageValueForKey:kHomeworkDraft];
        self.draftHomeworkArray = [NSMutableArray arrayWithArray:draft];
    }
    return self;
}

- (BOOL)draftIn:(HomeWorkEntity *)homeworkEntity{
    for (HomeWorkEntity *entity in self.draftHomeworkArray) {
        if([entity.clientID isEqualToString:homeworkEntity.clientID]){
            return YES;
        }
    }
    return NO;
}
- (void)addDraft:(HomeWorkEntity *)sendEntity{
    if(sendEntity && ![self draftIn:sendEntity]){
        [self.draftHomeworkArray insertObject:sendEntity atIndex:0];
        [[LZKVStorage userKVStorage] saveStorageValue:self.draftArray forKey:kHomeworkDraft];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDraftHomeworkChanged object:nil];
    }
}

- (void)removeDraft:(HomeWorkEntity *)sendEntity{
    NSMutableArray *removedArray = [NSMutableArray array];
    for (HomeWorkEntity *entity in self.draftHomeworkArray) {
        if([sendEntity.clientID isEqualToString:entity.clientID]){
            [removedArray addObject:entity];
        }
    }
    if(removedArray.count > 0){
        [self.draftHomeworkArray removeObjectsInArray:removedArray];
        [[LZKVStorage userKVStorage] saveStorageValue:self.draftArray forKey:kHomeworkDraft];
        [[NSNotificationCenter defaultCenter] postNotificationName:kDraftHomeworkChanged object:nil];
    }
}

- (void)updateDraft:(HomeWorkEntity *)sendEntity{
    if(sendEntity){
        for (HomeWorkEntity *entity in self.draftHomeworkArray) {
            if([entity.clientID isEqualToString:sendEntity.clientID]){
                NSInteger index = [self.draftHomeworkArray indexOfObject:entity];
                [self.draftHomeworkArray replaceObjectAtIndex:index withObject:sendEntity];
                [[LZKVStorage userKVStorage] saveStorageValue:self.draftArray forKey:kHomeworkDraft];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDraftHomeworkChanged object:nil];
                return;
            }
        }
    }
}

- (NSArray *)draftArray{
    return self.draftHomeworkArray;
}

- (void)clearDraft{
    [self.draftHomeworkArray removeAllObjects];
    [[LZKVStorage userKVStorage] saveStorageValue:nil forKey:kHomeworkDraft];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDraftHomeworkChanged object:nil];
}
@end


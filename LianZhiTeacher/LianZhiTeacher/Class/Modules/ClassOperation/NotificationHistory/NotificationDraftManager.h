//
//  NotificationDraftManager.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/7.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "NotificationSendEntity.h"

extern NSString* kDraftNotificationChanged;
@interface NotificationDraftManager : TNBaseObject
+ (instancetype)sharedInstance;
- (NSArray *)draftArray;
- (void)addDraft:(NotificationSendEntity *)sendEntity;
- (void)removeDraft:(NotificationSendEntity *)sendEntity;
- (void)updateDraft:(NotificationSendEntity *)sendEntity;
- (void)clearDraft;
@end

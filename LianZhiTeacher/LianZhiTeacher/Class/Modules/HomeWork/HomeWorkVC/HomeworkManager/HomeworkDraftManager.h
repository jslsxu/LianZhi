//
//  HomeworkDraftManager.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/14.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"
#import "HomeWorkEntity.h"
extern NSString* kDraftHomeworkChanged;
@interface HomeworkDraftManager : TNBaseObject
+ (instancetype)sharedInstance;
- (NSArray *)draftArray;
- (void)addDraft:(HomeWorkEntity *)sendEntity;
- (void)removeDraft:(HomeWorkEntity *)sendEntity;
- (void)updateDraft:(HomeWorkEntity *)sendEntity;
- (void)clearDraft;

@end

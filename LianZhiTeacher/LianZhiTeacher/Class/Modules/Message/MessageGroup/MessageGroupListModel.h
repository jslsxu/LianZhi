//
//  MessageGroupListModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "MessageFromInfo.h"

@interface MessageGroupItem : TNModelItem
@property (nonatomic, strong)MessageFromInfo *fromInfo;
@property (nonatomic, assign)NSInteger msgNum;
@property (nonatomic, copy)NSString *formatTime;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, assign)BOOL soundOn;
@property (nonatomic, assign)BOOL im_at;
@end

@interface MessageGroupListModel : TNListModel
//@property (nonatomic, assign)BOOL canPublish;
@property (nonatomic, assign)BOOL hasNew;
@property (nonatomic, assign)BOOL playAlert;
@property (nonatomic, copy)void (^unreadNumChanged)(NSInteger notificationNum, NSInteger chatNum);
- (NSArray *)arrayForType:(BOOL)isNotification;
- (void)deleteItem:(NSString *)itemID;
@end

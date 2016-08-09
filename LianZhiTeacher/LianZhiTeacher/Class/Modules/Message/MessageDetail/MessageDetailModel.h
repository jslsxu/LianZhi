//
//  MessageDetailModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "VideoItem.h"
#import "MessageFromInfo.h"
@interface MessageDetailItem : TNModelItem
@property (nonatomic, copy)NSString *msgID;
@property (nonatomic, strong)UserInfo *author;
@property (nonatomic, copy)NSString *avatarUrl;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *timeStr;
@property (nonatomic, strong)NSArray *photos;
@property (nonatomic, strong)VideoItem *videoItem;
- (BOOL)hasPhoto;
- (BOOL)hasVideo;
- (BOOL)hasAudio;
@end

@interface MessageDetailModel : TNListModel
@property (nonatomic, copy)NSString *author;
@property (nonatomic, copy)NSString *avatarUrl;
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *minID;
@property (nonatomic, strong)MessageFromInfo*   fromInfo;
@end

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
@property (nonatomic, assign)ChatType type;
@property (nonatomic, strong)UserInfo *from_user;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, strong)AudioItem *voice;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *time_str;
@property (nonatomic, strong)NSArray *pictures;
@property (nonatomic, strong)VideoItem *video;
@property (nonatomic, assign)BOOL is_new;
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

//
//  MessageDetailItem.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/8/12.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"

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

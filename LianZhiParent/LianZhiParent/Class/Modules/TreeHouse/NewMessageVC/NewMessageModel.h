//
//  NewMessageModel.h
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

typedef NS_ENUM(NSInteger, FeedType)
{
    FeedTypeText = 1,
    FeedTypeAudio,
    FeedTypePhoto,
    FeedTypeFace
};

@interface FeedItem : TNModelItem
@property (nonatomic, copy)NSString *feedID;
@property (nonatomic, assign)NSInteger types;
@property (nonatomic, assign)FeedType feedType;
@property (nonatomic, copy)NSString *feedText;
@property (nonatomic, copy)NSString *feedAudio;
@property (nonatomic, copy)NSString *feedPhoto;
@end

@interface NewMessageItem : TNModelItem
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, copy)NSString *comment_content;
@property (nonatomic, copy)NSString *ctime;
@property (nonatomic, copy)NSString *lastID;
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, strong)FeedItem *feedItem;
@end

@interface NewMessageModel : TNListModel
@property (nonatomic, copy)NSString *lastID;
@end

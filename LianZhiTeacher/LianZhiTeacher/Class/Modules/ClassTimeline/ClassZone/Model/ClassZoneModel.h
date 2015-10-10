//
//  ClassZoneModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "ResponseModel.h"
@interface ClassZoneItem : TNModelItem
@property (nonatomic, copy)NSString *position;
@property (nonatomic, assign)CGFloat latitude;
@property (nonatomic, assign)CGFloat longitude;
@property (nonatomic, strong)UserInfo *userInfo;
@property (nonatomic, copy)NSString *itemID;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)NSMutableArray *photos;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *formatTime;
@property (nonatomic, assign)BOOL canEdit;
@property (nonatomic, assign)BOOL newSent;
@property (nonatomic, assign)BOOL isUploading;
@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, assign)BOOL delay;
@property (nonatomic, copy)NSString *savedPath;
@property (nonatomic, weak)AFHTTPRequestOperation *operation;
@property (nonatomic, strong)ResponseModel *responseModel;
- (BOOL)canSendDirectly;
@end

@interface ClassZoneModel : TNListModel
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, copy)NSString *newsPaper;
@property (nonatomic, copy)NSString *minID;
@property (nonatomic, assign)BOOL canEdit;
@end

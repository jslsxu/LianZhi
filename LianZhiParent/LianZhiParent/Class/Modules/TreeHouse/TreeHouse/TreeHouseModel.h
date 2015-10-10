//
//  TreeHouseModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/21.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "ResponseItem.h"

@interface TreehouseItem : TNModelItem
@property (nonatomic, copy)NSString *itemID;
@property (nonatomic, copy)NSString *time;//年月日
@property (nonatomic, copy)NSString *tag;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, copy)NSString *timeStr;//几小时前
@property (nonatomic, copy)NSString *position;
@property (nonatomic, assign)CGFloat longitude;
@property (nonatomic, assign)CGFloat latitude;
@property (nonatomic, strong)NSMutableArray *photos;
@property (nonatomic, strong)UserInfo* user;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, assign)NSInteger voiceTimeSpan;
@property (nonatomic, assign)BOOL canEdit;
@property (nonatomic, assign)BOOL newSend;
@property (nonatomic, assign)BOOL isUploading;
@property (nonatomic, strong)NSDictionary *params;
@property (nonatomic, assign)BOOL delay;
@property (nonatomic, copy)NSString *savedPath;
@property (nonatomic, weak)AFHTTPRequestOperation *uploadOperation;
@property (nonatomic, strong)ResponseModel *responseModel;
@property (nonatomic, assign)BOOL hasMore;
- (TagPrivilege)tagPrivilege;
- (BOOL)canSendDirectly;    //如果全是photoID，则不管网络状态
@end

@interface TreeHouseModel : TNListModel
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *minID;
@end

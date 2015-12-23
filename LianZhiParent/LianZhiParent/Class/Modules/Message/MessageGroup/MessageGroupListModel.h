//
//  MessageGroupListModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"
#import "MessageItem.h"

@interface MessageFromInfo : TNModelItem
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *label;
@property (nonatomic, copy)NSString *logoUrl;
@property (nonatomic, assign)ChatType type;
@property (nonatomic, strong)UIImage *logoImage;
@property (nonatomic, copy)NSString *from_obj_id;
@property (nonatomic, copy)NSString *mobile;
- (BOOL)isNotification;
@end

@interface MessageGroupItem : TNModelItem
@property (nonatomic, strong)MessageFromInfo *fromInfo;
@property (nonatomic, assign)NSInteger msgNum;
@property (nonatomic, copy)NSString *formatTime;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, assign)BOOL soundOn;
@end

@interface MessageGroupListModel : TNListModel
@end

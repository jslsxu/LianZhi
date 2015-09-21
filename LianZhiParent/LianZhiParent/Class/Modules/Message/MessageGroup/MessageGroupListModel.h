//
//  MessageGroupListModel.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

typedef NS_ENUM(NSInteger, MessageFromType){
    MessageFromTypeFromTeacher = 21,
    MessageFromTypeFromParents = 22,
    MessageFromTypeFromClass = 23,
};

@interface MessageFromInfo : TNModelItem
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *label;
@property (nonatomic, copy)NSString *logoUrl;
@property (nonatomic, assign)MessageFromType type;
@property (nonatomic, strong)UIImage *logoImage;
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

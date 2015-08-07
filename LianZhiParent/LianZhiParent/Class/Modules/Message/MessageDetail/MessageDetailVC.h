//
//  MessageDetailVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/24.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "MessageGroupListModel.h"
@interface MessageDetailVC : TNBaseTableViewController
@property (nonatomic, strong)MessageFromInfo *fromInfo;
+(void)handlePushAction:(NSString *)fromID fromType:(NSString *)fromType;
@end

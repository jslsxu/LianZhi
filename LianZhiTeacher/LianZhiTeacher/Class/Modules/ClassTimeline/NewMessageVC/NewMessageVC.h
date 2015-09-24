//
//  NewMessageVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/8/22.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"

typedef NS_ENUM(NSInteger, NewMessageType){
    NewMessageTypeClassZone = 0,
    NewMessageTypeTreeHouse
};

@interface NewMessageVC : TNBaseTableViewController
@property (nonatomic, assign)NewMessageType types;
@property (nonatomic, copy)NSString *objid;
@end

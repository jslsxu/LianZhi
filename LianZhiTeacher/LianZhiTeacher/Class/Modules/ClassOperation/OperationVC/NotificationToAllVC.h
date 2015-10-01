//
//  NotificationToAllVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface SentGroup : TNModelItem
@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, copy)NSString *groupName;
@property (nonatomic, assign)NSInteger sentNum;
@end

@interface SentTarget : TNModelItem
@property (nonatomic, strong)NSArray *classArray;
@property (nonatomic, strong)NSArray *groupArray;

@end

@interface NotificationItem : TNModelItem
@property (nonatomic, copy)NSString *notificationID;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, assign)NSInteger notificationType;
@property (nonatomic, strong)NSArray *photoArray;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, copy)NSString *ctime;
@property (nonatomic, assign)NSInteger sentNum;
@property (nonatomic, strong)SentTarget *sentTarget;
@end

@interface NotificationModel : TNListModel
@property (nonatomic, assign)NSInteger total;
@end

@interface NotificationCell : TNTableViewCell
{
    UIView* _sepLine;
}
@end

@interface NotificationToAllVC : TNBaseTableViewController
{
    
}
@end

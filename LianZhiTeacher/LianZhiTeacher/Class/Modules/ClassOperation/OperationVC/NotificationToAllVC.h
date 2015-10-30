//
//  NotificationToAllVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/30.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

extern NSString * kNotificationPublishNotification;

@interface SentClassInfo : TNModelItem
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSInteger sentNum;
@property (nonatomic, assign)NSInteger totalNum;
@property (nonatomic, copy)NSString *sendStr;
@end

@interface SentGroup : TNModelItem
@property (nonatomic, copy)NSString *groupID;
@property (nonatomic, copy)NSString *groupName;
@property (nonatomic, assign)NSInteger sentNum;
@property (nonatomic, assign)NSInteger totalNum;
@property (nonatomic, copy)NSString *sendStr;
@end

@interface SentTarget : TNModelItem
@property (nonatomic, strong)NSArray *classArray;
@property (nonatomic, strong)NSArray *managedClassArray;
@property (nonatomic, strong)NSArray *groupArray;
@property (nonatomic, strong)NSArray *targetArray;
@end

@interface NotificationItem : TNModelItem
@property (nonatomic, assign)BOOL isUploading;
@property (nonatomic, copy)NSString *tmpID;
@property (nonatomic, assign)BOOL isFinished;
@property (nonatomic, copy)NSString *notificationID;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, assign)NSInteger notificationType;
@property (nonatomic, strong)NSArray *photoArray;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, copy)NSString *ctime;
@property (nonatomic, assign)NSInteger sentNum;
@property (nonatomic, strong)SentTarget *sentTarget;

//
@property (nonatomic, strong)NSDictionary*  params;
@property (nonatomic, strong)NSArray *imageArray;
@end

@interface NotificationModel : TNListModel
@property (nonatomic, assign)NSInteger total;
@end

@interface NotificationCell : TNTableViewCell
{
    UILabel*    _contentLabel;
    UILabel*    _timeLabel;
    UIView*     _sepLine;
}
@end

@interface NotificationToAllVC : TNBaseTableViewController
{
    
}
@end

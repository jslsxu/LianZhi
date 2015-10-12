//
//  GrowthTimelineModel.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@interface GrowthTimelineItem : TNModelItem
@property (nonatomic, copy)NSString *growthID;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)StudentInfo *student;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *formatTime;
@property (nonatomic, copy)NSString *emotion;
@property (nonatomic, assign)NSInteger stoolNum;
@property (nonatomic, copy)NSString *temparature;
@property (nonatomic, assign)BOOL water;
@property (nonatomic, assign)BOOL sleep;


@end

@interface GrowthTimelineModel : TNListModel

@end

//
//  GrowthTimelineModelItem.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/19.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"

@interface GrowthTimelineModelItem : TNModelItem
@property (nonatomic, copy)NSString *growthID;
@property (nonatomic, strong)StudentInfo *studentInfo;
@property (nonatomic, copy)NSString *emotion;
@property (nonatomic, assign)NSInteger stoolNum;
@property (nonatomic, copy)NSString *temprature;
@property (nonatomic, assign)NSInteger  water;
@property (nonatomic, assign)CGFloat    sleep;
@property (nonatomic, copy)NSString*    comment;
@property (nonatomic, assign)BOOL       hasSent;
- (NSDictionary *)toDictionary;
@end

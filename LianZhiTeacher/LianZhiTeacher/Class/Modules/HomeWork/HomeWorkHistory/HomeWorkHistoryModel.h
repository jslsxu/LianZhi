//
//  HomeWorkHistoryModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@interface HomeWorkHistoryItem : TNModelItem
@property (nonatomic, copy)NSString *content;
@property (nonatomic, strong)PhotoItem *photoItem;
@property (nonatomic, strong)AudioItem *audioItem;

@end

@interface HomeWorkGroup : TNModelItem
@property (nonatomic, copy)NSString *dateStr;
@property (nonatomic, strong)NSArray *homeWorkArray;

@end

@interface HomeWorkHistoryModel : TNListModel

@end

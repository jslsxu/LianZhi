//
//  HomeWorkHistoryModel.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

typedef NS_ENUM(NSInteger, HomeworkType)
{
    HomeworkTypeNormal = 0,
    HomeworkTypePhoto = 1,
    HomeworkTypeAudio,
};

@interface HomeWorkHistoryItem : TNModelItem
@property (nonatomic, copy)NSString *homeworkId;
@property (nonatomic, assign)HomeworkType type;
@property (nonatomic, copy)NSString *courseName;
@property (nonatomic, copy)NSString *ctime;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, strong)NSArray *photoArray;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, assign)BOOL fav;
@end

@interface HomeWorkHistoryModel : TNListModel

@end

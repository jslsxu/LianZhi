//
//  HomeWorkListModel.h
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

typedef NS_ENUM(NSInteger, HomeworkType)
{
    HomeworkTypeNormal = 0,
    HomeworkTypePhoto = 1,
    HomeworkTypeAudio,
};

@interface HomeWorkItem : TNModelItem
@property (nonatomic, copy)NSString *homeworkId;
@property (nonatomic, assign)HomeworkType type;
@property (nonatomic, copy)NSString *courseName;
@property (nonatomic, assign)NSInteger ctime;
@property (nonatomic, copy)NSString *weekday;
@property (nonatomic, copy)NSString *timeStr;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, strong)NSArray *photoArray;
@property (nonatomic, strong)AudioItem *audioItem;
@property (nonatomic, assign)BOOL fav;
@property (nonatomic, copy)NSString*    teacherName;
@end

@interface HomeWorkListModel : TNListModel
@property (nonatomic, assign)BOOL has;
@property (nonatomic, copy)NSString *maxID;
@end

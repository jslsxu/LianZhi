//
//  HomeworkItem.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/1/6.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNModelItem.h"
typedef NS_ENUM(NSInteger, HomeworkType)
{
    HomeworkTypeNormal = 0,
    HomeworkTypePhoto = 1,
    HomeworkTypeAudio,
};

@interface TargetClass : TNModelItem
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, copy)NSString *className;
@property (nonatomic, assign)NSInteger total;
@property (nonatomic, assign)NSInteger publish;
@property (nonatomic, strong)NSArray *students;
@end

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
@end

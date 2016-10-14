//
//  HomeworkItem.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@interface HomeworkItem : TNBaseObject
@property (nonatomic, copy)NSString*    homeworkId;
@property (nonatomic, copy)NSString*    words;
@property (nonatomic, strong)VideoItem* video;
@property (nonatomic, strong)AudioItem* audio;
@property (nonatomic, strong)PhotoItem* photo;
@property (nonatomic, copy)NSString*    create_time;
@property (nonatomic, copy)NSString*    end_time;
@property (nonatomic, copy)NSString*    course;
@end

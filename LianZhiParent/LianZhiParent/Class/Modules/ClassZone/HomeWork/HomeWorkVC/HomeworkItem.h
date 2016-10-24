//
//  HomeworkItem.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/10.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@interface HomeworkItemAnswer : TNBaseObject
@property (nonatomic, copy)NSString*    aid;
@property (nonatomic, copy)NSString*    words;
@property (nonatomic, strong)AudioItem* voice;
@property (nonatomic, strong)NSArray<PhotoItem *>* pics;
@end

@interface HomeworkItem : TNBaseObject
@property (nonatomic, copy)NSString*    homeworkId;
@property (nonatomic, strong)UserInfo*  user;
@property (nonatomic, copy)NSString*    words;
@property (nonatomic, strong)AudioItem* voice;
@property (nonatomic, strong)NSArray* pictures;
@property (nonatomic, copy)NSString*    create_time;
@property (nonatomic, copy)NSString*    end_time;
@property (nonatomic, copy)NSString*    course;
@property (nonatomic, strong)HomeworkItemAnswer*   answer;
- (BOOL)hasPhoto;
- (BOOL)hasAudio;
@end

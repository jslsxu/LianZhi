//
//  HomeworkItem.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/17.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@interface HomeworkItem : TNBaseObject
@property (nonatomic, copy)NSString *hid;
@property (nonatomic, copy)NSString*    ctime;
@property (nonatomic, assign)BOOL       reply_coloe;
@property (nonatomic, assign)NSInteger  publish_num;
@property (nonatomic, assign)NSInteger  reply_num;
@property (nonatomic, assign)NSInteger  marking_num;
@property (nonatomic, assign)NSInteger  read_num;
@property (nonatomic, strong)NSArray<ClassInfo *>* classes;
@property (nonatomic, strong)AudioItem* voice;
@property (nonatomic, strong)NSArray<PhotoItem *>*  pics;
@property (nonatomic, copy)NSString*    words;
@end

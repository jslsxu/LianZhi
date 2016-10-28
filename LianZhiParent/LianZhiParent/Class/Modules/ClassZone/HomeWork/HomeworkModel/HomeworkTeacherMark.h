//
//  HomeworkTeacherMark.h
//  LianZhiTeacher
//  老师批阅
//  Created by qingxu zhou on 16/10/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

typedef NS_ENUM(NSInteger, MarkType){
    MarkTypeNone = 0,
    MarkTypeRight,
    MarkTypeHalfRight,
    MarkTypeWrong,
};
@interface HomeworkPhotoMark : TNBaseObject
@property (nonatomic, assign)MarkType markType;
@property (nonatomic, assign)CGFloat x;
@property (nonatomic, assign)CGFloat y;
@end

@interface HomeworkMarkItem : TNBaseObject
@property (nonatomic, strong)PhotoItem* picture;
@property (nonatomic, strong)NSArray<HomeworkPhotoMark *>* marks;
@end

@interface HomeworkTeacherMark : TNBaseObject
@property (nonatomic, copy)NSString*    comment;        //评语
@property (nonatomic, strong)NSArray<HomeworkMarkItem *>* marks;
+ (HomeworkTeacherMark *)markWithString:(NSString *)markDetail;
@end

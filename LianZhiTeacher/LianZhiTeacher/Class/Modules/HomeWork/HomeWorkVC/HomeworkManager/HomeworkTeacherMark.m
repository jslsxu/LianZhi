//
//  HomeworkTeacherMark.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkTeacherMark.h"

@implementation HomeworkPhotoMark


@end

@implementation HomeworkMarkItem
- (instancetype)init{
    self = [super init];
    if(self){
        PhotoItem *photoItem = [[PhotoItem alloc] init];
        photoItem.photoID = @"123";
        photoItem.width = 700;
        photoItem.height = 1050;
        photoItem.big = @"http://cdn.duitang.com/uploads/item/201410/19/20141019132733_yfaT4.thumb.700_0.jpeg";
        self.picture = photoItem;
        
    }
    return self;
}

- (void)addMark:(HomeworkPhotoMark *)photoMark{
    if(photoMark){
        NSMutableArray *markArray = [NSMutableArray arrayWithArray:self.marks];
        [markArray addObject:photoMark];
        self.marks = markArray;
    }
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"marks" : [HomeworkPhotoMark class]};
}
@end

@implementation HomeworkTeacherMark
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"marks" : [HomeworkMarkItem class]};
}

+ (HomeworkTeacherMark *)markWithString:(NSString *)markDetail{
    HomeworkTeacherMark *teacherMark = [[HomeworkTeacherMark alloc] init];
    [teacherMark modelSetWithJSON:markDetail];
    return teacherMark;
}
@end

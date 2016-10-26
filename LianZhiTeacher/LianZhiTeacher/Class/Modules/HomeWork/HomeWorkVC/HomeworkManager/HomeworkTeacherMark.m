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
- (instancetype)initWithPhoto:(PhotoItem *)photoItem{
    self = [super init];
    if(self){
        self.picture = photoItem;
        self.marks = [NSMutableArray array];
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

- (BOOL)isEmpty{
    if([self.marks count] > 0){
        return NO;
    }
    return YES;
}

+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"marks" : [HomeworkPhotoMark class]};
}
@end

@implementation HomeworkTeacherMark

- (instancetype)initWithPhotoArray:(NSArray *)photoArray{
    self = [super init];
    if(self){
        self.marks = [NSMutableArray array];
        for (NSInteger i = 0; i < photoArray.count; i++) {
            [self.marks addObject:[[HomeworkMarkItem alloc] initWithPhoto:photoArray[i]]];
        }
    }
    return self;
}
+ (NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"marks" : [HomeworkMarkItem class]};
}

+ (HomeworkTeacherMark *)markWithString:(NSString *)markDetail{
    HomeworkTeacherMark *teacherMark = [[HomeworkTeacherMark alloc] init];
    [teacherMark modelSetWithJSON:markDetail];
    return teacherMark;
}

- (BOOL)isEmpty{
    if([self.comment length] > 0){
        return NO;
    }
    if([self.marks count] > 0){
        for (HomeworkMarkItem* markItem in self.marks) {
            if(![markItem isEmpty]){
                return NO;
            }
        }
    }
    return YES;
}
@end

//
//  StudentsAttendanceListModel.m
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "StudentsAttendanceListModel.h"

@implementation AttendanceNoteItem

- (instancetype)init{
    self = [super init];
    if(self){
        self.time = @"08:05";
        self.note = @"陈琦的妈妈请假，备注:不去幼儿园了明年也是我的本命年按，我要更加努力了，感谢楼主分享";
    }
    return self;
}
@end

@implementation StudentAttendanceItem

- (instancetype)init{
    self = [super init];
    if(self){
        self.studentInfo = [[StudentInfo alloc] init];
        [self.studentInfo setAvatar:@"https://www.baidu.com/s?wd=美女图片库&rsv_idx=2&tn=baiduhome_pg&usm=3&ie=utf-8&rsv_cq=图片&rsv_dl=0_right_recommends_merge_20826&euri=2853269"];
        [self.studentInfo setName:@"朱见深"];
        
        self.attendance = arc4random() % 2;
        self.comment = @"明年也是我的本命年按，我要更加努力了，感谢楼主分享明年也是我的本命年按，我要更加努力了，感谢楼主分享";
        NSMutableArray* noteArray = [NSMutableArray array];
        for (NSInteger i = 0; i < arc4random() % 10; i++) {
            AttendanceNoteItem* noteItem = [[AttendanceNoteItem alloc] init];
            [noteArray addObject:noteItem];
        }
        self.notes = noteArray;
    }
    return self;
}
@end

@implementation StudentsAttendanceListModel
- (instancetype)init{
    self = [super init];
    if(self){
        for (NSInteger i = 0; i < 20; i++) {
            StudentAttendanceItem* item = [[StudentAttendanceItem alloc] init];
            [self.modelItemArray addObject:item];
        }
    }
    return self;
}

- (NSInteger)numOfSections{
    return [self.modelItemArray count];
}

- (NSInteger)numOfRowsInSection:(NSInteger)section{
    return 1;
}

- (TNModelItem *)itemForIndexPath:(NSIndexPath *)indexPath{
    return self.modelItemArray[indexPath.section];
}
@end

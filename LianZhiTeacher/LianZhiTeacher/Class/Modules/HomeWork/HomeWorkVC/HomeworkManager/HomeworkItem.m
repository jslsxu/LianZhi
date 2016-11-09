//
//  HomeworkItem.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/17.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeworkItem.h"

@implementation HomeworkStudentInfo

@end

@implementation HomeworkClassStatus

+ (NSDictionary<NSString *, id>*)modelCustomPropertyMapper{
    return @{@"classID" : @"class_info.id",
             @"name" : @"class_info.name",
             @"logo" : @"class_info.logo",
             @"students" : @"child_ids"};
}

+ (NSDictionary<NSString *,id>*)modelContainerPropertyGenericClass{
    return @{@"students" : [HomeworkStudentInfo class]};
}

- (BOOL)hasUnread{
    BOOL unread_t = NO;
    for (HomeworkStudentInfo *studentInfo in self.students) {
        if(studentInfo.unread_t){
            unread_t = YES;
        }
    }
    return unread_t;
}

@end

@implementation HomeworkItemAnswer
- (instancetype)init{
    self = [super init];
    if(self){
//        self.words = @"最新最全最大的桌酷壁纸站提供桌面壁纸、圣诞壁纸、精美壁纸、手机壁纸、宽屏壁纸、动漫壁纸、卡通壁纸、电脑壁纸、美女壁纸、风景壁纸、壁纸下载等等精彩内容。";
//        AudioItem *audioItem = [[AudioItem alloc] init];
//        audioItem.audioUrl = @"";
//        audioItem.timeSpan = 23;
//        self.voice = audioItem;
//        NSMutableArray *photoArray = [NSMutableArray array];
//        for (NSInteger i = 0; i < 4; i++) {
//            PhotoItem *photoItem = [[PhotoItem alloc] init];
//            photoItem.photoID = kStringFromValue(arc4random() % 10000);
//            photoItem.big = @"https://ss1.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/image/h%3D200/sign=04d308e12e9759ee555067cb82fa434e/902397dda144ad3455abeb6bd8a20cf430ad85c1.jpg";
//            photoItem.width = 320;
//            photoItem.height = 200;
//            [photoArray addObject:photoItem];
//        }
//        self.pics = photoArray;

    }
    return self;
}

+ (NSDictionary<NSString *, id>*)modelContainerPropertyGenericClass{
    return @{@"pics" : [PhotoItem class]};
}

@end

@implementation HomeworkItem

+ (NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"voice" : @"question.voice",
             @"pics" : @"question.pics",
             @"words" : @"question.words"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"pics" : [PhotoItem class],
             @"classes" : [HomeworkClassStatus class]};
}

- (BOOL)hasImage{
    return self.pics.count > 0;
}

- (BOOL)hasAudio{
    return self.voice != nil;
}
@end

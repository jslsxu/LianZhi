//
//  NotificationSendEntity.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/20.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "NotificationSendEntity.h"
#import "AFURLRequestSerialization.h"

@interface NotificationSendEntity ()
@property (nonatomic, weak)AFHTTPRequestOperation *operation;
@end
@implementation NotificationSendEntity

+ (NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"operation", @"uploadProgress", @"targets"];
}

+ (NotificationSendEntity *)sendEntityWithNotification:(NotificationItem *)notification{
    NotificationSendEntity *sendEntity = [[NotificationSendEntity alloc] init];
    sendEntity.words = notification.words;
    sendEntity.sendSms = notification.sms;
    if(notification.hasVideo){
        sendEntity.videoArray = [NSMutableArray arrayWithObject:notification.video];
    }
    if(notification.hasImage){
        sendEntity.imageArray = [NSMutableArray arrayWithArray:notification.pictures];
    }
    if(notification.hasAudio){
        sendEntity.voiceArray = [NSMutableArray arrayWithObject:notification.voice];
    }
    return sendEntity;
}


- (instancetype)init{
    self = [super init];
    if(self){
        self.sendSms = YES;
        self.classArray = [NSMutableArray array];
        self.groupArray = [NSMutableArray array];
        self.voiceArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        self.videoArray = [NSMutableArray array];
        self.authorUser = [UserCenter sharedInstance].userInfo;
        self.createTime = [[NSDate date] timeIntervalSince1970];
        [self updateClientID];
    }
    return self;
}

- (void)updateClientID{
    self.clientID = [NSString stringWithFormat:@"%zd_%zd",[[NSDate date] timeIntervalSince1970], arc4random() % 1000];
}

- (NSString *)delaySendTimeStr{
    NSString *dateStr = nil;
    if(self.delaySendTime > 0){
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.delaySendTime];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd HH:mm"];
        dateStr = [formater stringFromDate:date];
    }
    return dateStr;
}

- (NSInteger)maxCommentWordsNum{
    if(self.sendSms){
        return 150;
    }
    else{
        return 500;
    }
}

- (BOOL)hasVideo{
    return self.videoArray.count > 0;
}

- (BOOL)hasImage{
    return self.imageArray.count > 0;
}

- (BOOL)hasAudio{
    return self.voiceArray.count > 0;
}

- (NSMutableArray *)targets{
    NSMutableArray *targetArray = [NSMutableArray array];
    for (ClassInfo *classInfo in self.classArray) {
        for (StudentInfo *studentInfo in classInfo.students) {
            if(studentInfo.selected && ![self targets:targetArray contains:studentInfo.uid]){
                [targetArray addObject:studentInfo];
            }
        }
    }
    for (TeacherGroup *teacherGroup in self.groupArray) {
        for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
            if(teacherInfo.selected && ![self targets:targetArray contains:teacherInfo.uid]){
                [targetArray addObject:teacherInfo];
            }
        }
    }
    if(targetArray.count)
        return targetArray;
    return nil;
}

- (BOOL)targets:(NSArray *)targets contains:(NSString *)uid{
    for (UserInfo *userInfo in targets) {
        if([userInfo.uid isEqualToString:uid]){
            return YES;
        }
    }
    return NO;
}

- (void)removeTarget:(UserInfo *)userInfo{
    for (ClassInfo *classInfo in self.classArray) {
        for (StudentInfo *studentInfo in classInfo.students) {
            if([studentInfo.uid isEqualToString:userInfo.uid]){
                studentInfo.selected = NO;
            }
        }
    }
    for (TeacherGroup *teacherGroup in self.groupArray) {
        for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
            if([teacherInfo.uid isEqualToString:userInfo.uid]){
                teacherInfo.selected = NO;
            }
        }
    }
}



- (void)sendWithProgress:(void (^)(CGFloat))progress success:(void (^)(NotificationItem *notification))success fail:(void (^)())fail{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *classesArray = [NSMutableArray array];
    for (ClassInfo *classInfo in self.classArray) {
        NSMutableDictionary *classDic = [NSMutableDictionary dictionary];
//        if(classInfo.selectedType == SelectedTypeAll){
//            [classDic setValue:classInfo.classID forKey:@"classid"];
//        }
//        else{
            NSMutableArray *selectedStudents = [NSMutableArray array];
            for (StudentInfo *studentInfo in classInfo.students) {
                if(studentInfo.selected){
                    [selectedStudents addObject:studentInfo.uid];
                }
            }
            if(selectedStudents.count > 0){
                [classDic setValue:classInfo.classID forKey:@"classid"];
                [classDic setValue:selectedStudents forKey:@"students"];
            }
//        }
        if(classDic.count > 0){
            [classesArray addObject:classDic];
        }
    }
    
    NSMutableArray *groupsArray = [NSMutableArray array];
    for (TeacherGroup *teacherGroup in self.groupArray) {
        NSMutableDictionary *groupDic = [NSMutableDictionary dictionary];
//        if(teacherGroup.selectedType == SelectedTypeAll){
//            [groupDic setValue:teacherGroup.groupID forKey:@"id"];
//        }
//        else{
            NSMutableArray *selectedTeachers = [NSMutableArray array];
            for (TeacherInfo *teacherInfo in teacherGroup.teachers) {
                if(teacherInfo.selected){
                    [selectedTeachers addObject:teacherInfo.uid];
                }
            }
            if(selectedTeachers.count > 0){
                [groupDic setValue:teacherGroup.groupID forKey:@"id"];
                [groupDic setValue:selectedTeachers forKey:@"teachers"];
            }
//        }
        if(groupDic.count > 0){
            [groupsArray addObject:groupDic];
        }
    }
    if(classesArray.count == 0 && groupsArray.count == 0){
        [ProgressHUD showHintText:@"没有选择发送对象"];
        return;
    }
    [params setValue:[NSString stringWithJSONObject:classesArray] forKey:@"classes"];
    [params setValue:[NSString stringWithJSONObject:groupsArray] forKey:@"groups"];
    [params setValue:self.words forKey:@"words"];
    [params setValue:kStringFromValue(self.sendSms) forKey:@"sms"];
    if(self.delaySend){
        [params setValue:kStringFromValue(self.delaySendTime) forKey:@"time_to_send"];
    }
    if(self.videoArray.count > 0){
        VideoItem *videoItem = self.videoArray[0];
        [params setValue:kStringFromValue(videoItem.videoTime) forKey:@"video_time"];
    }
    if(self.imageArray.count > 0)
    {
        NSMutableString *picSeq = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < self.imageArray.count; i++)
        {
            PhotoItem *photoItem = self.imageArray[i];
            if(photoItem.photoID.length > 0){
                [picSeq appendString:[NSString stringWithFormat:@"%@,",photoItem.photoID]];
            }
            else{
                [picSeq appendFormat:@"picture_%ld,",(long)i];
            }
        }
        [params setValue:picSeq forKey:@"pic_seqs"];
    }
    
    if(self.voiceArray.count > 0){
        AudioItem *audioItem = self.voiceArray[0];
        if(audioItem.isLocal){
            [params setValue:kStringFromValue(audioItem.timeSpan) forKey:@"voice_time"];
        }
        else{
            [params setValue:audioItem.audioID forKey:@"voice_id"];
        }
    }
    if(self.videoArray.count > 0){
        VideoItem *videoItem = self.videoArray[0];
        if(!videoItem.isLocal){
            [params setValue:videoItem.videoID forKey:@"video_id"];
        }
    }
    
    self.operation = [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"notice/send" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSInteger i = 0; i < self.imageArray.count; i++)
        {
            PhotoItem *photoItem = self.imageArray[i];
            NSString *filename = [NSString stringWithFormat:@"picture_%ld",(long)i];
            if(photoItem.photoID.length > 0){
                
            }
            else{
                NSData *data = [NSData dataWithContentsOfFile:photoItem.big];
                if(data.length > 0){
                    [formData appendPartWithFileData:data name:filename fileName:filename mimeType:@"image/jpeg"];
                }
            }
        
        }
        if(self.voiceArray.count > 0){
            AudioItem *audioItem = self.voiceArray[0];
            if(audioItem.isLocal){
                NSData *voiceData = [NSData dataWithContentsOfFile:audioItem.audioUrl];
                [formData appendPartWithFileData:voiceData name:@"voice" fileName:@"voice" mimeType:@"audio/AMR"];
            }
        }
        if(self.videoArray.count > 0){
            VideoItem *videoItem = self.videoArray[0];
            if(videoItem.isLocal){
                NSData *videoData = [NSData dataWithContentsOfFile:videoItem.videoUrl];
                if(videoData){
                    [formData appendPartWithFileData:videoData name:@"video" fileName:@"video" mimeType:@"application/octet-stream"];
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(videoItem.coverImage, 0.8) name:@"video_cover" fileName:@"video_cover" mimeType:@"image/jpeg"];
                }
            }
        }
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
        TNDataWrapper *notificationWraper = [responseObject getDataWrapperForKey:@"info"];
        NotificationItem *notificationItem = [NotificationItem nh_modelWithJson:notificationWraper.data];
        if(success){
            success(notificationItem);
        }
    } fail:^(NSString *errMsg) {
//        [ProgressHUD showHintText:errMsg];
        if(fail){
            fail();
        }
    }];
    [self.operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        CGFloat uploadProgress = totalBytesWritten * 1.f / totalBytesExpectedToWrite;
//        NSLog(@"progress is %f",uploadProgress);
//        if(progress){
//            progress(uploadProgress);
//        }
        self.uploadProgress = uploadProgress;
    }];
}

- (void)cancelSend{
    [self.operation cancel];
    self.operation = nil;
}

- (BOOL)isSame:(NotificationSendEntity *)object{
    if(self.words.length + object.words.length > 0 && ![self.words isEqualToString:object.words]){
        return NO;
    }
    if(self.sendSms != object.sendSms){
        return NO;
    }
    for (UserInfo *userInfo in self.targets) {
        BOOL isIn = NO;
        for (UserInfo *user in object.targets) {
            if([userInfo.uid isEqualToString:user.uid]){
                isIn = YES;
            }
        }
        if(!isIn){
            return NO;
        }
    }
    if(self.videoArray.count != object.videoArray.count){
        return NO;
    }
    for (VideoItem *videoItem in self.videoArray) {
        BOOL isIn = NO;
        for (VideoItem *video in object.videoArray) {
            if([videoItem isSame:video]){
                isIn = YES;
            }
        }
        if(!isIn){
            return NO;
        }
    }
    if(self.voiceArray.count != object.voiceArray.count){
        return NO;
    }
    for (AudioItem *audioItem in self.voiceArray) {
        BOOL isIn = NO;
        for (AudioItem *audio in object.voiceArray) {
            if([audioItem isSame:audio]){
                isIn = YES;
            }
        }
        if(!isIn){
            return NO;
        }
    }
    
    if(self.imageArray.count != object.imageArray.count){
        return NO;
    }
    
    for (PhotoItem *photoItem in self.imageArray) {
        BOOL isIn = NO;
        for (PhotoItem *photo in object.imageArray) {
            if([photoItem isSame:photo]){
                isIn = YES;
            }
        }
        if(!isIn){
            return NO;
        }
    }
    
    return YES;
}

@end

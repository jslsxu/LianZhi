//
//  HomeWorkEntity.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeWorkEntity.h"
#import "HomeworkSettingManager.h"
#import "HomeworkDraftManager.h"
#import "HomeworkManager.h"
#import "CourseSelectVC.h"
@interface HomeWorkEntity ()
@property (nonatomic, weak)AFHTTPRequestOperation *operation;
@end
@implementation HomeWorkEntity

+ (NSArray<NSString *> *)modelPropertyBlacklist{
    return @[@"operation", @"uploadProgress"];
}
- (instancetype)init{
    self = [super init];
    if(self){
        HomeworkSetting *setting = [[HomeworkSettingManager sharedInstance] getHomeworkSetting];
        self.count = setting.homeworkNum;
        self.etype = setting.etype;
        self.course_name = [CourseSelectVC defaultCourse];
        self.targets = [NSMutableArray array];
        self.voiceArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        [self updateClientID];
        self.createTime = [[NSDate date] timeIntervalSince1970];
        self.sendSms = setting.sendSms;
        self.reply_close = setting.replyEndOn;
        if(self.reply_close){
            self.reply_close_ctime = setting.replyEndTime;
            if([self.reply_close_ctime length] == 0){
                NSDate *date = [[NSDate date] dateByAddingDays:1];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd 10:00:00"];
                NSString *endTime = [dateFormatter stringFromDate:date];
                self.reply_close_ctime = endTime;
            }
        }
    }
    return self;
}

+ (HomeWorkEntity *)sendEntityWithHomeworkItem:(HomeworkItem *)homeworkItem{
    HomeWorkEntity *homeworkEntity = [[HomeWorkEntity alloc] init];
    [homeworkEntity setEid:homeworkItem.eid];
    [homeworkEntity setCount:homeworkItem.enums];
    [homeworkEntity setEtype:homeworkItem.etype];
    [homeworkEntity setSendSms:homeworkItem.sms];
    [homeworkEntity setCourse_name:homeworkItem.course_name];
    if(homeworkItem.voice){
        [homeworkEntity setVoiceArray:[NSMutableArray arrayWithObject:homeworkItem.voice]];
    }
    [homeworkEntity setImageArray:[NSMutableArray arrayWithArray:homeworkItem.pics]];
    [homeworkEntity setWords:homeworkItem.words];
//    [homeworkEntity setCreateTime:homeworkItem.ctime];
    [homeworkEntity setReply_close:homeworkItem.reply_close];
    if(homeworkEntity.reply_close){
        NSDate *date = [[NSDate date] dateByAddingDays:1];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd 10:00:00"];
        NSString *endTime = [dateFormatter stringFromDate:date];
        [homeworkEntity setReply_close_ctime:endTime];
    }
    else{
        [homeworkEntity setReply_close_ctime:nil];
    }
    
    if(homeworkItem.answer){
        HomeworkItemAnswer *answer = homeworkItem.answer;
        HomeworkExplainEntity *answerEntity = [[HomeworkExplainEntity alloc] init];
        [answerEntity setWords:answer.words];
        if(answer.voice){
            [answerEntity setVoiceArray:[NSMutableArray arrayWithObject:answer.voice]];
        }
        if([answer.pics count] > 0){
            [answerEntity setImageArray:[NSMutableArray arrayWithArray:answer.pics]];
        }
        [homeworkEntity setExplainEntity:answerEntity];
    }
    
    return homeworkEntity;
}

- (void)updateClientID{
    self.clientID = [NSString stringWithFormat:@"%zd_%zd",[[NSDate date] timeIntervalSince1970], arc4random() % 1000];
}

- (void)setEtype:(BOOL)etype{
    _etype = etype;
    if(!_etype){//不能回复
        self.reply_close = NO;
        self.reply_close_ctime = nil;
    }
}

- (NSInteger)maxCommentWordsNum{
    return 500;
}

- (void)removeTarget:(ClassInfo *)classInfo{
    NSMutableArray *tmpTargetArray = [NSMutableArray array];
    for (ClassInfo *classItem in self.targets) {
        if(![classInfo.classID isEqualToString:classItem.classID]){
            [tmpTargetArray addObject:classItem];
        }
    }
    [self setTargets:tmpTargetArray];
}

- (BOOL)hasImage{
    return self.imageArray.count > 0;
}

- (BOOL)hasAudio{
    return self.voiceArray.count > 0;
}


- (void)sendWithProgress:(void (^)(CGFloat))progress success:(void (^)(HomeworkItem *))success fail:(void (^)())fail{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(self.targets.count == 0){
        [ProgressHUD showHintText:@"没有选择发送对象"];
        return;
    }
    NSMutableString *classIDString = [NSMutableString string];
    for (ClassInfo *classInfo in self.targets) {
        if(classIDString.length > 0){
            [classIDString appendString:[NSString stringWithFormat:@",%@",classInfo.classID]];
        }
        else{
            [classIDString appendString:classInfo.classID];
        }
    }
    [params setValue:classIDString forKey:@"class_ids"];
    [params setValue:kStringFromValue(self.etype) forKey:@"etype"];
    [params setValue:kStringFromValue(self.sendSms) forKey:@"sms"];
    [params setValue:self.explainEntity.words forKey:@"answer_words"];
    
    if(self.etype){
        [params setValue:kStringFromValue(self.reply_close) forKey:@"reply_close"];
        [params setValue:self.reply_close_ctime forKey:@"reply_close_ctime"];
    }
    if(self.forward){//如果是转发
        if([self.eid length] > 0){
            [params setValue:self.eid forKey:@"forward_eid"];
        }
    }
    else{
        if([self.words length] == 0){
            [params setValue:@"作业练习" forKey:@"words"];
        }
        else{
            [params setValue:self.words forKey:@"words"];
        }
        [params setValue:self.course_name forKey:@"course_name"];
        [params setValue:kStringFromValue(self.count) forKey:@"enums"];
        if(self.imageArray.count > 0)
        {
            NSMutableString *picSeq = [[NSMutableString alloc] init];
            for (NSInteger i = 0; i < self.imageArray.count; i++)
            {
                PhotoItem *photoItem = self.imageArray[i];
                if(photoItem.photoID.length > 0){
                    if(picSeq.length == 0){
                        [picSeq appendString:photoItem.photoID];
                    }
                    else{
                        [picSeq appendString:[NSString stringWithFormat:@",%@",photoItem.photoID]];
                    }
                }
                else{
                    if(picSeq.length == 0){
                        [picSeq appendFormat:@"picture_%ld",(long)i];
                    }
                    else{
                        [picSeq appendFormat:@",picture_%ld",(long)i];
                    }
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

    }
    
    //作业解析
    if([self.explainEntity.imageArray count] > 0){
        NSMutableString *picSeq = [[NSMutableString alloc] init];
        for (NSInteger i = 0; i < self.explainEntity.imageArray.count; i++)
        {
            PhotoItem *photoItem = self.explainEntity.imageArray[i];
            if(photoItem.photoID.length > 0){
                if(picSeq.length == 0){
                    [picSeq appendString:photoItem.photoID];
                }
                else{
                    [picSeq appendString:[NSString stringWithFormat:@",%@",photoItem.photoID]];
                }
            }
            else{
                if(picSeq.length == 0){
                    [picSeq appendFormat:@"answer_picture_%ld",(long)i];
                }
                else{
                    [picSeq appendFormat:@",answer_picture_%ld",(long)i];
                }
            }
        }
        
        [params setValue:picSeq forKey:@"answer_pic_seqs"];
    }
    
    //解析
    if([self.explainEntity.voiceArray count] > 0){
        AudioItem *audioItem = self.explainEntity.voiceArray[0];
        [params setValue:kStringFromValue(audioItem.timeSpan) forKey:@"answer_voice_time"];
        if(!audioItem.isLocal){
            [params setValue:audioItem.audioID forKey:@"answer_voice_id"];
        }
    }
    
    NSString *url = self.forward ? @"exercises/forward" : @"exercises/publish";
    __weak typeof(self) wself = self;
    self.operation = [[HttpRequestEngine sharedInstance] makeRequestFromUrl:url withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(wself.forward){
            
        }
        else{
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
        }
        
        for (NSInteger i = 0; i < [self.explainEntity.imageArray count]; i++) {
            PhotoItem *photoItem = self.explainEntity.imageArray[i];
            NSString *filename = [NSString stringWithFormat:@"answer_picture_%ld",(long)i];
            if(photoItem.photoID.length > 0){
                
            }
            else{
                NSData *data = [NSData dataWithContentsOfFile:photoItem.big];
                if(data.length > 0){
                    [formData appendPartWithFileData:data name:filename fileName:filename mimeType:@"image/jpeg"];
                }
            }
        }

        if([self.explainEntity.voiceArray count] > 0){
            AudioItem *audioItem = self.explainEntity.voiceArray[0];
            if(audioItem.isLocal){
                NSData *voiceData = [NSData dataWithContentsOfFile:audioItem.audioUrl];
                [formData appendPartWithFileData:voiceData name:@"answer_voice" fileName:@"answer_voice" mimeType:@"audio/AMR"];
            }
        }
    
    } completion:^(AFHTTPRequestOperation *operation, TNDataWrapper *responseObject) {
//        TNDataWrapper *notificationWraper = [responseObject getDataWrapperForKey:@"info"];
        HomeworkItem *homeworkItem = [HomeworkItem nh_modelWithJson:responseObject.data];
        if(success){
            success(homeworkItem);
        }
    } fail:^(NSString *errMsg) {
        //        [ProgressHUD showHintText:errMsg];
        [[HomeworkDraftManager sharedInstance] addDraft:self];
        [[HomeworkManager sharedInstance] removeHomework:self];
        [ProgressHUD showHintText:@"上传失败，存入到草稿"];
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

- (BOOL)isSame:(HomeWorkEntity *)object{
    if(self.course_name.length + object.course_name.length > 0 && ![self.course_name isEqualToString:object.course_name]){
        return NO;
    }
    if(self.count != object.count){
        return NO;
    }
    if(self.reply_close != object.reply_close){
        return NO;
    }
    else if(self.reply_close_ctime.length + object.reply_close_ctime.length > 0 && ![self.reply_close_ctime isEqualToString:object.reply_close_ctime]){
        return NO;
    }
    
    if(self.sendSms != object.sendSms){
        return NO;
    }
    
    if((self.explainEntity && !object) || (!self.explainEntity && object) || ![self.explainEntity isSame:object.explainEntity]){
        return NO;
    }
    
    if(self.words.length + object.words.length > 0 && ![self.words isEqualToString:object.words]){
        return NO;
    }
    if(self.etype != object.etype){
        return NO;
    }
    if([self.targets count] != [object.targets count]){
        return NO;
    }
    for (ClassInfo *classInfo in self.targets) {
        BOOL isIn = NO;
        for (ClassInfo *user in object.targets) {
            if([classInfo.classID isEqualToString:user.classID]){
                isIn = YES;
            }
        }
        if(!isIn){
            return NO;
        }
    }
    if([self.voiceArray count] != [object.voiceArray count]){
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
    
    if([self.imageArray count] != [object.imageArray count]){
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

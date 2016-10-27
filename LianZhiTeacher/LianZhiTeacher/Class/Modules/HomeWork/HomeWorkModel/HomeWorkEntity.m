//
//  HomeWorkEntity.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeWorkEntity.h"
#import "HomeworkSettingManager.h"
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
        self.targets = [NSMutableArray array];
        self.voiceArray = [NSMutableArray array];
        self.imageArray = [NSMutableArray array];
        self.authorUser = [UserCenter sharedInstance].userInfo;
        [self updateClientID];
        self.words = @"我发了一条作业";
        self.createTime = [[NSDate date] timeIntervalSince1970];
        self.sendSms = setting.sendSms;
        self.reply_close = setting.replyEndOn;
        self.reply_close_ctime = setting.replyEndTime;
    }
    return self;
}

+ (HomeWorkEntity *)sendEntityWithHomeworkItem:(HomeworkItem *)homeworkItem{
    HomeWorkEntity *homeworkEntity = [[HomeWorkEntity alloc] init];
   
    return homeworkEntity;
}

- (void)updateClientID{
    self.clientID = [NSString stringWithFormat:@"%zd_%zd",[[NSDate date] timeIntervalSince1970], arc4random() % 1000];
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
    
    [params setValue:kStringFromValue(self.etype) forKey:@"etype"];
    [params setValue:classIDString forKey:@"class_ids"];
    [params setValue:self.words forKey:@"words"];
    [params setValue:self.course_name forKey:@"course_name"];
    [params setValue:kStringFromValue(self.sendSms) forKey:@"sms"];
    [params setValue:self.explainEntity.words forKey:@"answer_words"];
    [params setValue:kStringFromValue(self.count) forKey:@"enums"];
    [params setValue:kStringFromValue(self.reply_close) forKey:@"reply_close"];
    [params setValue:self.reply_close_ctime forKey:@"reply_close_ctime"];
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
    
    if(self.voiceArray.count > 0){
        AudioItem *audioItem = self.voiceArray[0];
        if(audioItem.isLocal){
            [params setValue:kStringFromValue(audioItem.timeSpan) forKey:@"voice_time"];
        }
        else{
            [params setValue:audioItem.audioID forKey:@"voice_id"];
        }
    }
    
    //解析
    if([self.explainEntity.voiceArray count] > 0){
        AudioItem *audioItem = self.explainEntity.voiceArray[0];
        if(audioItem.isLocal){
            [params setValue:kStringFromValue(audioItem.timeSpan) forKey:@"answer_voice_time"];
        }
        else{
            [params setValue:audioItem.audioID forKey:@"answer_voice_id"];
        }
    }
    
    
    self.operation = [[HttpRequestEngine sharedInstance] makeRequestFromUrl:@"exercises/publish" withParams:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
        if(self.voiceArray.count > 0){
            AudioItem *audioItem = self.voiceArray[0];
            if(audioItem.isLocal){
                NSData *voiceData = [NSData dataWithContentsOfFile:audioItem.audioUrl];
                [formData appendPartWithFileData:voiceData name:@"voice" fileName:@"voice" mimeType:@"audio/AMR"];
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
    if(self.words.length + object.words.length > 0 && ![self.words isEqualToString:object.words]){
        return NO;
    }
    if(self.etype != object.etype){
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

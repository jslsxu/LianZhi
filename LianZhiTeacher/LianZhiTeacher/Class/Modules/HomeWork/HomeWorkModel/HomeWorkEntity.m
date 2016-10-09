//
//  HomeWorkEntity.m
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/9/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "HomeWorkEntity.h"

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
        self.openHomeworkCommit = YES;
        self.targets = [NSMutableArray array];
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

- (NSInteger)maxCommentWordsNum{
    if(self.openHomeworkCommit){
        return 150;
    }
    else{
        return 500;
    }
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

- (BOOL)hasVideo{
    return self.videoArray.count > 0;
}

- (BOOL)hasImage{
    return self.imageArray.count > 0;
}

- (BOOL)hasAudio{
    return self.voiceArray.count > 0;
}


- (void)sendWithProgress:(void (^)(CGFloat))progress success:(void (^)(NotificationItem *))success fail:(void (^)())fail{
    
}

- (void)cancelSend{
    [self.operation cancel];
    self.operation = nil;
}

- (BOOL)isSame:(HomeWorkEntity *)object{
    if(self.words.length + object.words.length > 0 && ![self.words isEqualToString:object.words]){
        return NO;
    }
    if(self.openHomeworkCommit != object.openHomeworkCommit){
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

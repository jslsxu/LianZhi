//
//  AudioManager.m
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/21.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "AudioManager.h"
#import "NHFileCache.h"
#define kAudioCacheKey          @"IMAudioCache"
@interface AudioManager ()
@property (nonatomic, strong)NSMutableArray* audioList;
@end

@implementation AudioManager
SYNTHESIZE_SINGLETON_FOR_CLASS(AudioManager)
- (instancetype)init{
    self = [super init];
    if(self){
        NSArray* list = [[NHFileCache sharedInstance] objectForKey:kAudioCacheKey];
        self.audioList = [NSMutableArray arrayWithArray:list];
    }
    return self;
}
- (void)addAudioUrl:(NSString *)url{
    if(![self containsAudio:url] && [url length] > 0){
        [self.audioList addObject:url];
        [self save];
    }
}

- (BOOL)audioHasBeenRead:(NSString *)url{
    return ![self containsAudio:url];
}

- (void)readAudio:(NSString *)url{
    for (NSString* audioUrl in self.audioList) {
        if([audioUrl isEqualToString:url]){
            [self.audioList removeObject:audioUrl];
            [self save];
            return;
        }
    }
}

- (BOOL)containsAudio:(NSString *)url{
    for (NSString* audioUrl in self.audioList) {
        if([audioUrl isEqualToString:url]){
            return YES;
        }
    }
    return NO;
}

- (void)save{
    [[NHFileCache sharedInstance] cacheObject:self.audioList forKey:kAudioCacheKey];
}
@end

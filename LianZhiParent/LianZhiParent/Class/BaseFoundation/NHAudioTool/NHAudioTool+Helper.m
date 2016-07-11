//
//  NHAudioTool+Helper.m
//  NHInputView
//
//  Created by Wilson Yuan on 15/11/12.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import "NHAudioTool+Helper.h"

@implementation NHAudioTool (Helper)

- (NSString *)pathByFileName:(NSString *)fileName ofType:(NSString *)type {
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString* fileDirectory = [[[directory stringByAppendingPathComponent:fileName]
                                stringByAppendingPathExtension:type]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return fileDirectory;
}
- (void)removeItemAtPath:(NSString *)filePath {
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
            NSLog(@"remove success filePath: %@", filePath);
        };
        if (error) {
            NSLog(@"deleteFileByFilePath Error: %@", error.description);
        }
    }
}

- (NSUInteger)fileSizeAtPath:(NSString *)filePath {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
        return [[attributes objectForKey:NSFileSize] integerValue];
    }
    NSLog(@"File not exists");
    return 0;
}


@end

//
//  NHAudioTool+Helper.h
//  NHInputView
//
//  Created by Wilson Yuan on 15/11/12.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import "NHAudioTool.h"

@interface NHAudioTool (Helper)

- (NSString *)pathByFileName:(NSString *)fileName ofType:(NSString *)type;

- (void)removeItemAtPath:(NSString *)filePath;

- (NSUInteger)fileSizeAtPath:(NSString *)filePat;


@end

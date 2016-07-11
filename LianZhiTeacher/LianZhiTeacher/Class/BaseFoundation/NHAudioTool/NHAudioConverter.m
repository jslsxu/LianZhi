//
//  NHAudioConverter.m
//  NHInputView
//
//  Created by Wilson Yuan on 15/11/12.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import "NHAudioConverter.h"
#import "VoiceConverter.h"

@implementation NHAudioConverter

+ (BOOL)convertAmrToWavWithAmrPath:(NSString *)amrPath wavSavePath:(NSString *)wavPath {
    return [VoiceConverter ConvertAmrToWav:amrPath wavSavePath:wavPath];
}

+ (BOOL)convertWavToAmrWithWavPath:(NSString *)wavPath amrSavePath:(NSString *)amrPath {
    return [VoiceConverter ConvertWavToAmr:wavPath amrSavePath:amrPath];
}
+ (NSDictionary *)audioRecorderSettingDict {
    return [VoiceConverter GetAudioRecorderSettingDict];
}
@end

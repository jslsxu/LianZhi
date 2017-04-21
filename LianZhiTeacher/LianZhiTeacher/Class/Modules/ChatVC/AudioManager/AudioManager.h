//
//  AudioManager.h
//  LianZhiTeacher
//
//  Created by jslsxu on 2017/4/21.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNBaseObject.h"

@interface AudioManager : TNBaseObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(AudioManager)
- (void)addAudioUrl:(NSString *)url;
- (BOOL)audioHasBeenRead:(NSString *)url;
- (void)readAudio:(NSString *)url;
- (void)save;
@end

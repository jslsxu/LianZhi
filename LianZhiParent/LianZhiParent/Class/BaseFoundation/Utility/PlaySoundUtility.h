//
//  PlaySoundUtility.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/8/27.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
 #import <AudioToolbox/AudioToolbox.h>
@interface PlaySoundUtility : NSObject
{
    SystemSoundID soundID;
}

 -(id)initForPlayingVibrate;
 -(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type;
 -(id)initForPlayingSoundEffectWith:(NSString *)filename;
 -(void)play;
@end

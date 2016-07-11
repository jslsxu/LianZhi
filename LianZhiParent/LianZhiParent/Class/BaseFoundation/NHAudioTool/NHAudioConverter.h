//
//  NHAudioConverter.h
//  NHInputView
//
//  Created by Wilson Yuan on 15/11/12.
//  Copyright © 2015年 Wilson-Yuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NHAudioConverter : NSObject

/**
 *  转换wav到amr
 *
 *  @param aWavPath  wav文件路径
 *  @param aSavePath amr保存路径
 *
 *  @return 0失败 1成功
 */
+ (BOOL)convertWavToAmrWithWavPath:(NSString *)wavPath amrSavePath:(NSString *)amrPath;

/**
 *  转换amr到wav
 *
 *  @param aAmrPath  amr文件路径
 *  @param aSavePath wav保存路径
 *
 *  @return 0失败 1成功
 */
+ (BOOL)convertAmrToWavWithAmrPath:(NSString *)amrPath wavSavePath:(NSString *)wavPath;

/**
	获取录音设置.
 建议使用此设置，如有修改，则转换amr时也要对应修改参数，比较麻烦
	@returns 录音设置
 */
+ (NSDictionary*)audioRecorderSettingDict;

@end

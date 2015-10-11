//
//  SVShareUserInfo.h
//  SViPad
//
//  Created by jslsxu on 14-7-3.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISVShareUserInfo.h"

@interface SVShareUserInfo : NSObject<ISVShareUserInfo>

/**
 *    根据ShareSDK的用户信息，进行初始化
 *
 *    @param    shareSDKUserInfo    ShareSDK的用户信息
 *
 *    @return    初始化后的结构
 */
-(id)initWithShareSDKUserInfo:(id)shareSDKUserInfo;

@end

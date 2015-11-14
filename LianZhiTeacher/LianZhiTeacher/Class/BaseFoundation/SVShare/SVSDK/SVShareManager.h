//
//  SVShareManager.h
//  LianZhiParent
//
//  Created by jslsxu on 15/11/11.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVShareDef.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib

//新浪微博SDK头文件
#import "WeiboSDK.h"
@interface SVShareManager : NSObject
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SVShareManager)
- (void)initialize;
- (void)shareWithType:(SSDKPlatformType)shareType image:(UIImage *)image imageUrl:(NSString *)imageUrl title:(NSString *)title content:(NSString *)content url:(NSString *)url result:(void(^)(SSDKPlatformType type, SSDKResponseState state, NSString *errorMsg))result;
@end

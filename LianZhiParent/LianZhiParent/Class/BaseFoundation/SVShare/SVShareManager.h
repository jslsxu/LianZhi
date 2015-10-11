//
//  SVShareManager.h
//  SViPad
//
//  Created by jslsxu on 14-7-3.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "SVShareUserInfo.h"
#import "SVShareCredentialInfo.h"
#import "ISVShareManager.h"

@interface SVShareManager: NSObject<ISVShareManager,ISSViewDelegate,ISSShareViewDelegate>
{
    
}
@property (nonatomic,strong) NSMutableArray* arrayShareType;
@property (nonatomic,strong) NSMutableDictionary* dictAppId;
@property (nonatomic,strong) NSMutableDictionary* dictAppKey;
@property (nonatomic,strong) NSMutableDictionary* dictAppSecret;

// 校验第三方平台是否配置
-(BOOL)hasSet:(ShareType)type;


+ (SVShareManager*)sharedInstance;

@end

//
//  SVShareCredentialInfo.m
//  SViPad
//
//  Created by jslsxu on 14-7-3.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import "SVShareCredentialInfo.h"
#import <ShareSDK/ShareSDK.h>

@interface SVShareCredentialInfo()

@property (nonatomic,strong) id<ISSPlatformCredential> shareSDKCredential;

@end

@implementation SVShareCredentialInfo


-(id)initWithShareSDKCredential:(id)shareSDKCredential
{
    self = [super init];
    if (self) {
        self.shareSDKCredential = shareSDKCredential;
    }
    return self;
}


/**
 *    @brief    获取用户标识
 *
 *    @return    用户标识
 */
- (NSString *)uid
{
    return self.shareSDKCredential.uid;
}

/**
 *    @brief    获取令牌,在OAuth中为oauth_token，在OAuth2中为access_token
 *
 *    @return    令牌
 */
- (NSString *)token
{
    return  self.shareSDKCredential.token;
}

/**
 *    @brief    获取令牌密钥，仅用于OAuth授权中，为oauth_token_secret。
 *
 *    @return 令牌密钥
 */
- (NSString *)secret
{
    return self.shareSDKCredential.secret;
}

/**
 *    @brief    获取令牌过期时间，仅用于OAuth2授权中，需要将返回的秒数转换为时间。
 *
 *    @return    令牌过期时间
 */
- (NSDate *)expired
{
    return self.shareSDKCredential.expired;
}

/**
 *    @brief    获取其他扩展信息
 *
 *    @return    扩展信息
 */
- (NSDictionary *)extInfo
{
    return self.shareSDKCredential.extInfo;
}

/**
 *    @brief    获取授权凭证的有效性
 *
 *    @return    授权凭证的有效性
 */
- (BOOL)available
{
    return self.shareSDKCredential.available;
}

@end


//
//  SVShareUserInfo.m
//  SViPad
//
//  Created by jslsxu on 14-7-3.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import "SVShareUserInfo.h"


@interface SVShareUserInfo()

@property (nonatomic,strong) id<ISSPlatformUser> shareSDKUserInfo;
@end

@implementation SVShareUserInfo


-(id)initWithShareSDKUserInfo:(id)shareSDKUserInfo
{
    self = [super init];
    if (self) {
        self.shareSDKUserInfo = shareSDKUserInfo;
    }
    return self;
}

/**
 *    @brief    获取用户ID
 *
 *    @return    用户ID
 */
- (NSString *)uid
{
    return [self.shareSDKUserInfo uid];
}

/**
 *    @brief    获取性别；0:男 1:女 2:未知
 *
 *    @return    性别
 */
- (NSInteger)gender
{
    return [self.shareSDKUserInfo gender];
}

/**
 *    @brief    获取昵称
 *
 *    @return    昵称
 */
- (NSString *)nickname
{
    return [self.shareSDKUserInfo nickname];
}

/**
 *    @brief    获取头像
 *
 *    @return    头像
 */
- (NSString *)profileImage
{
    return [self.shareSDKUserInfo profileImage];
}

/**
 *    @brief    获取生日
 *
 *    @return    生日
 */
- (NSString *)birthday
{
    return [self.shareSDKUserInfo birthday];
}

///**
// *    @brief    获取年龄
// *
// *    @return    年龄
// */
//- (NSInteger)age
//{
//    return [self.shareSDKUserInfo age];
//}

///**
// *    @brief    获取手机号码
// *
// *    @return    手机号码
// */
//- (NSString *)mobile
//{
//    return [self.shareSDKUserInfo mobile];
//}

/**
 *    @brief    获取认证信息
 *
 *    @return    认证信息
 */
- (NSString *)verifyReason
{
    return [self.shareSDKUserInfo verifyReason];
}

/**
 *    @brief    获取认证类型
 *
 *    @return    认证类型
 */
- (NSInteger)verifyType
{
    return [self.shareSDKUserInfo verifyType];
}

/**
 *    @brief    获取社区地址
 *
 *    @return    社区地址
 */
- (NSString *)url
{
    return [self.shareSDKUserInfo url];
}

/**
 *    @brief    获取粉丝数量
 *
 *    @return    粉丝数量
 */
- (NSInteger)followerCount
{
    return [self.shareSDKUserInfo followerCount];
}

/**
 *    @brief    获取关注数量
 *
 *    @return    关注数量
 */
- (NSInteger)friendCount
{
    return [self.shareSDKUserInfo friendCount];
}

/**
 *    @brief    获取用户分享数
 *
 *    @return    分享数量
 */
- (NSInteger)shareCount
{
    return [self.shareSDKUserInfo shareCount];
}

/**
 *    @brief    获取用户等级
 *
 *    @return    用户等级
 */
- (NSInteger)level
{
    return [self.shareSDKUserInfo level];
}

/**
 *    @brief    获取用户的教育信息列表
 *
 *    @return    教育信息列表
 */
- (NSArray *)educations
{
    return [self.shareSDKUserInfo educations];
}

///**
// *    @brief    获取学校信息
// *
// *    @return    学校
// */
//- (NSString *)school
//{
//    return [self.shareSDKUserInfo school];
//}


/**
 *    @brief    获取用户的职业信息列表
 *
 *    @return    职业信息列表
 */
- (NSArray *)works
{
    return [self.shareSDKUserInfo works];
}

/**
 *    @brief    获取用户个人简介
 *
 *    @return    个人简介
 */
- (NSString *)aboutMe
{
    return [self.shareSDKUserInfo aboutMe];
}

/**
 *    @brief    获取源用户信息数据，此属性根据不同平台取得的用户信息结构不相同，详细请参考官方API文档描述。
 *
 *    @return    源用户信息数据
 */
- (NSDictionary *)sourceData
{
    return [self.shareSDKUserInfo sourceData];
}

@end

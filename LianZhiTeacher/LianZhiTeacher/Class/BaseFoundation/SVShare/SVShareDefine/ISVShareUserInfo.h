//
//  ISVShareUserInfo.h
//  SViPad
//
//  Created by jslsxu on 14-7-3.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISVShareUserInfo <NSObject>

/**
 *    @brief    获取用户ID
 *
 *    @return    用户ID
 */
@property (nonatomic,readonly) NSString* uid;

/**
 *    @brief    获取性别；0:男 1:女 2:未知
 *
 *    @return    性别
 */
@property (nonatomic,readonly) NSInteger gender;

/**
 *    @brief    获取昵称
 *
 *    @return    昵称
 */
@property (nonatomic,readonly) NSString* nickname;

/**
 *    @brief    获取头像
 *
 *    @return    头像
 */
@property (nonatomic,readonly) NSString* profileImage;

/**
 *    @brief    获取生日
 *
 *    @return    生日
 */
@property (nonatomic,readonly) NSString* birthday;

///**
// *    @brief    获取年龄
// *
// *    @return    年龄
// */
//@property (nonatomic,readonly) NSInteger age;

///**
// *    @brief    获取手机号码
// *
// *    @return    手机号码
// */
//@property (nonatomic,readonly) NSString* mobile;

/**
 *    @brief    获取认证信息
 *
 *    @return    认证信息
 */
@property (nonatomic,readonly) NSString* verifyReason;

/**
 *    @brief    获取认证类型
 *
 *    @return    认证类型
 */
@property (nonatomic,readonly) NSInteger verifyType;

/**
 *    @brief    获取社区地址
 *
 *    @return    社区地址
 */
@property (nonatomic,readonly) NSString* url;

/**
 *    @brief    获取粉丝数量
 *
 *    @return    粉丝数量
 */
@property (nonatomic,readonly) NSInteger followerCount;

/**
 *    @brief    获取关注数量
 *
 *    @return    关注数量
 */
@property (nonatomic,readonly) NSInteger friendCount;

/**
 *    @brief    获取用户分享数
 *
 *    @return    分享数量
 */
@property (nonatomic,readonly) NSInteger shareCount;

/**
 *    @brief    获取用户等级
 *
 *    @return    用户等级
 */
@property (nonatomic,readonly) NSInteger level;

/**
 *    @brief    获取用户的教育信息列表
 *
 *    @return    教育信息列表
 */
@property (nonatomic,readonly) NSArray* educations;

///**
// *    @brief    获取学校信息
// *
// *    @return    学校
// */
//@property (nonatomic,readonly) NSString* school;


/**
 *    @brief    获取用户的职业信息列表
 *
 *    @return    职业信息列表
 */
@property (nonatomic,readonly) NSArray* works;

/**
 *    @brief    获取用户个人简介
 *
 *    @return    个人简介
 */
@property (nonatomic,readonly) NSString* aboutMe;

/**
 *    @brief    获取源用户信息数据，此属性根据不同平台取得的用户信息结构不相同，详细请参考官方API文档描述。
 *
 *    @return    源用户信息数据
 */
@property (nonatomic,readonly) NSDictionary* sourceData;


@end
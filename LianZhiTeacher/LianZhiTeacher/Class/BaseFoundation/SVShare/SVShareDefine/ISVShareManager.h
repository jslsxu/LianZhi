//
//  ISVShareManager.h
//  SViPad
//
//  Created by jslsxu on 14-7-3.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISVShareUserInfo.h"
#import "ISVShareCredentialInfo.h"

/**
 *    结果状态
 */
typedef NS_ENUM(NSInteger, SVShareResultState)
{
    SVShareResultStateSuccess = 1,
    SVShareResultStateFail = 2,
    SVShareResultStateCancel = 3
};

@protocol ISVShareManager <NSObject>

#pragma mark 集成

/**
 *    @brief    注册应用,此方法在应用启动时调用一次并且只能在主线程中调用。
 *
 *    @param     appKey     应用Key,在ShareSDK官网中注册的应用Key
 */
- (void)registerAppWithKeyOfShareSDK:(NSString *)appKey;


/**
 *    @brief    处理请求打开链接,如果集成新浪微博(SSO)、Facebook(SSO)、微信、QQ分享功能需要加入此方法
 *
 *    @param     url     链接
 *    @param     sourceApplication     源应用
 *    @param     annotation     源应用提供的信息
 *  @param  wxDelegate  微信委托,如果没有集成微信SDK，可以传入nil
 *
 *    @return    YES 表示接受请求，NO 表示不接受请求
 */
- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
           wxDelegate:(id)wxDelegate;

#pragma mark UI调整
- (void)setBlockViewControllerWillShow:(void(^)(UIViewController* viewController))blockViewControllerWillShow;

#pragma mark 获取已连接的第三方平台
/**
 *    已连接的第三方平台（成员为用NSNumber保存的MFWShareType）
 */
- (NSArray*)getConnectedShareTypeArray;


/**
 *    获取第三方平台的id
 *
 *    @param    type    第三方平台
 */
- (NSString*)getAppIdWithType:(ShareType)type;
/**
 *    获取第三方平台的key
 *
 *    @param    type    第三方平台
 */
- (NSString*)getAppKeyWithType:(ShareType)type;
/**
 *    获取第三方平台的secret
 *
 *    @param    type    第三方平台
 */
- (NSString*)getAppSecretWithType:(ShareType)type;

#pragma mark 注册第三方平台（校验）

/**
 *    开启Email分享
 */
- (void)connectMail;

/**
 *    开启短信分享
 */
- (void)connectSMS;

/**
 *    开启拷贝
 */
- (void)connectCopy;

/**
 *    @brief    连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
 *          http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
 *
 *    @param     appKey     应用Key
 *    @param     appSecret     应用密钥
 *    @param     redirectUri     回调地址,无回调页面或者不需要返回回调时可以填写新浪默认回调页面：https://api.weibo.com/oauth2/default.html
 *                          但新浪开放平台中应用的回调地址必须填写此值
 */
- (void)connectSinaWeiboWithAppKey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                       redirectUri:(NSString *)redirectUri;

/**
 *    @brief    连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
 *          http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
 *
 *    @param     appKey     应用Key
 *    @param     appSecret     应用密钥
 *    @param     redirectUri     回调地址，此地址则为应用地址。
 */
- (void)connectTencentWeiboWithAppKey:(NSString *)appKey
                            appSecret:(NSString *)appSecret
                          redirectUri:(NSString *)redirectUri;


/**
 *    @brief    连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
 *          http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
 *
 *    @param     appKey     应用Key
 *    @param     appSecret     应用密钥
 */
- (void)connectQZoneWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret;

/**
 *    @brief    连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和TencentOAuthAPI.framework库
 *          http://connect.qq.com上注册应用，并将相关信息填写到以下字段,
 *          可以调用此接口来使QQ空间中申请的AppKey用于QQ好友分享
 *
 *  @since  ver2.2.4
 *
 *    @param     qzoneAppKey     QQ空间App标识
 */
- (void)connectQQWithQZoneAppKey:(NSString *)qzoneAppKey;


/**
 *    @brief    连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
 *          http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
 *
 *    @param     appId     应用ID
 */
- (void)connectWeChatWithAppId:(NSString *)appId;


#pragma mark 分享
/**
 *    @brief    分享内容iPhone
 *
 *    @param     text    内容对象
 *    @param     image   图片
 *  @param  url     链接
 *    @param     title   标题
 *    @param     result     返回事件
 */
- (void)shareText:(NSString*)text
            image:(UIImage*)image
              url:(NSString*)url
            title:(NSString*)title
           result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result;

- (void)shareText:(NSString*)text
            image:(UIImage*)image
              url:(NSString*)url
            title:(NSString*)title
       controller:(UIViewController*)controller
           result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result;

/**
 *    分享到iPhone
 *
 *    @param    text    内容
 *    @param    image    图片（无图片地址时使用）
 *    @param    imageUrl    图片地址（优先使用）
 *    @param    url    链接
 *    @param    title    标题
 *    @param    controller    视图控制器
 */
- (void)shareText:(NSString*)text
            image:(UIImage*)image
         imageUrl:(NSString*)imageUrl
              url:(NSString*)url
            title:(NSString*)title
       controller:(UIViewController*)controller
           result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result;


- (void)shareWithType:(ShareType)type
                 text:(NSString*)text
                image:(UIImage*)image
             imageUrl:(NSString*)imageUrl
                  url:(NSString*)url
                title:(NSString*)title
               result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result;


// iPad分享 todo

#pragma mark 授权

/**
 *    判断平台是否已授权
 *
 *    @param    type    第三方平台类型
 */
-(BOOL)hasAuthorizedWithType:(ShareType)type;

/**
 *    @brief    授权
 *
 *  @param  type    第三方平台类型
 *
 *    @return    授权选项
 */
-(void)authWithType:(ShareType)type
             result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result;

/**
 *    @brief    取消授权,微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。
 *
 *    @param     type     社会化平台类型
 */
- (void)cancelAuthWithType:(ShareType)type;


///**
// *    @brief 获取授权信息（token）
// *
// *    @param    type    平台类型
// *
// *    @return    授权信息的原始字典
// */
//- (NSDictionary*)getCredentialDictionary:(MFWShareType)type;

/**
 *    @brief 获取授权信息（token）
 *
 *    @param    type    平台类型
 *
 *    @return    授权信息的原始字典
 */
- (id<ISVShareCredentialInfo>)getCredentialInfo:(ShareType)type;



#pragma mark 获取用户信息

/**
 *    @brief    获取当前授权用户信息
 *
 *    @param     shareType     平台类型
 *  @param  result  获取用户信息返回事件
 */
- (void)getUserInfoWithType:(ShareType)type
                     result:(void(^)(ShareType type, id<ISVShareUserInfo> userInfo, SVShareResultState state, NSString* errorMsg))resultHandler;


#pragma mark 关注
/**
 *    @brief    关注微信号（已废弃）
 *
 *    @param     userData     二维码数据
 */
//- (void)followWeixinUser:(NSString *)qrCode;

/**
 *    @brief  关注用户
 *
 *    @param    type    第三方平台
 *    @param    userName    用户名称
 */
- (void)followUserWithType:(ShareType)type
                  userName:(NSString*)userName
                    result:(void(^)(ShareType type, BOOL success, NSString* errorMsg))resultHandler;

#pragma mark 平台资源
/**
 *    @brief    获取平台客户端名称
 *
 *    @param     type     分享类型
 *
 *    @return    名称
 */
- (NSString *)getClientNameWithType:(ShareType)type;

/**
 *    @brief    获取平台客户端图标
 *
 *    @param     type     分享类型
 *
 *    @return    图标
 */
- (UIImage *)getClientIconWithType:(ShareType)type;

@end



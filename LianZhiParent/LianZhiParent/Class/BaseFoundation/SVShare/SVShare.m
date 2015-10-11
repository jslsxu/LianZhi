//
//  SVShare.m
//  SViPad
//
//  Created by jslsxu on 14-7-3.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import "SVShare.h"
#import "SVShareManager.h"
#import <QZoneConnection/QZoneConnection.h>

@implementation SVShare

+ (SVShare *)sharedInstance;
{
    static SVShare *_sharedInstance = nil;
    if (_sharedInstance == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[SVShare alloc] init];
            
        });
    }
    
    return _sharedInstance;
}

- (void)initialize
{
    [self registerAppWithKeyOfShareSDK:AppKey_ShareSDK];
    [self connectWeChatWithAppId:AppKey_Weixin];
    [self connectSinaWeiboWithAppKey:AppKey_SinaWeibo appSecret:AppSecret_SinaWeibo redirectUri:kSinaWeiboRedirectURI];
    [self connectQZoneWithAppKey:AppKey_QZone appSecret:AppSecret_QZone];
    [self connectQQWithQZoneAppKey:AppKey_QZone];
}

- (void)registerAppWithKeyOfShareSDK:(NSString *)appKey
{
    [[SVShareManager sharedInstance] registerAppWithKeyOfShareSDK:appKey];
}


- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
           wxDelegate:(id)wxDelegate
{
    return [[SVShareManager sharedInstance] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:wxDelegate];
}

- (void)setBlockViewControllerWillShow:(void(^)(UIViewController* viewController))blockViewControllerWillShow
{
    [[SVShareManager sharedInstance] setBlockViewControllerWillShow:blockViewControllerWillShow];
}

#pragma mark 获取已连接的第三方平台
/**
 *    已连接的第三方平台（成员为用NSNumber保存的SVShareType）
 */
- (NSArray*)getConnectedShareTypeArray
{
    return [[SVShareManager sharedInstance] getConnectedShareTypeArray];
}


/**
 *    获取第三方平台的id
 *
 *    @param    type    第三方平台
 */
- (NSString*)getAppIdWithType:(ShareType)type
{
    return [[SVShareManager sharedInstance] getAppIdWithType:type];
}
/**
 *    获取第三方平台的key
 *
 *    @param    type    第三方平台
 */
- (NSString*)getAppKeyWithType:(ShareType)type
{
    return [[SVShareManager sharedInstance] getAppKeyWithType:type];
}
/**
 *    获取第三方平台的secret
 *
 *    @param    type    第三方平台
 */
- (NSString*)getAppSecretWithType:(ShareType)type
{
    return [[SVShareManager sharedInstance] getAppSecretWithType:type];
}

#pragma mark 初始化

/**
 *    开启Email分享
 */
- (void)connectMail
{
    [[SVShareManager sharedInstance] connectMail];
}

/**
 *    开启短信分享
 */
- (void)connectSMS
{
    [[SVShareManager sharedInstance] connectSMS];
}

/**
 *    开启拷贝
 */
- (void)connectCopy
{
    [[SVShareManager sharedInstance] connectCopy];
}


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
                       redirectUri:(NSString *)redirectUri
{
    [[SVShareManager sharedInstance] connectSinaWeiboWithAppKey:appKey appSecret:appSecret redirectUri:redirectUri];
}

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
                          redirectUri:(NSString *)redirectUri
{
    [[SVShareManager sharedInstance] connectTencentWeiboWithAppKey:appKey appSecret:appSecret redirectUri:redirectUri];
}


/**
 *    @brief    连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
 *          http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
 *
 *    @param     appKey     应用Key
 *    @param     appSecret     应用密钥
 */
- (void)connectQZoneWithAppKey:(NSString *)appKey
                     appSecret:(NSString *)appSecret
{
    [[SVShareManager sharedInstance] connectQZoneWithAppKey:appKey appSecret:appSecret];
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
}


/**
 *    @brief    连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和TencentOAuthAPI.framework库
 *          http://connect.qq.com上注册应用，并将相关信息填写到以下字段,
 *          可以调用此接口来使QQ空间中申请的AppKey用于QQ好友分享
 *
 *  @since  ver2.2.4
 *
 *    @param     qzoneAppKey     QQ空间App标识
 */
- (void)connectQQWithQZoneAppKey:(NSString *)qzoneAppKey
{
    [[SVShareManager sharedInstance] connectQQWithQZoneAppKey:qzoneAppKey];
}


/**
 *    @brief    连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
 *          http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
 *
 *    @param     appId     应用ID
 */
- (void)connectWeChatWithAppId:(NSString *)appId
{
    [[SVShareManager sharedInstance] connectWeChatWithAppId:appId];
}


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
{
    [[SVShareManager sharedInstance] shareText:text image:image url:url title:title result:result];
}

- (void)shareText:(NSString*)text
            image:(UIImage*)image
              url:(NSString*)url
            title:(NSString*)title
       controller:(UIViewController*)controller
           result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result
{
    [[SVShareManager sharedInstance] shareText:text image:image url:url title:title controller:controller result:result];
}

- (void)shareText:(NSString*)text
            image:(UIImage*)image
         imageUrl:(NSString*)imageUrl
              url:(NSString*)url
            title:(NSString*)title
       controller:(UIViewController*)controller
           result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result
{
    [[SVShareManager sharedInstance] shareText:text image:image imageUrl:imageUrl url:url title:title controller:controller result:result];
}
- (void)shareWithType:(ShareType)type
                 text:(NSString *)text
                image:(UIImage *)image
             imageUrl:(NSString *)imageUrl
                  url:(NSString *)url
                title:(NSString *)title
               result:(void (^)(ShareType, SVShareResultState, NSString *))result
{
    [[SVShareManager sharedInstance] shareWithType:type text:text image:image imageUrl:imageUrl url:url title:title result:result];
}


// iPad分享 todo


-(BOOL)hasAuthorizedWithType:(ShareType)type;
{
    return [[SVShareManager sharedInstance] hasAuthorizedWithType:type];
}

/**
 *    @brief    授权
 *
 *  @param  type    第三方平台类型
 *
 *    @return    授权选项
 */
-(void)authWithType:(ShareType)type
             result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result
{
    [[SVShareManager sharedInstance] authWithType:type result:result];
}

/**
 *    @brief    取消授权,微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。
 *
 *    @param     type     社会化平台类型
 */
- (void)cancelAuthWithType:(ShareType)type
{
    [[SVShareManager sharedInstance] cancelAuthWithType:type];
}

/**
 *    @brief    获取当前授权用户信息
 *
 *    @param     shareType     平台类型
 *  @param  result  获取用户信息返回事件
 */
- (void)getUserInfoWithType:(ShareType)type
                     result:(void(^)(ShareType type, id<ISVShareUserInfo> userInfo, SVShareResultState state, NSString* errorMsg))resultHandler
{
    [[SVShareManager sharedInstance] getUserInfoWithType:type result:resultHandler];
}


///**
// *    @brief 获取授权信息（token）
// *
// *    @param    type    平台类型
// *
// *    @return    授权信息的原始字典
// */
//- (NSDictionary*)getCredentialDictionary:(SVShareType)type
//{
//    return [[SVShareManager sharedInstance] getCredentialDictionary:type];
//}

- (id<ISVShareCredentialInfo>)getCredentialInfo:(ShareType)type
{
    return [[SVShareManager sharedInstance] getCredentialInfo:type];
}


//- (void)followWeixinUser:(NSString *)qrCode
//{
//    [[SVShareManager sharedInstance] followWeixinUser:qrCode];
//}

- (void)followUserWithType:(ShareType)type
                  userName:(NSString*)userName
                    result:(void(^)(ShareType type, BOOL success, NSString* errorMsg))resultHandler
{
    [[SVShareManager sharedInstance] followUserWithType:type userName:userName result:resultHandler];
}


- (NSString *)getClientNameWithType:(ShareType)type
{
    return [[SVShareManager sharedInstance] getClientNameWithType:type];
}
- (UIImage*)getClientIconWithType:(ShareType)type
{
    return [[SVShareManager sharedInstance] getClientIconWithType:type];
}

@end



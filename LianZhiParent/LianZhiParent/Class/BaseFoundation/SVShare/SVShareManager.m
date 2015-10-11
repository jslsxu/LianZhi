//
//  SVShareManager.m
//  SViPad
//
//  Created by jslsxu on 14-7-3.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#import "SVShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>



@interface SVShareManager()





// 校验url scheme设置是否正确 todo



@property (nonatomic,strong) NSString* ssSinaAppKey;
@property (nonatomic,strong) NSString* ssQQAppID;
@property (nonatomic,strong) NSString* ssWXAppID;
@property (nonatomic,strong) NSString* ssQQSpaceAppKey;

@property (nonatomic,copy) void(^blockViewContrllorWillShow)(UIViewController* viewController);

@end

@implementation SVShareManager


-(void)checkUrlSchemeConfig
{
    return;
    NSArray* array = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    
    
    NSString* ssSinaAppKey = [SVShareManager sharedInstance].ssSinaAppKey;
    NSString* ssQQAppID = [SVShareManager sharedInstance].ssQQAppID;
    NSString* ssWXAppID = [SVShareManager sharedInstance].ssWXAppID;
    NSString* ssQQSpaceAppKey = [SVShareManager sharedInstance].ssQQSpaceAppKey;
    
    
    BOOL sinaWeiboFailed = ssSinaAppKey.length > 0;
    BOOL qqFailed = ssQQAppID.length > 0;
    BOOL wxFailed = ssWXAppID.length > 0;
    BOOL qqSpaceFailed = ssQQSpaceAppKey.length > 0;
    
    
    for (NSDictionary* dic in array) {
        NSArray* shemes = [dic objectForKey:@"CFBundleURLSchemes"];
        for (NSString* urlScheme in shemes) {
            NSString* str = nil;
            
            str = [NSString stringWithFormat:@"sinaweibosso.%@",ssSinaAppKey];
            if ([str isEqualToString:urlScheme]) {
                sinaWeiboFailed = NO;
            }
            if ([ssQQAppID isEqualToString:urlScheme]) {
                qqFailed = NO;
            }
            if ([ssWXAppID isEqualToString:urlScheme]) {
                wxFailed = NO;
            }
            
            // 校验QQ空间
            str = [NSString stringWithFormat:@"tencent%@",ssQQSpaceAppKey];
            if ([str isEqualToString:urlScheme]) {
                qqSpaceFailed = NO;
            }
            
        }
    }
    
    // 校验 新浪微博
    NSAssert(!sinaWeiboFailed, @"[SVShare]UrlScheme未配置：新浪微博[%@]",[NSString stringWithFormat:@"sinaweibosso.%@",ssSinaAppKey]);

    // 校验 QQ
    NSAssert(!qqFailed, @"[SVShare]UrlScheme未配置：QQ[%@]",ssQQAppID);

    // 校验 微信
    NSAssert(!wxFailed, @"[SVShare]UrlScheme未配置：微信[%@]",ssWXAppID);

    // 校验 QQ空间
    NSAssert(!qqSpaceFailed, @"[SVShare]UrlScheme未配置：QQ空间[%@]",ssQQSpaceAppKey);
    
}


- (void)registerAppWithKeyOfShareSDK:(NSString *)appKey
{
    [ShareSDK registerApp:appKey];
    
    [self checkUrlSchemeConfig];
    
    [ShareSDK ssoEnabled:YES];
}

- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
           wxDelegate:(id)wxDelegate
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:wxDelegate];
}


#pragma mark UI调整
- (void)setBlockViewControllerWillShow:(void(^)(UIViewController* viewController))blockViewControllerWillShow
{
    _blockViewContrllorWillShow = blockViewControllerWillShow;
}

+ (SVShareManager *)sharedInstance;
{
    static SVShareManager *_sharedInstance = nil;
    if (_sharedInstance == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[SVShareManager alloc] init];
            
        });
    }
    
    return _sharedInstance;
}


-(NSMutableArray*)arrayShareType
{
    if(!_arrayShareType)
    {
        _arrayShareType = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return _arrayShareType;
}
-(NSMutableDictionary*)dictAppId
{
    if(!_dictAppId)
    {
        _dictAppId = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    return _dictAppId;
}
-(NSMutableDictionary*)dictAppKey
{
    if(!_dictAppKey)
    {
        _dictAppKey = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    return _dictAppKey;
}
-(NSMutableDictionary*)dictAppSecret
{
    if (!_dictAppSecret) {
        _dictAppSecret = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    return _dictAppSecret;
}

// 校验第三方平台是否配置
-(BOOL)hasSet:(ShareType)type
{
    __block BOOL hasSet = NO;
    
    NSNumber* shareTypeNumber = [NSNumber numberWithInteger:type];
    [self.arrayShareType enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber* number = obj;
            if ([number isEqualToValue:shareTypeNumber]) {
                hasSet = YES;
            }
        }
    }];
    
    return hasSet;
}



#pragma mark 获取已连接的第三方平台
/**
 *    已连接的第三方平台
 */
- (NSArray*)getConnectedShareTypeArray
{
    return [self.arrayShareType copy];
}

/**
 *    获取第三方平台的id
 *
 *    @param    type    第三方平台
 */
- (NSString*)getAppIdWithType:(ShareType)type
{
    return self.dictAppId[[NSNumber numberWithInteger:type]];
}
/**
 *    获取第三方平台的key
 *
 *    @param    type    第三方平台
 */
- (NSString*)getAppKeyWithType:(ShareType)type
{
    return self.dictAppKey[[NSNumber numberWithInteger:type]];
}
/**
 *    获取第三方平台的secret
 *
 *    @param    type    第三方平台
 */
- (NSString*)getAppSecretWithType:(ShareType)type
{
    return self.dictAppSecret[[NSNumber numberWithInteger:type]];
}


#pragma mark 初始化


/**
 *    开启Email分享
 */
- (void)connectMail
{
    ShareType shareType = ShareTypeMail;
    if (![self hasSet:shareType]) {
        [self.arrayShareType addObject:[NSNumber numberWithInteger:shareType]];
        [ShareSDK connectMail];
    }
}

/**
 *    开启短信分享
 */
- (void)connectSMS
{
    ShareType shareType = ShareTypeSMS;
    if (![self hasSet:shareType]) {
        [self.arrayShareType addObject:[NSNumber numberWithInteger:shareType]];
        [ShareSDK connectSMS];
    }
}

/**
 *    开启拷贝
 */
- (void)connectCopy
{
    ShareType shareType = ShareTypeCopy;
    if (![self hasSet:shareType]) {
        [self.arrayShareType addObject:[NSNumber numberWithInteger:shareType]];
        [ShareSDK connectCopy];
    }
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
    [ShareSDK connectSinaWeiboWithAppKey:appKey appSecret:appSecret redirectUri:redirectUri];
    
    ShareType shareType = ShareTypeSinaWeibo;
    if (![self hasSet:shareType]) {
        [self.arrayShareType addObject:[NSNumber numberWithInteger:shareType]];
    }
    
    self.ssSinaAppKey = appKey;
    NSNumber* numberShareType = [NSNumber numberWithInteger:shareType];
    self.dictAppKey[numberShareType] = appKey;
    self.dictAppSecret[numberShareType] = appSecret;
    
    [self checkUrlSchemeConfig];
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
    [ShareSDK connectTencentWeiboWithAppKey:appKey appSecret:appSecret redirectUri:redirectUri wbApiCls:[WXApi class]];
    
    // todo 校验url scheme
    ShareType shareType = ShareTypeTencentWeibo;
    if (![self hasSet:shareType]) {
        [self.arrayShareType addObject:[NSNumber numberWithInteger:shareType]];
    }
    
    NSNumber* numberShareType = [NSNumber numberWithInteger:shareType];
    self.dictAppKey[numberShareType] = appKey;
    self.dictAppSecret[numberShareType] = appSecret;
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
    [ShareSDK connectQZoneWithAppKey:appKey appSecret:appSecret qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    // todo 校验url scheme
    ShareType shareType = ShareTypeQQSpace;
    if (![self hasSet:shareType]) {
        [self.arrayShareType addObject:[NSNumber numberWithInteger:shareType]];
    }
    
    self.ssQQSpaceAppKey = appKey;
    NSNumber* numberShareType = [NSNumber numberWithInteger:shareType];
    self.dictAppKey[numberShareType] = appKey;
    self.dictAppSecret[numberShareType] = appSecret;
    
    [self checkUrlSchemeConfig];
}



///**
// *    @brief    连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
// *          http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
// *
// *    @param     appId     应用ID
// *    @param     qqApiCls     QQApi类型,引入QQApi.h后，将[QQApi class]传入此参数
// */
//+ (void)connectQQWithAppId:(NSString *)appId
//                  qqApiCls:(Class)qqApiCls
//{
//    [ShareSDK connectQQWithAppId:appId qqApiCls:[QQApi class]];
//
//    // todo 校验url scheme
//    SVShareType shareType = ShareTypeQQ;
//    if (![[self sharedInstance] hasSet:shareType]) {
//        [[self sharedInstance].arrayShareType addObject:[NSNumber numberWithInteger:shareType]];
//    }
//}

/**
 *    @brief    连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和TencentOAuthAPI.framework库
 *          http://connect.qq.com上注册应用，并将相关信息填写到以下字段,
 *          可以调用此接口来使QQ空间中申请的AppKey用于QQ好友分享
 *
 *  @since  ver2.2.4
 *
 *    @param     qzoneAppKey     QQ空间App标识
 *    @param     qqApiInterfaceCls     QQAPI接口类型
 *    @param     tencentOAuthCls     腾讯OAuth类型
 */
- (void)connectQQWithQZoneAppKey:(NSString *)qzoneAppKey
{
    [ShareSDK connectQQWithQZoneAppKey:qzoneAppKey qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    // todo 校验url scheme
    ShareType shareType = ShareTypeQQ;
    if (![self hasSet:shareType]) {
        [self.arrayShareType addObject:[NSNumber numberWithInteger:shareType]];
    }
    
    // 这个比较特别，用的是qq空间的key，所以QQ的key不记在 dictAppKey中，如何处理，待定 todo
}


/**
 *    @brief    连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
 *          http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
 *
 *    @param     appId     应用ID
 */
- (void)connectWeChatWithAppId:(NSString *)appId
{
    [ShareSDK connectWeChatWithAppId:appId wechatCls:[WXApi class]];
    
    ShareType shareType = ShareTypeWeixiSession;
    if (![self hasSet:shareType]) {
        [self.arrayShareType addObject:[NSNumber numberWithInteger:shareType]];
    }
    
    shareType = ShareTypeWeixiTimeline;
    if (![self hasSet:shareType]) {
        [self.arrayShareType addObject:[NSNumber numberWithInteger:shareType]];
    }
    
    self.ssWXAppID = appId;
    NSNumber* numberShareType = [NSNumber numberWithInteger:shareType];
    self.dictAppId[numberShareType] = appId;
    
    [self checkUrlSchemeConfig];
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
           result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result
{
    [self shareText:text image:image url:url title:title controller:nil result:result];
}

- (void)shareText:(NSString*)text
            image:(UIImage*)image
              url:(NSString*)url
            title:(NSString*)title
       controller:(UIViewController*)controller
           result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result
{
    [self shareText:text image:image imageUrl:nil url:url title:title controller:controller result:result];
}


- (void)shareText:(NSString*)text
            image:(UIImage*)image
         imageUrl:(NSString*)imageUrl
              url:(NSString*)url
            title:(NSString*)title
       controller:(UIViewController*)controller
           result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result
{
    NSArray* shareList = self.arrayShareType;
    
    id<ISSContainer> container = [self shareSDKContainer:controller];
    id<ISSContent> publishContent = [self shareSDKPublishContent:text image:image imageUrl:imageUrl url:url title:title];
    id<ISSAuthOptions> authOptions = [self shareSDKAuthOption];
    id<ISSShareOptions> shareOptions = [self shareSDKShareOption];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                // 开始分享这个事件不处理
                                if (!end) {
                                    return;
                                }
                                
                                SVShareResultState mfwState = SVShareResultStateFail;
                                switch (state) {
                                    case SSPublishContentStateSuccess:
                                        mfwState = SVShareResultStateSuccess;
                                        break;
                                    case SSPublishContentStateCancel:
                                        mfwState = SVShareResultStateCancel;
                                        break;
                                    case SSPublishContentStateFail:
                                        mfwState = SVShareResultStateFail;
                                        break;
                                    default:
                                        return; // 不处理，直接返回
                                        break;
                                }
                                
                                NSString* errorMsg = [error errorDescription];
                                if (result) {
                                    result(type,mfwState,errorMsg);
                                }
                            }];
}

-(void)shareWithType:(ShareType)type
                text:(NSString *)text
               image:(UIImage *)image
            imageUrl:(NSString *)imageUrl
                 url:(NSString *)url
               title:(NSString *)title
              result:(void (^)(ShareType, SVShareResultState, NSString *))result
{
    id<ISSContent> publishContent = [self shareSDKPublishContent:text image:image imageUrl:imageUrl url:url title:title];
    id<ISSAuthOptions> authOptions = [self shareSDKAuthOption];
    id<ISSShareOptions> shareOptions = [self shareSDKShareOption];
    id<ISSContainer> container = [self shareSDKContainer:nil];
    
    [ShareSDK showShareViewWithType:type container:container content:publishContent statusBarTips:NO authOptions:authOptions shareOptions:shareOptions result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        // 开始分享这个事件不处理
        if (!end) {
            return;
        }
        
        SVShareResultState mfwState = SVShareResultStateFail;
        switch (state) {
            case SSPublishContentStateSuccess:
                mfwState = SVShareResultStateSuccess;
                break;
            case SSPublishContentStateCancel:
                mfwState = SVShareResultStateCancel;
                break;
            case SSPublishContentStateFail:
                mfwState = SVShareResultStateFail;
                break;
            default:
                return; // 不处理，直接返回
                break;
        }
        
        NSString* errorMsg = [error errorDescription];
        if (result) {
            result(type,mfwState,errorMsg);
        }
    }];
    
}

-(id<ISSContainer>)shareSDKContainer:(UIViewController*)controller
{
    id<ISSContainer> container = [ShareSDK container];
    if (controller) {// todo 判断是iPhone还是iPad
        [container setIPhoneContainerWithViewController:controller];
    }
    
    return container;
}

-(id<ISSContent>)shareSDKPublishContent:(NSString*)text
                                  image:(UIImage*)image
                               imageUrl:(NSString*)imageUrl
                                    url:(NSString*)url
                                  title:(NSString*)title
{
    id<ISSCAttachment> attachment = nil;
    if (imageUrl) {
        attachment = [ShareSDK imageWithUrl:imageUrl];
    }else if(image){
        attachment = [ShareSDK pngImageWithImage:image];
    }
    
    
    id<ISSContent> publishContent =  [ShareSDK content:text
                                        defaultContent:text
                                                 image:attachment
                                                 title:title
                                                   url:url
                                           description:text
                                             mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addQQSpaceUnitWithTitle:title url:url site:nil fromUrl:nil comment:nil summary:text image:attachment type:[NSNumber numberWithInteger:4] playUrl:nil nswb:[NSNumber numberWithInteger:0]];
    
    return publishContent;
}


-(id<ISSAuthOptions>)shareSDKAuthOption
{
    return [ShareSDK authOptionsWithAutoAuth:YES
                               allowCallback:YES
                                      scopes:nil
                               powerByHidden:YES
                              followAccounts:nil
                               authViewStyle:SSAuthViewStyleModal
                                viewDelegate:self
                     authManagerViewDelegate:nil];
}

-(id<ISSShareOptions>)shareSDKShareOption
{
    return [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"分享", nil)
                                  oneKeyShareList:nil
                               cameraButtonHidden:YES
                              mentionButtonHidden:YES
                                topicButtonHidden:NO
                                   qqButtonHidden:YES
                            wxSessionButtonHidden:YES
                           wxTimelineButtonHidden:YES
                             showKeyboardOnAppear:YES
                                shareViewDelegate:self
                              friendsViewDelegate:nil
                            picViewerViewDelegate:nil];
}

// iPad分享 todo

/**
 *    @brief    判断是否授权,微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。
 *
 *    @param     type     社会化平台类型
 *
 *    @return    YES 已授权； NO 未授权
 */
- (BOOL)hasAuthorizedWithType:(ShareType)type
{
    return [ShareSDK hasAuthorizedWithType:type];
}

/**
 *    @brief    取消授权,微信、QQ、邮件、短信、打印、拷贝类型不支持授权功能。
 *
 *    @param     type     社会化平台类型
 */
- (void)cancelAuthWithType:(ShareType)type
{
    return [ShareSDK cancelAuthWithType:type];
}

/**
 *    @brief    创建授权选项
 *
 *  @param  type    第三方平台类型
 *
 *    @return    授权选项
 */
-(void)authWithType:(ShareType)type
             result:(void(^)(ShareType type,SVShareResultState state, NSString* errorMsg))result
{
    if (![[SVShareManager sharedInstance] hasSet:type]) {
        if (result) {
            result(type,SVShareResultStateFail,@"未配置第三方平台参数");
            return;
        }
    }
    
    // todo 设置iPad的authViewStyle
    SSAuthViewStyle style = SSAuthViewStyleModal;
    
    // todo 根据viewDelegate调整界面
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:style viewDelegate:nil authManagerViewDelegate:nil];
    
    
    [ShareSDK authWithType:type
                   options:authOptions
                    result:^(SSAuthState state, id<ICMErrorInfo> error){
                        
                        SVShareResultState mfwState = SVShareResultStateFail;
                        NSString* errorMsg = nil;
                        switch (state) {
                            case SSAuthStateSuccess:
                                mfwState = SVShareResultStateSuccess;
                                break;
                            case SSAuthStateCancel:
                                mfwState = SVShareResultStateCancel;
                                break;
                            case SSAuthStateFail:
                                mfwState = SVShareResultStateFail;
                                errorMsg = [error description];
                                break;
                            default:
                                return; // 不处理，直接返回
                                break;
                        }
                        
                        if (result) {
                            result(type,mfwState,errorMsg);
                        }
                        
                    }];
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
    // todo 设置iPad的authViewStyle
    SSAuthViewStyle style = SSAuthViewStyleModal; // for iPhone
    
    // todo 根据viewDelegate调整界面
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:YES authViewStyle:style viewDelegate:nil authManagerViewDelegate:nil];
    
    
    [ShareSDK getUserInfoWithType:type authOptions:authOptions result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        SVShareUserInfo* mfwUser = [[SVShareUserInfo alloc] initWithShareSDKUserInfo:userInfo];
        
        SVShareResultState mfwState = result?SVShareResultStateSuccess:SVShareResultStateFail;
        NSString* errorMsg = [error description];
        
        if (resultHandler) {
            resultHandler(type,mfwUser,mfwState,errorMsg);
        }
    }];
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
//    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:[self getShareSDKShareType:type]];
//    NSMutableDictionary* retDict = [NSMutableDictionary dictionaryWithCapacity:0];
//    if ([credential uid]) {
//        retDict[@"uid"] = [credential uid];
//    }
//    if([credential token]){
//        retDict[@"token"] = [credential token];
//    }
//    if([credential secret]){
//        retDict[@"secret"] = [credential secret];
//    }
//    if([credential expired]){
//        retDict[@"expired"] = [credential expired];
//    }
//    if([credential extInfo]){
//        retDict[@"extInfo"] = [credential extInfo];
//    }
//
//
//
//    retDict[@"available"] = [NSNumber numberWithBool:[credential available]];
//
//    return retDict;
//}

- (id<ISVShareCredentialInfo>)getCredentialInfo:(ShareType)type
{
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
    SVShareCredentialInfo* info = [[SVShareCredentialInfo alloc] initWithShareSDKCredential:credential];
    return info;
}

#pragma mark ISSViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    if (self.blockViewContrllorWillShow) {
        self.blockViewContrllorWillShow(viewController);
    }
}


#pragma mark 关注
/**
 *    @brief    关注微信号（已废弃）
 *
 *    @param     userData     二维码数据
 */
//- (void)followWeixinUser:(NSString *)qrCode
//{
//    [ShareSDK followWeixinUser:qrCode];
//}

/**
 *    @brief  关注用户
 *
 *    @param    type    第三方平台
 *    @param    userName    用户名称
 */
- (void)followUserWithType:(ShareType)type
                  userName:(NSString*)userName
                    result:(void(^)(ShareType type, BOOL success, NSString* errorMsg))resultHandler
{
    ShareType shareType = type;
    [ShareSDK followUserWithType:shareType field:userName fieldType:SSUserFieldTypeName authOptions:nil viewDelegate:nil result:^(SSResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        if(state == SSResponseStateSuccess
           || state == SSResponseStateFail
           || state == SSResponseStateCancel)
        {
            if(resultHandler)
            {
                resultHandler(type,(state == SSResponseStateSuccess),[error errorDescription]);
            }
        }
    }];
}

#pragma mark 平台资源
/**
 *    @brief    获取平台客户端名称
 *
 *    @param     type     分享类型
 *
 *    @return    名称
 */
- (NSString *)getClientNameWithType:(ShareType)type
{
    return [ShareSDK getClientNameWithType:type];
}

/**
 *    @brief    获取平台客户端图标
 *
 *    @param     type     分享类型
 *
 *    @return    图标
 */
- (UIImage *)getClientIconWithType:(ShareType)type
{
    return [ShareSDK getClientIconWithType:type];
}


@end



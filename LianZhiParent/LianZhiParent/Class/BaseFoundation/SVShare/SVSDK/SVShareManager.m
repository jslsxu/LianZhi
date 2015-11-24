//
//  SVShareManager.m
//  LianZhiParent
//
//  Created by jslsxu on 15/11/11.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "SVShareManager.h"
@implementation SVShareManager
SYNTHESIZE_SINGLETON_FOR_CLASS(SVShareManager)
- (void)initialize
{
    [ShareSDK registerApp:AppKey_ShareSDK
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
//                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                        default:
                             break;
                     }

                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeSinaWeibo:
                             //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                             [appInfo SSDKSetupSinaWeiboByAppKey:AppKey_SinaWeibo
                                                       appSecret:AppSecret_SinaWeibo
                                                     redirectUri:kSinaWeiboRedirectURI
                                                        authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:AppKey_Weixin
                                                   appSecret:AppSecret_Weixin];
                             break;
                         case SSDKPlatformTypeQQ:
                             [appInfo SSDKSetupQQByAppId:AppKey_QZone
                                                  appKey:AppSecret_QZone
                                                authType:SSDKAuthTypeBoth];
                             break;
                        default:
                             break;

                     }
                 }];
}

- (void)shareWithType:(SSDKPlatformType)shareType image:(UIImage *)image imageUrl:(NSString *)imageUrl title:(NSString *)title content:(NSString *)content url:(NSString *)url result:(void(^)(SSDKPlatformType type, SSDKResponseState state, NSString *errorMsg))result
{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    NSArray* imageArray = @[image];
    
    if (imageArray) {
        
        [shareParams SSDKSetupShareParamsByText:content
                                         images:imageArray
                                            url:[NSURL URLWithString:url]
                                          title:title
                                           type:SSDKContentTypeAuto];
        
        //进行分享
        [ShareSDK share:shareType
             parameters:shareParams
         onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
             
             if(result)
                 result(shareType, state, error.description);
//             switch (state) {
//                 case SSDKResponseStateSuccess:
//                 {
//                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                         message:nil
//                                                                        delegate:nil
//                                                               cancelButtonTitle:@"确定"
//                                                               otherButtonTitles:nil];
//                     [alertView show];
//                     break;
//                 }
//                 case SSDKResponseStateFail:
//                 {
//                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                         message:[NSString stringWithFormat:@"%@", error]
//                                                                        delegate:nil
//                                                               cancelButtonTitle:@"确定"
//                                                               otherButtonTitles:nil];
//                     [alertView show];
//                     break;
//                 }
//                 case SSDKResponseStateCancel:
//                 {
//                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                         message:nil
//                                                                        delegate:nil
//                                                               cancelButtonTitle:@"确定"
//                                                               otherButtonTitles:nil];
//                     [alertView show];
//                     break;
//                 }
//                 default:
//                     break;
//             }
             
         }];
    }

}

@end

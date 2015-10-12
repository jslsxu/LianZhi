//
//  SVShareDef.h
//  SViPad
//
//  Created by jslsxu on 14-7-3.
//  Copyright (c) 2014年 sohu-inc. All rights reserved.
//

#ifndef SViPad_SVShareDef_h
#define SViPad_SVShareDef_h

/**
 *    用于第三方组件引用的头文件
 */

#import "ISVShareUserInfo.h"
#import "ISVShareCredentialInfo.h"
#import "ISVShareManager.h"

#define Is_IPAD  ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] &&[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
/**
 *  ShareSDK
 */
#define AppKey_ShareSDK @"881df198516f"

/**
 *  Weixin
 */
#define AppKey_Weixin       @"wx7b4dfff6299dc03d"
#define AppSecret_Weixin    @"be3024278615b729973054fd7ed7650e"

/**
 *  SinaWeibo
 */
#define AppKey_SinaWeibo @"251515278"
#define AppSecret_SinaWeibo @"d2b44c001606017236c18c4048768228"
//#define kSinaWeiboSourceApplication @"com.sina.weibo"
#define kSinaWeiboRedirectURI @"http://www.sina.com"

//#define AppKey_SinaWeibo @"568898243"
//#define AppSecret_SinaWeibo @"38a4f8204cc784f81f9f0daaf31e02e3"
////#define kSinaWeiboSourceApplication @"com.sina.weibo"
//#define kSinaWeiboRedirectURI @"http://www.sharesdk.cn"

/**
 *  QQ & QZone
 */
#define AppKey_QZone    @"1104828207" // 这个key实际是QQ开放平台的AppId
#define AppSecret_QZone    @"yEo5LXHSNtvhRQxu" // QQ没有secret,这个是AppKey
#endif

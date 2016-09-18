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

#define Is_IPAD  ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] &&[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
/**
 *  ShareSDK
 */
#define AppKey_ShareSDK         @"c2fa9bfd3228"
#define AppSecret_ShareSDK      @"c20bb368c6f8b57a16515773a9cbede8"

/**
 *  Weixin
 */
#define AppKey_Weixin       @"wxd3e0e544390c6121"
#define AppSecret_Weixin    @"8c2513ca4f30faa12cff7cb6084459b7"

/**
 *  SinaWeibo
 */
#define AppKey_SinaWeibo @"3762713272"
#define AppSecret_SinaWeibo @"62c3d7036d6c96c9a9a1080b0c2aecbc"
//#define kSinaWeiboSourceApplication @"com.sina.weibo"
#define kSinaWeiboRedirectURI @"http://www.sina.com"

//#define AppKey_SinaWeibo @"568898243"
//#define AppSecret_SinaWeibo @"38a4f8204cc784f81f9f0daaf31e02e3"
////#define kSinaWeiboSourceApplication @"com.sina.weibo"
//#define kSinaWeiboRedirectURI @"http://www.sharesdk.cn"

/**
 *  QQ & QZone
 */
#define AppKey_QZone    @"1104828209" // 这个key实际是QQ开放平台的AppId
#define AppSecret_QZone    @"ewrHQ2EPgPO3Btyl" // QQ没有secret,这个是AppKey
#endif

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
#define AppKey_ShareSDK         @"c2faf2d09804"
#define AppSecret_ShareSDK      @"7dff49cedbabf2e38357f1b27ccd60fa"

/**
 *  Weixin
 */
#define AppKey_Weixin       @"wx7b4dfff6299dc03d"
#define AppSecret_Weixin    @"be3024278615b729973054fd7ed7650e"

/**
 *  SinaWeibo
 */
#define AppKey_SinaWeibo @"460455511"
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
#define AppKey_QZone    @"1104828207" // 这个key实际是QQ开放平台的AppId
#define AppSecret_QZone    @"yEo5LXHSNtvhRQxu" // QQ没有secret,这个是AppKey
#endif

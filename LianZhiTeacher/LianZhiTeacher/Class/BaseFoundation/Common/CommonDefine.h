//
//  CommonDefine.h
//  BaseFoundation
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#ifndef BaseFoundation_CommonDefine_h
#define BaseFoundation_CommonDefine_h

#define RunTimeSysVersion               ([[UIDevice currentDevice].systemVersion floatValue])
#define IS_IOS8_LATER                   (RunTimeSysVersion >= 8.0f)

#define kCommonTeacherTintColor         [UIColor colorWithRed:39 / 255.0 green:187 / 255.0 blue:205 / 255.0 alpha:1.f]
#define kCommonBackgroundColor          [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:244 / 255.0 alpha:1.f]
#define kCommonSeparatorColor           [UIColor colorWithRed:0xEE / 255.0 green:0xEE / 255.0 blue:0xEE / 255.0 alpha:1.0]
#define kNormalTextColor                [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.f]
#define kSubTextColor                   [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1.f]
#define kWarningTextColor               [UIColor colorWithRed:164 / 255.0 green:70 / 255.0 blue:73 / 255.0 alpha:1.f]
#define kSepLineColor                   [UIColor colorWithRed:0xE0 / 255.0 green:0xE0 / 255.0 blue:0xE0 / 255.0 alpha:1.f]

#define kColor_33                       [UIColor colorWithHexString:@"333333"]
#define kColor_66                       [UIColor colorWithHexString:@"666666"]
#define kColor_99                       [UIColor colorWithHexString:@"999999"]
#define kColor_cc                       [UIColor colorWithHexString:@"cccccc"]

#define kRedColor                       [UIColor colorWithHexString:@"F0003A"]

#define kButtonTextFont                 [UIFont systemFontOfSize:17]
#define kCommonTextFont                 [UIFont systemFontOfSize:14]
#define kSubTextFont                    [UIFont systemFontOfSize:11]

#define kLineHeight                     0.5f
#define kRedDotSize                     7

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#ifdef DEBUG
#define DSLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#else
#define DSLog(...)
#endif

#ifdef DEBUG
#define NNSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NNSLog(...)
#endif

#define kStringFromValue(value)          ([@(value) description])

#define kCommonMaxNum                    500

#define kMaxVideoSize                   (1024 * 1024 * 200)

#define kAppStoreId                     @"967746734"

#define kTeacherClientAppStoreUrl           @"https://itunes.apple.com/us/app/lian-zhi-jiao-shi-ban/id967746734?l=zh&ls=1&mt=8"
#define kAutoNaviApiKey                     @"b3ddcca903cd26035f8f210f9b88e09e"   //normal
#define kAutoNaviApiInhouseKey              @"86f28512b262501f0cc9901e726f5638"          //inhouse

#define kClassZoneShareUrl                  @"http://m.edugate.cn/share/teacher/index.html"
#define kTreeHouseShareUrl                  @"http://m.5tree.cn/share/parent/index.html"  //正式环境

#define kBugtagsKey                         @"642ba56fcae0559e4e33f717e3bbd980"             //bugtags Key
#define kUmentAppKey                        @"57e9f58fe0f55a518c001629"


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


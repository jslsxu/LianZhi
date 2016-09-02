//
//  CommonDefine.h
//  BaseFoundation
//
//  Created by jslsxu on 14/12/16.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#ifndef BaseFoundation_CommonDefine_h
#define BaseFoundation_CommonDefine_h

#define kScreenWidth                    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight                   [UIScreen mainScreen].bounds.size.height

#define RunTimeSysVersion               ([[UIDevice currentDevice].systemVersion floatValue])
#define IS_IOS8_LATER                   (RunTimeSysVersion >= 8.0f)

#define kCommonTeacherTintColor         [UIColor colorWithRed:39 / 255.0 green:187 / 255.0 blue:205 / 255.0 alpha:1.f]
#define kCommonBackgroundColor          [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:244 / 255.0 alpha:1.f]
#define kCommonSeparatorColor           [UIColor colorWithRed:0xEE / 255.0 green:0xEE / 255.0 blue:0xEE / 255.0 alpha:1.0]
#define kNormalTextColor                [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.f]
#define kSubTextColor                   [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1.f]
#define kWarningTextColor               [UIColor colorWithRed:164 / 255.0 green:70 / 255.0 blue:73 / 255.0 alpha:1.f]
#define kSepLineColor                   [UIColor colorWithRed:0xEE / 255.0 green:0xEE / 255.0 blue:0xEE / 255.0 alpha:1.f]

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

#define kStringFromValue(value)          ([@(value) description])

#define kCommonMaxNum                    500

#define kAppStoreId                     @"967746734"

#define kTeacherClientAppStoreUrl           @"https://itunes.apple.com/us/app/lian-zhi-jiao-shi-ban/id967746734?l=zh&ls=1&mt=8"
#define kAutoNaviApiKey                     @"b3ddcca903cd26035f8f210f9b88e09e"   //normal
#define kAutoNaviApiInhouseKey              @"86f28512b262501f0cc9901e726f5638"          //inhouse

#define kClassZoneShareUrl                  @"http://m.edugate.cn/share/teacher/index.html"
#define kTreeHouseShareUrl                  @"http://m.5tree.cn/share/parent/index.html"  //正式环境

#define kBugtagsKey                         @"642ba56fcae0559e4e33f717e3bbd980"             //bugtags Key
#endif

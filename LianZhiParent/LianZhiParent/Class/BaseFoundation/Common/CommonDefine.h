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
#define IS_IOS7_LATER                   (RunTimeSysVersion >= 7.0f)
#define iOS7Later                       ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later                       ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later                       ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

#define kCommonParentTintColor          [UIColor colorWithRed:26 / 255.0 green:194 / 255.0 blue:130 / 255.0 alpha:1.f]
#define kCommonBackgroundColor          [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:244 / 255.0 alpha:1.f]
#define kNormalTextColor                [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.f]
#define kSubTextColor                   [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1.f]
#define kWarningTextColor               [UIColor colorWithRed:164 / 255.0 green:70 / 255.0 blue:73 / 255.0 alpha:1.f]
#define kSepLineColor                   [UIColor colorWithRed:0xEE / 255.0 green:0xEE / 255.0 blue:0xEE / 255.0 alpha:1.f]

#define kButtonTextFont                 [UIFont systemFontOfSize:17]
#define kCommonTextFont                 [UIFont systemFontOfSize:14]
#define kSubTextFont                    [UIFont systemFontOfSize:11]

#define kLineHeight                     0.5f

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
#define kMaxVideoSize                   (1024 * 1024 * 200)
#define kAppStoreID                     @"967746596"
#define kParentClientAppStoreUrl            @"https://itunes.apple.com/us/app/lian-zhi-jia-zhang-ban/id967746596?l=zh&ls=1&mt=8"


#define kAutoNaviApiKey                     @"a9e57a78a98c9f0fbb2bfb7ac390b96e"         //normal
#define kAutoNaviApiInhouseKey              @"32aefdf31d77f1d31770b07bf3ab68ab"         //inhouse

#define kClassZoneShareUrl                  @"http://m.edugate.cn/share/teacher/index.html"
#define kTreeHouseShareUrl                  @"http://m.5tree.cn/share/parent/index.html"  //正式环境

#define kBugtagsKey                         @"18842ccaef5c44136335788e1c0de1b3"
#endif

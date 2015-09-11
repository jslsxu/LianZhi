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

#define kCommonTeacherTintColor         [UIColor colorWithRed:39 / 255.0 green:187 / 255.0 blue:205 / 255.0 alpha:1.f]
#define kCommonBackgroundColor          [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1.f]
#define kCommonSeparatorColor           [UIColor colorWithRed:0xEE / 255.0 green:0xEE / 255.0 blue:0xEE / 255.0 alpha:1.0]
#define kNormalTextColor                [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.f]
#define kSubTextColor                   [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1.f]
#define kWarningTextColor               [UIColor colorWithRed:164 / 255.0 green:70 / 255.0 blue:73 / 255.0 alpha:1.f]
#define kSepLineColor                   [UIColor colorWithRed:0xeb / 255.0 green:0xeb / 255.0 blue:0xeb / 255.0 alpha:1.f]

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

#define kParentClientAppStoreUrl            @"https://itunes.apple.com/us/app/lian-zhi-jia-zhang-ban/id967746596?l=zh&ls=1&mt=8"
#define kTeacherClientAppStoreUrl           @"https://itunes.apple.com/us/app/lian-zhi-jiao-shi-ban/id967746734?l=zh&ls=1&mt=8"

#endif

//
//  NSString+Validate.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/2/15.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validate)
- (BOOL)isEmailAddress;
- (BOOL)isPhoneNumberValidate;
- (NSString *)transformToPinyin;
@end

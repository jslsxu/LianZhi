//
//  CommonInputVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/18.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface CommonInputVC : TNBaseViewController
{
    UITextField*    _textField;
}

- (instancetype)initWithOriginal:(NSString *)originalValue forKey:(NSString *)key completion:(void (^)(NSString *value))completion;
@end

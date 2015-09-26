//
//  RegisterVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface RegisterVC : TNBaseViewController
{
    
}
@property (nonatomic, copy)void(^LoginCompletion)(BOOL loginSuccess, BOOL loginCancel);
@end

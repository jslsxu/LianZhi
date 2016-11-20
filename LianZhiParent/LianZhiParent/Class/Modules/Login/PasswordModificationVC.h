//
//  PasswordModificationVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
extern NSString *const kPaswordModificationNotification;
typedef void(^ModificationCallBack)();
@interface PasswordModificationVC : TNBaseViewController<UITextFieldDelegate>
{
}
@property (nonatomic, assign)BOOL hideCancel;
@property (nonatomic, copy)ModificationCallBack callback;
@end

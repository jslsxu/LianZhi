//
//  RefuseVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

typedef NS_ENUM(NSInteger, ReasonType)
{
    ReasonTypeRefuse = 0,       //拒绝原因
    ReasonTypeCancel            //撤销原因
};

@interface RefuseVC : TNBaseViewController
{
    UTPlaceholderTextView*  _textView;
    UILabel*                _numLabel;
}
@property (nonatomic, assign)ReasonType reasonType;
@end

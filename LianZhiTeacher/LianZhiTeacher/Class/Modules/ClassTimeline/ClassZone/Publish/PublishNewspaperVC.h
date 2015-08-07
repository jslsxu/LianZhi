//
//  PublishNewspaperVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/24.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PublishBaseVC.h"

@interface PublishNewspaperVC : PublishBaseVC
{
    UITextView *    _textView;
    UILabel*        _numLabel;
//    UILabel*        _placeHolder;
    UIButton*       _notificationButton;
    UIButton*       _publishButton;
}
@property (nonatomic, copy)NSString *newsPaper;
@end

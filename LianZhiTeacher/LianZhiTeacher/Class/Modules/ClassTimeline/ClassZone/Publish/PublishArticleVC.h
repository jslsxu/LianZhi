//
//  PulishArticleVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "PublishBaseVC.h"

@interface PublishArticleVC : PublishBaseVC
{
    UIImageView*    _bgImageView;
    UIImageView*    _textBG;
    UTPlaceholderTextView *    _textView;
    UILabel*        _placeHolder;
    UILabel*        _numLabel;
    UIButton*       _publishButton;
}
@end

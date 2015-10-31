//
//  PublishHomeWorkPhotoVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/31.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "PublishHomeWorkBaseVC.h"

@interface PublishHomeWorkPhotoVC : PublishHomeWorkBaseVC
{
    UITouchScrollView*  _scrollView;
    UIImageView*        _imageView;
    UIButton*           _deleteButton;
    UTPlaceholderTextView*  _textView;
    UILabel*            _numLabel;
}
@property (nonatomic, strong)UIImage *image;
@end

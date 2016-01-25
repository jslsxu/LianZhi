//
//  HomeWorkVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "CourseView.h"
#import "HomeWorkAudioView.h"
#import "HomeWorkPhotoView.h"
@interface HomeWorkVC : TNBaseViewController<CourseViewDelegate>
{
    UITouchScrollView*           _scrollView;
    UIView*                 _contentView;
    UTPlaceholderTextView*  _textView;
    CourseView*             _courseView;
    HomeWorkAudioView*      _audioView;
    HomeWorkPhotoView*      _photoView;
}
@end

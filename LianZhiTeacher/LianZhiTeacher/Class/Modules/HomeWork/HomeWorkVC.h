//
//  HomeWorkVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@protocol CourseViewDelegate <NSObject>

- (void)courseViewDidChange;

@end

@interface CourseView : UIView<ReplyBoxDelegate>
{
    NSMutableArray*     _deleteButtons;
    BOOL                _edit;
    UILabel*            _nameLabel;
    NSMutableArray*     _courseArray;
    ReplyBox*           _replyBox;
}
@property (nonatomic, copy)NSString *course;
@property (nonatomic, weak)id<CourseViewDelegate> delegate;
@end

@interface HomeWorkVC : TNBaseViewController<CourseViewDelegate>
{
    UIScrollView*           _scrollView;
    UIView*                 _contentView;
    UTPlaceholderTextView*  _textView;
    CourseView*             _courseView;
}
@end

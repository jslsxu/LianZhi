//
//  CourseView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/12/7.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseViewDelegate <NSObject>

- (void)courseViewDidChange;
- (void)courseViewCourseChanged;
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

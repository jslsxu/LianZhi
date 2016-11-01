//
//  CourseSelectVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/1.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface CourseCell : TNTableViewCell{
    UIImageView*    _selectImageView;
    UILabel*        _nameLabel;
}
@property (nonatomic, copy)NSString *course;
@property (nonatomic, assign)BOOL courseSelected;
@end

@interface CourseAddCell : TNTableViewCell{
    
}

@end

@interface CourseSelectVC : TNBaseViewController
@property (nonatomic, copy)NSString *course;
@property (nonatomic, copy)void (^courseSelected)(NSString *course);
+ (NSString *)defaultCourse;
@end

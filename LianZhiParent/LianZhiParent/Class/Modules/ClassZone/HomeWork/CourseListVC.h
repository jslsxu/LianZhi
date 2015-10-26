//
//  HomeWorkVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/10/26.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface CourseItem : TNModelItem
@property (nonatomic, copy)NSString *courseID;
@property (nonatomic, copy)NSString *courseName;
@property (nonatomic, copy)NSString *courseLogo;
@property (nonatomic, assign)BOOL hasNew;
@end

@interface CourseListModel : TNListModel

@end

@interface CourseCell : TNCollectionViewCell
{
    UILabel*        _typeView;
    UILabel*        _nameLabel;
    UILabel*        _teacherLabel;
    UIView*         _redDot;
}

@end

@interface CourseListVC : TNBaseCollectionViewController
{
    
}
@end

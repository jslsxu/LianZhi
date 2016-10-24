//
//  HomeworkClassVC.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/10/22.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"

@interface HomeworkClassItem : TNBaseObject
@property (nonatomic, copy)NSString*    class_id;
@property (nonatomic, copy)NSString*    class_name;
@property (nonatomic, copy)NSString*    class_logo;
@property (nonatomic, copy)NSString*    school_id;
@property (nonatomic, copy)NSString*    school_name;
@property (nonatomic, assign)BOOL       has_new;
@end

@interface HomeworkClassModel : TNListModel

@end

@interface HomeworkClassCell : TNTableViewCell{
    LogoView*   _logoView;
    UILabel*    _classNameLabel;
    UILabel*    _schoolNameLabel;
    UIView*     _redDot;
    UIImageView*    _rightArrow;
    UIView*     _sepLine;
}

@end

@interface HomeworkClassVC : TNBaseTableViewController

@end

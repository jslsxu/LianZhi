//
//  ClassSelectVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/10/2.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ClassSelectCell : TNTableViewCell
{
    LogoView*       _logoView;
    UILabel*        _classNameLabel;
    UILabel*        _numLabel;
    UIImageView*    _selectImageView;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, assign)BOOL classSelected;
@end

@interface ClassSelectVC : TNBaseViewController
@property (nonatomic, strong)NSArray *originalClassArray;
@property (nonatomic, copy)void (^classSelectCallBack)(NSArray *classArray);
@end

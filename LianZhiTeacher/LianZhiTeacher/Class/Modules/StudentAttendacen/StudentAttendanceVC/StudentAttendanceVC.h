//
//  StudentAttendanceVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/7.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "StudentAttendanceCell.h"
#import "StudentAttendanceHeaderView.h"
@interface StudentAttendanceVC : TNBaseViewController
{
    UICollectionView*   _collectionView;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@end

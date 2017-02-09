//
//  GrowthRecordChildSelectVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "GrowthClassListModel.h"
@interface GrowthRecordChildSelectItemCell : UICollectionViewCell
@property (nonatomic, strong)GrowthStudentInfo* studentInfo;
@property (nonatomic, assign)BOOL           chosen;
@end

@interface GrowthRecordChildSelectCell : TNTableViewCell
@property (nonatomic, strong)GrowthClassInfo* classInfo;
@end

@interface GrowthRecordChildSelectVC : TNBaseViewController
@property (nonatomic, strong)NSArray* classArray;
@property (nonatomic, copy)void (^selectChanged)();
@end

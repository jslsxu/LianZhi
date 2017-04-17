//
//  GrowthTargetChildView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowthClassListModel.h"
@interface GrowthTargetChildItemView : UICollectionViewCell
@property (nonatomic, strong)GrowthStudentInfo* studentInfo;
@property (nonatomic, copy)void (^itemRemoved)();
@end

@interface GrowthTargetChildView : UIView
@property (nonatomic, copy)void (^addTargetCallback)();
@property (nonatomic, strong)NSArray* studentArray;
@end

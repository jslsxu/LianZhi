//
//  GrowthRecordChildSwitchView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/8.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrowthClassListModel.h"
@interface GrowthRecordChildCell : UICollectionViewCell
@property (nonatomic, strong)GrowthStudentInfo* studentInfo;
@end

@interface GrowthRecordChildSwitchView : UIView
@property (nonatomic, strong)NSArray* growthRecordArray;
@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, copy)void (^indexChanged)(NSInteger selectedIndex);
@end

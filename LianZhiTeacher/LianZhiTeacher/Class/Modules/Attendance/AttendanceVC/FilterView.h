//
//  FilterView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 16/12/18.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AttendanceClassFilterType){
    AttendanceClassFilterTypeAll = 0,
    AttendanceClassFilterTypeUnCommit = 1,
    AttendanceClassFilterTypeCommited = 2,
    AttendanceClassFilterTypeWuguQueqin = 3,
    AttendanceClassFilterTypeLate = 4,
};

@interface ClassFilterView : UIView
+ (void)showWithFilterType:(AttendanceClassFilterType)filterType completion:(void (^)(AttendanceClassFilterType filterType))completion;

+ (NSString *)filterNameForType:(AttendanceClassFilterType)filterType;
@end

@interface FilterView : UIView
@property (nonatomic, assign)AttendanceClassFilterType filterType;
@property (nonatomic, copy)void (^filterChanged)();
@end



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
    AttendanceClassFilterTypeNum = 5,
};

@interface ClassFilterView : UIView
+ (void)showWithFilterList:(NSArray *)filterList filterType:(NSString* )filterType completion:(void (^)(NSString* filterType))completion;
+ (NSString *)filterNameForType:(AttendanceClassFilterType)filterType;
@end

@interface FilterView : UIView
@property (nonatomic, copy)NSString* filterType;
@property (nonatomic, copy)void (^clickCallback)();
@end



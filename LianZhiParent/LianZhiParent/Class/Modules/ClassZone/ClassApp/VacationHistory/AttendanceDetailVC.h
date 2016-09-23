//
//  AttendanceDetailVC.h
//  LianZhiParent
//
//  Created by qingxu zhou on 16/9/23.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface AttendanceMonthDetailView : UIView{
    AvatarView*     _avatarView;
    
}

@end

@interface AttendanceDayDetailView : UIView{
    UILabel*    _dateLabel;
    
}

@end

@interface AttendanceDetailVC : TNBaseViewController
@property (nonatomic, strong)ClassInfo *classInfo;
@end

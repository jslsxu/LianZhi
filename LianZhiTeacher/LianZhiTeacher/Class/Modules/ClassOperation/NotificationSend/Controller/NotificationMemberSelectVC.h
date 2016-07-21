//
//  NotificationTargetSelectVC.h
//  LianZhiTeacher
//
//  Created by qingxu zhou on 16/7/21.
//  Copyright © 2016年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface NotificationMemberSelectVC : TNBaseViewController{
    UISegmentedControl*     _segmentCtrl;
}
@property (nonatomic, copy)void (^selectCompletion)(NSArray *targetArray);
@end

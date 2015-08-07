//
//  GrowthTimelinePublishVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "GrowthTimelinePublishCell.h"
#import "DatePickerView.h"
@interface GrowthTimelinePublishVC : UITableViewController<DatePickerDelegate>
{
    DatePickerView*         _datePickerView;
    NSMutableArray*         _timelineArray;
}
@property (nonatomic, strong)NSArray *students;
@property (nonatomic, strong)ClassInfo *classInfo;
@end

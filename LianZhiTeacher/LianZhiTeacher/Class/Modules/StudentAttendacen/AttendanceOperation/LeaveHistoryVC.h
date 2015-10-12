//
//  LeaveHistoryVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"

@interface LeaveHistoryItem : TNModelItem
@property (nonatomic, assign)NSInteger type;
@property (nonatomic, copy)NSString *start;
@property (nonatomic, copy)NSString *end;
@property (nonatomic, copy)NSString *time;
@property (nonatomic, copy)NSString *status;

@end

@interface LeaveHistoryModel : TNListModel

@end

@interface LeaveHistoryCell : TNTableViewCell
{
    UIImageView*    _typeImageView;
    UILabel*        _startLabel;
    UILabel*        _endLabel;
    UILabel*        _statusLabel;
    UILabel*        _timeLabel;
}

@end

@interface LeaveHistoryVC : TNBaseTableViewController
@property (nonatomic, copy)NSString *studentID;
@end

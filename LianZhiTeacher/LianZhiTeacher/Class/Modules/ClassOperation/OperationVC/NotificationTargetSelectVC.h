//
//  NotificationTargetSelectVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

typedef NS_ENUM(NSInteger, SelectType){
    SelectTypeNone = 0,
    SelectTypePart,
    SelectTypeAll
};

@interface NotificationTargetCell : TNTableViewCell
{
    UIButton*   _checkButton;
    UILabel*    _nameLabel;
    UIView*     _sepLine;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, readonly)UIButton *checkButton;
@property (nonatomic, readonly)UILabel *nameLabel;
@end

@interface NotificationGroupHeaderView : UIView
{
    UIButton*   _checkButton;
    UILabel*    _nameLabel;
}
@property (nonatomic, readonly)UIButton *checkButton;
@property (nonatomic, readonly)UILabel *nameLabel;
@property (nonatomic, assign)NSInteger selectType;
@end

@interface NotificationTargetSelectVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray*     _selectedClassArray;
    NSMutableArray*     _selectedGroupArray;
    UISegmentedControl* _segmentControl;
    UITableView*        _tableView;
    UIButton*           _selectAllButton;
}

@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSData *audioData;
@property (nonatomic, strong)NSDictionary *params;
@end

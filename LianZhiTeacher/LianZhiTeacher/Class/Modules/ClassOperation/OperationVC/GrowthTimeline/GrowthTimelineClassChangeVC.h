//
//  GrowthTimelineClassChangeVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

typedef NS_ENUM(NSInteger, SelectType)
{
    SelectTypeNone = 0,         //没有选择
    SelectTypePart,             //部分选择
    SelectTypeAll,              //全部选择
};
@interface GrowthClassCell : UITableViewCell
{
    LogoView*   _logoView;
    UILabel*    _nameLabel;
    
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, assign)SelectType selectType;
@end

@interface GrowthTimelineClassChangeVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableDictionary *   _paramsDic;
    UITableView*            _tableView;
}
@property (nonatomic, strong)NSMutableDictionary *record;
@end

//
//  InterestVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/13.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseWebViewController.h"

@interface InterestItem : TNModelItem
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, assign)NSInteger pv;
@property (nonatomic, copy)NSString *ctime;
@end

@interface InterestModel : TNListModel
{
    NSMutableArray*     _interestArray;
}

@property (nonatomic, assign)BOOL more;
@property (nonatomic, copy)NSString *maxID;
- (NSString *)timeForSection:(NSInteger)section;
@end

@interface InterestCell : TNTableViewCell
{
    UILabel*        _titleLabel;
    UIImageView*    _rightImageView;
    UIImageView*    _pvIcon;
    UILabel*        _pvCountLabel;
}
@end

@interface InterestVC : TNBaseTableViewController

@end

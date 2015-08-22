//
//  ChildrenInfoVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/16.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "iCarousel.h"
#import "PersonalInfoVC.h"

@interface ChildrenExtraInfoCell : UITableViewCell
{
    LogoView*   _logoView;
    UILabel*    _titleLabel;
    UILabel*    _extraLabel;
    UIButton*   _reportButton;
    UIView*     _sepLine;
}
@property (nonatomic, readonly)LogoView *logoView;

- (void)setText:(NSString *)text extra:(NSString *)extra;
@end

@interface ChildrenItemView : UIView
{
    AvatarView*     _avatar;
    UILabel*        _nameLabel;
}
@property (nonatomic, weak)ChildInfo *childInfo;
@end

@interface ChildrenInfoVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate, iCarouselDataSource, iCarouselDelegate>
{
    iCarousel*          _headerView;
    UITableView*        _tableView;
}
@property (nonatomic, assign)NSInteger curIndex;
@end

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

@interface AvatarCell : UITableViewCell
{
    AvatarView* _avatarView;
    UILabel*    _modifyLabel;
    UIView*     _sepLien;
}
@property (nonatomic, readonly)AvatarView *avatarView;
@property (nonatomic, strong)ChildInfo *childInfo;
@end

@class ChildrenExtraInfoCell;

@protocol ChildrenExtraCellDelegate <NSObject>

- (void)childrenExtraCellReport:(ChildrenExtraInfoCell *)cell;

@end

@interface ChildrenExtraInfoCell : UITableViewCell
{
    LogoView*   _logoView;
    UILabel*    _titleLabel;
    UILabel*    _extraLabel;
    UIButton*   _reportButton;
    UIView*     _sepLine;
}
@property (nonatomic, readonly)LogoView *logoView;
@property (nonatomic, weak)id<ChildrenExtraCellDelegate> delegate;

- (void)setText:(NSString *)text extra:(NSString *)extra;
@end

@interface ChildrenItemView : UICollectionViewCell
{
    UIView*         _mainContentView;
    UIView*         _borderBG;
    AvatarView*     _avatar;
    UILabel*        _nameLabel;
}
@property (nonatomic, assign)BOOL isFocused;
@property (nonatomic, weak)ChildInfo *childInfo;
@end

@interface ChildrenInfoVC : TNBaseViewController<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UICollectionView*           _headerView;
    UITableView*                _tableView;
}
@property (nonatomic, assign)NSInteger curIndex;
@end

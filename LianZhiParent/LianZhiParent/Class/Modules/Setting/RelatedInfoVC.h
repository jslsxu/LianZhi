//
//  RelatedInfoVC.h
//  LianZhiParent
//  关联信息
//  Created by jslsxu on 15/1/16.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

typedef NS_ENUM(NSInteger, RelationInfoType) {
    RelationInfoTypeSetting = 0,
    RelationInfoTypeLogin
};

@interface RelatedHeaderView : UICollectionViewCell
{
    UIImageView*    _bgImageView;
    AvatarView*     _avtarView;
    UILabel*        _nameLabel;
    UIImageView*    _genderImageView;
    UILabel*        _birthdayLabel;
    UIImageView*    _arrowImageView;
}
@property (nonatomic, strong)ChildInfo *childInfo;
@end


@interface RelatedItemInfoCell : TNTableViewCell
{
    UIImageView*    _bgImageView;
    LogoView*       _logoView;
    UILabel*        _nameLabel;
    UILabel*        _mobileLabel;
}
@property (nonatomic, assign)TableViewCellType cellType;
@property (nonatomic, strong)TNModelItem *item;
@end

@interface RelatedInfoVC : TNBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UICollectionView*               _collectionView;
    UICollectionViewFlowLayout*     _flowLayout;
    UIView*                         _headerView;
    UITableView*                    _tableView;
}
@property (nonatomic, assign)RelationInfoType infoType;
@end

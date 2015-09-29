//
//  TreeHouseDetailVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"

@interface TreeHouseDetailHeaderView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
{
    AvatarView* _avatar;
    UILabel*    _nameLabel;
    UILabel*    _timeLabel;
    UILabel*    _addressLabel;
    UIButton*   _deleteButon;
    UILabel*    _contentLabel;
    UIButton*   _tagButton;
    UICollectionView*   _collectionView;
    
}

@end

@interface TreeHouseDetailVC : TNBaseViewController
{
    
}
@property (nonatomic, copy)NSString *feedId;
@end

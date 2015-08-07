//
//  ChildrenInfoVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/16.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

#import "PersonalInfoVC.h"

@interface ChildInfoCell : UICollectionViewCell<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UILabel*                _idLabel;
    AvatarView*             _avatar;
    UIButton*               _modifyButton;
    UITextField*            _nameField;
    UILabel*                _genderLabel;
    NSMutableArray*         _infoArray;
    UIView*                 _headerView;
    UITableView *           _tableView;
}
@property (nonatomic, strong)UIImage *avatarImage;
@property (nonatomic, readonly)NSArray *infoArray;
@property (nonatomic, strong)ChildInfo *childInfo;

@end
@interface ChildrenInfoVC : TNBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView*               _collectionView;
    UICollectionViewFlowLayout*     _flowLayout;
    UIButton*                       _saveButton;
}
@property (nonatomic, assign)NSInteger curIndex;
@end

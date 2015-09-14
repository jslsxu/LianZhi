//
//  GrowthTimelineStudentsSelectVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/9.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface GrowthStudentItemCell : UICollectionViewCell
{
    AvatarView*     _avatarView;
    UILabel*        _nameLabel;
    UIImageView*    _checkedImageView;
}
@property (nonatomic, strong)StudentInfo *studentInfo;
@property (nonatomic, assign)NSInteger hasSend;
@property (nonatomic, assign)BOOL hasBeenSelected;
@end

@interface GrowthTimelineStudentsSelectVC : TNBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray*     _selectedArray;
    UICollectionView*   _collectionView;
    UIButton*           _selectAllButton;
    UIButton*           _sendButton;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, strong)NSArray *originalStudentArray;
@property (nonatomic, copy)void (^completion)(NSArray *studentArray);
@end

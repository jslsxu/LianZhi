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
@property (nonatomic, assign)BOOL hasSend;
@property (nonatomic, assign)BOOL hasBeenSelected;
@end

@interface GrowthTimelineStudentsSelectVC : TNBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray*     _selectedArray;
    UICollectionView*   _collectionView;
    UIButton*           _selectAllButton;
    UIButton*           _sendButton;
}
@property (nonatomic, assign)BOOL homework;
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, strong)NSMutableDictionary *record;
@property (nonatomic, copy)void (^selectionCompletion)(NSString *targetStr);
@end

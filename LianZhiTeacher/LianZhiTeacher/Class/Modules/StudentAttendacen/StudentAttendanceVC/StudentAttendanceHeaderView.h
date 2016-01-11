//
//  StudentAttendanceHeaderView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/10/8.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OffStudentCell : UICollectionViewCell
{
    AvatarView* _avatar;
    UILabel*    _statusLabel;
    UILabel*    _nameLabel;
}
@property (nonatomic, strong)StudentInfo *studentInfo;
@end

@interface StudentAttendanceHeaderView : UICollectionReusableView<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UIView*     _offHeader;
    UICollectionView*   _collectionView;
    UIView*     _attendanceHeader;
}
@property (nonatomic, assign)NSInteger sortColumn;
@property (nonatomic, strong)NSArray *offArray;
@end

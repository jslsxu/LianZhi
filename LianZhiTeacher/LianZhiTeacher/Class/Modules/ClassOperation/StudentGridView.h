//
//  StudentGridView.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/1/4.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentGridView : UICollectionViewCell
{
    UIImageView*    _bgImageView;
    UIImageView*    _avatarView;
    UIImageView*    _corner;
    UILabel*        _nameLabel;
    UIImageView*    _coverImage;
}
@property (nonatomic, strong)StudentInfo *studentInfo;
@end

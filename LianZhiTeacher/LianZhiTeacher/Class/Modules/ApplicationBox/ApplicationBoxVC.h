//
//  ApplicationBoxVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface ApplicationItemCell : UICollectionViewCell
{
    UIImageView*    _imageView;
    UILabel*        _titleLabel;
}

@end

@interface ApplicationBoxVC : TNBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView*           _collectionView;
    UICollectionViewFlowLayout* _layout;
}
@end

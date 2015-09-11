//
//  ApplicationBoxVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "LZTabBarButton.h"
@interface ApplicationItem : NSObject
@property (nonatomic, copy)NSString *imageStr;
@property (nonatomic, copy)NSString *title;
@end

@interface ApplicationItemCell : UICollectionViewCell
{
    UIView*         _bgView;
    LZTabBarButton*       _coverButton;
}
@property (nonatomic, weak)ApplicationItem *appItem;
@end

@interface ApplicationBoxVC : TNBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView*           _collectionView;
    UICollectionViewFlowLayout* _layout;
}
@end

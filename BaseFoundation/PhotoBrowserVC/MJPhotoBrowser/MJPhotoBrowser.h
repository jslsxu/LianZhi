//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "MJPhotoView.h"

@interface MJPhotoBrowser : TNBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate,MJPhotoViewDelegate>
{
    UICollectionView*               _collectionView;
    UICollectionViewFlowLayout*     _flowLayout;
}

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@end

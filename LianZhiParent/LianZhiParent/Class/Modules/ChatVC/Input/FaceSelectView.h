//
//  FaceSelectView.h
// MFWIOS
//
//  Created by dong jianbo on 12-5-25.
//  Copyright 2010 mafengwo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFWFace.h"
#define PageControlHeight           20
#define FaceSelectHeight            (kFaceItemSize * 2 + PageControlHeight)

@protocol FaceCollectionViewDelegate <NSObject>

- (void)faceCollectionViewDidSelect:(NSInteger)faceIndex;

@end
@interface FaceItemCell : UICollectionViewCell
{
    UIImageView*    _imageView;
     UILabel*        _nameLabel;
}
@property (nonatomic, assign)NSInteger faceIndex;
@end

@interface FaceCollectionView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionViewFlowLayout* _layout;
    UICollectionView*           _collectionView;
}
@property (nonatomic, weak)id<FaceCollectionViewDelegate> delegate;
@property (nonatomic, assign)NSInteger page;
@end

@protocol FaceSelectViewDelegate <NSObject>

- (void)faceSelectViewDidSelectAtIndex:(NSInteger)index;

@end

@interface FaceSelectView : UIView<FaceCollectionViewDelegate, UIScrollViewDelegate>
{
    UIScrollView*   _scrollView;
    UIPageControl*  _pageControl;
}
@property (nonatomic, weak)id<FaceSelectViewDelegate> delegate;
@end

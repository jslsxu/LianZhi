//
//  FunctionView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/9/5.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionItemCell : UICollectionViewCell
{
    UIImageView*    _imageView;
    UILabel*        _titleLabel;
}
@property (nonatomic, copy)NSString *imageStr;
@property (nonatomic, readonly)UILabel *titleLabel;
@end

@protocol FunctionViewDelegate <NSObject>

- (void)functionViewDidSelectAtIndex:(NSInteger)index;

@end

@interface FunctionView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView*   _collectionView;
}
@property (nonatomic, assign)BOOL canSendGift;
@property (nonatomic, weak)id<FunctionViewDelegate> delegate;
@end

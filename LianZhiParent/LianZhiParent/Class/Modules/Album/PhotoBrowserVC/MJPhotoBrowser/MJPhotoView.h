//
//  MJZoomingScrollView.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoItem.h"
@class  MJPhotoView;

@protocol MJPhotoViewDelegate <NSObject>
- (void)photoViewSingleTap:(MJPhotoView *)photoView;
@end

@interface MJPhotoView : UIScrollView <UIScrollViewDelegate>
// 图片
@property (nonatomic, strong) PhotoItem *photo;
// 代理
@property (nonatomic, weak) id<MJPhotoViewDelegate> photoViewDelegate;
@end

@interface PhotoBrowseCell : UICollectionViewCell
{
    MJPhotoView*    _photoView;
}
@property (nonatomic, readonly)MJPhotoView *photoView;
@property (nonatomic, strong)PhotoItem *photoItem;

@end
//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "MJPhotoView.h"

@protocol PhotoBrowserDelegate <NSObject>
- (void)photoBrowserFinished:(NSArray *)resultArray;

@end

@interface MJPhotoBrowser : TNBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate,MJPhotoViewDelegate>
{
    UICollectionView*               _collectionView;
    UICollectionViewFlowLayout*     _flowLayout;
}
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property (nonatomic, weak)id<PhotoBrowserDelegate> delegate;
@property (nonatomic, copy)void (^deleteCallBack)(NSInteger num);
@end

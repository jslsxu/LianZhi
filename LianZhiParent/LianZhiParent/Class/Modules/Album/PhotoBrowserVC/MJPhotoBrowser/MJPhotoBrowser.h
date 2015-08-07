//
//  MJPhotoBrowser.h
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>
#import "MJPhotoView.h"
#import "PhotoBrowserNavigationBar.h"

@protocol PhotoBrowserDelegate <NSObject>
- (void)photoBrowserEditFinished:(NSArray *)resultArray;

@end

@interface MJPhotoBrowser : TNBaseViewController <UICollectionViewDataSource, UICollectionViewDelegate,MJPhotoViewDelegate>
{
    UICollectionView*               _collectionView;
    UICollectionViewFlowLayout*     _flowLayout;
}
@property (nonatomic, assign) PhotoBrowserType browserType;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSUInteger currentPhotoIndex;
@property (nonatomic, copy)NSString *classID;
@property (nonatomic, weak)id<PhotoBrowserDelegate> delegate;
@property (nonatomic, copy)void (^deleteCallBack)(NSInteger num);
@end

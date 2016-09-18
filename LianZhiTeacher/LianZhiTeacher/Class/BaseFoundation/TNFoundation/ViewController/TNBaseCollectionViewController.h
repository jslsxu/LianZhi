//
//  TNBaseCollectionViewController.h
//  TNFoundation
//
//  Created by jslsxu on 14/10/19.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "TNListModel.h"
#import "TNBaseViewController.h"
#import "TNCollectionViewCell.h"
#import "MJRefresh.h"
#import "NetworkConnection.h"

@interface TNBaseCollectionViewController : TNBaseViewController<UICollectionViewDataSource, UICollectionViewDelegate, TNBaseTableViewData>
{
    UICollectionViewLayout*     _layout;
    UICollectionView*           _collectionView;
    TNListModel*                _collectionViewModel;
}

@property (nonatomic, readonly)TNListModel *collectionViewModel;
@property (nonatomic, readonly)UICollectionView *collectionView;
@property (nonatomic, copy)NSString *cellName;
@property (nonatomic, copy)NSString *modelName;
@property (nonatomic, assign)BOOL supportPullDown;
@property (nonatomic, assign)BOOL supportPullUp;

- (void)requestData:(REQUEST_TYPE)requestType;
- (void)cancelRequest;
- (HttpRequestTask *)makeRequestTaskWithType:(REQUEST_TYPE)requestType;
- (void)reloadData;
- (void)TNBaseCollectionViewControllerModifyLayout:(UICollectionViewLayout *)layout;
@end

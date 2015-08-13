//
//  POISelectVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "POIItemCell.h"
@class POISelectVC;
@protocol POISelectVCDelegate <NSObject>
@optional
- (void)poiSelectVC:(POISelectVC *)poiSelectVC didFinished:(POIItem *)poiItem;
- (void)poiSelectVCDidCancel:(POISelectVC *)poiSelectVC;
- (void)poiSelectVCDidClear:(POISelectVC *)poiSelectVC;

@end

@interface POISelectVC : TNBaseViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, MAMapViewDelegate, AMapSearchDelegate, UISearchDisplayDelegate>
{
    MAMapView*                  _mapView;
    UISearchBar*                _searchBar;
    UISearchDisplayController *_displayController;
    UITableView*                _tableView;
    AMapSearchAPI*              _poiSearcher;
}
@property (nonatomic, strong)UIColor *tintColor;
@property (nonatomic, strong)POIItem*   poiItem;
@property (nonatomic, weak)id<POISelectVCDelegate> delegate;
@end

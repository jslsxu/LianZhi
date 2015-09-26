//
//  POISelectVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "POISelectVC.h"

@interface POISelectVC ()
@property (nonatomic, strong)NSArray*   poiArray;
@property (nonatomic, strong)NSArray*   searchResult;
@property (nonatomic, strong)CLLocation *location;
@property (nonatomic, strong)AMapReGeocode *geoCode;
@end

@implementation POISelectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地点";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [_searchBar setDelegate:self];
    [self.view addSubview:_searchBar];
    
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    [_displayController setDelegate:self];
    _displayController.searchResultsDataSource = self;
    _displayController.searchResultsDelegate = self;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, self.view.width, self.view.height - _searchBar.bottom) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_tableView];
    
    _mapView = [[MAMapView alloc] init];
    [self.view addSubview:_mapView];
    [_mapView setShowsUserLocation:YES];
    [_mapView setDelegate:self];
}

- (void)onCancel
{
    if([self.delegate respondsToSelector:@selector(poiSelectVCDidCancel:)])
        [self.delegate poiSelectVCDidCancel:self];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _tableView)
        return self.poiArray.count;
    else
        return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"POIItemCell";
    POIItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil)
    {
        cell = [[POIItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if(tableView == _tableView)
        [cell setPoiItem:self.poiArray[indexPath.row]];
    else
        [cell setPoiItem:self.searchResult[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *targetArray = (tableView == _tableView) ? self.poiArray : self.searchResult;
    for (NSInteger i = 0; i < targetArray.count; i++) {
        POIItem *item = targetArray[i];
        if(i == indexPath.row)
        {
            [item setSelected:YES];
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            if([self.delegate respondsToSelector:@selector(poiSelectVC:didFinished:)])
                [self.delegate poiSelectVC:self didFinished:item];
        }
        else if(item.selected == YES)
        {
            [item setSelected:NO];
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType          = AMapSearchType_PlaceKeyword;
    request.keywords            = searchText;
    if(self.geoCode)
        request.city                = @[self.geoCode.addressComponent.citycode];
    
    request.page                    = 0;
    request.offset                  = 100;
    [_poiSearcher AMapPlaceSearch:request];
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{
    [mapView setShowsUserLocation:NO];
    self.location = userLocation.location;
    if(_poiSearcher == nil)
    {
        _poiSearcher = [[AMapSearchAPI alloc] initWithSearchKey:kAutoNaviApiKey Delegate:self];
    }
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType          = AMapSearchType_PlaceAround;
    request.location            = [AMapGeoPoint locationWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
    //    request.keywords            = @"餐饮";
    request.radius = 1000;
    /* 按照距离排序. */
    request.sortrule            = 1;
    request.requireExtension    = YES;
    request.offset              = 100;
    [_poiSearcher AMapPlaceSearch:request];
    
    
    //反向地理编码
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:self.location.coordinate.latitude longitude:self.location.coordinate.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [_poiSearcher AMapReGoecodeSearch: regeoRequest];
}

#pragma mark - AMapViewDelegate
/* POI 搜索回调. */
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
{
    if (respons.pois.count == 0)
    {
        return;
    }
    NSMutableArray *poiArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (AMapPOI *poiInfo in respons.pois)
    {
        POIItem *item = [[POIItem alloc] init];
        [item setPoiInfo:poiInfo];
        if([item.poiInfo.uid isEqualToString:self.poiItem.poiInfo.uid])
            [item setSelected:YES];
        [poiArray addObject:item];
    }
    if(request.searchType == AMapSearchType_PlaceAround)
    {
        POIItem *noLocationItem = [[POIItem alloc] init];
        [noLocationItem setClearLocation:YES];
        [poiArray insertObject:noLocationItem atIndex:0];
        self.poiArray = poiArray;
        [_tableView reloadData];
    }
    else
    {
        self.searchResult = poiArray;
        [_displayController.searchResultsTableView reloadData];
    }
    
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        self.geoCode = response.regeocode;
    }
}

#pragma mark - UISearchDisplayControllerDelegate

-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    UIEdgeInsets inset;
    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? (inset = UIEdgeInsetsMake(0, 0, height, 0)) : (inset = UIEdgeInsetsZero);
    [tableView setContentInset:inset];
    [tableView setScrollIndicatorInsets:inset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

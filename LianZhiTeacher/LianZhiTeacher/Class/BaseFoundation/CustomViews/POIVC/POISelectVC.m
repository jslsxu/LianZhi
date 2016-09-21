//
//  POISelectVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "POISelectVC.h"

@interface POISelectVC ()
@property (nonatomic, strong)UITableView*   tableView;
@property (nonatomic, strong)NSArray*   poiArray;
@property (nonatomic, strong)NSArray*   searchResult;
@property (nonatomic, strong)NSArray*   dataSource;
@property (nonatomic, strong)CLLocation *location;
@property (nonatomic, strong)AMapReGeocode *geoCode;
@end

@implementation POISelectVC

//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if(self){
//        [self addKeyboardNotifications];
//    }
//    return self;
//}
//
//- (void)onKeyboardWillShow:(NSNotification *)note{
//    NSDictionary *userInfo = [note userInfo];
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    NSInteger keyboardHeight = keyboardRect.size.height;
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight, 0)];
//    }];
//}
//
//- (void)onKeyboardWillHide:(NSNotification *)note{
//    NSDictionary *userInfo = [note userInfo];
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.tableView setContentInset:UIEdgeInsetsZero];
//    }];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择地点";
    if(_poiSearcher == nil)
    {
        _poiSearcher = [[AMapSearchAPI alloc] initWithSearchKey:[ApplicationDelegate curAutoNaviKey] Delegate:self];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    [_searchBar setDelegate:self];
    [self.view addSubview:_searchBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchBar.bottom, self.view.width, self.view.height - _searchBar.bottom) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_tableView];
    
    _mapView = [[MAMapView alloc] init];
    [_mapView setDelegate:self];
    [self.view addSubview:_mapView];
    [_mapView setShowsUserLocation:YES];
}

- (void)onCancel
{
    if([self.delegate respondsToSelector:@selector(poiSelectVCDidCancel:)])
        [self.delegate poiSelectVCDidCancel:self];
}

- (BOOL)isSearchResult{
    return [[_searchBar text] length] > 0;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseID = @"POIItemCell";
    POIItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if(cell == nil)
    {
        cell = [[POIItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    [cell setPoiItem:self.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        POIItem *item = self.dataSource[i];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.dataSource = nil;
    if([searchText length] > 0){
        [_tableView reloadData];
        AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
        
        request.searchType          = AMapSearchType_PlaceKeyword;
        request.keywords            = searchText;
        if(self.geoCode)
            request.city                = @[self.geoCode.addressComponent.citycode];
        
        request.page                    = 0;
        request.offset                  = 100;
        [_poiSearcher AMapPlaceSearch:request];
    }
    else{
        self.dataSource = self.poiArray;
        [_tableView reloadData];
    }
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{
    [mapView setShowsUserLocation:NO];
    self.location = userLocation.location;

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

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
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
        self.dataSource = self.poiArray;
        [_tableView reloadData];
    }
    else
    {
        if([request.keywords isEqualToString:[_searchBar text]]){
            self.searchResult = poiArray;
            self.dataSource = self.searchResult;
            [_tableView reloadData];
        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

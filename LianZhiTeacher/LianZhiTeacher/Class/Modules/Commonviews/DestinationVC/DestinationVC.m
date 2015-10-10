//
//  DestinationVC.m
//  LianZhiParent
//
//  Created by jslsxu on 15/10/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "DestinationVC.h"
#import "CheckInstalledMapAPP.h"
@interface DestinationVC ()<MKMapViewDelegate, UIActionSheetDelegate>
@property (nonatomic, assign)CLLocationCoordinate2D curLocation;
@property (nonatomic, assign)BOOL canGuide;
@end

@implementation DestinationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"位置信息";
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    [_mapView setRegion:MKCoordinateRegionMake(center, span)];
    [_mapView setDelegate:self];
    [_mapView setShowsUserLocation:YES];
    [self.view addSubview:_mapView];
    
    BasicMapAnnotation *annotation = [[BasicMapAnnotation alloc] init];
    [annotation setCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    [annotation setTitle:self.position];
    [_mapView addAnnotation:annotation];
    [_mapView selectAnnotation:annotation animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.curLocation = userLocation.coordinate;
    self.canGuide = YES;
    [mapView setShowsUserLocation:NO];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    self.canGuide = NO;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        if (!annotationView)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:@"CustomAnnotation"];
            annotationView.canShowCallout = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(onGuideRoute) forControlEvents:UIControlEventTouchUpInside];
            [button setSize:CGSizeMake(50, 25)];
            [button setBackgroundImage:[[UIImage imageWithColor:kCommonTeacherTintColor size:CGSizeMake(10, 10) cornerRadius:2] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:@"导航" forState:UIControlStateNormal];
            annotationView.rightCalloutAccessoryView = button;
        }
        return annotationView;
    }
    return nil;
}

-(void)onGuideRoute
{
    if(!self.canGuide)
    {
        [ProgressHUD showHintText:@"无法定位当前位置"];
        return;
    }
    NSArray *appListArr = [CheckInstalledMapAPP checkHasOwnApp];
    NSString *sheetTitle = [NSString stringWithFormat:@"导航到 %@",self.position];
    
    UIActionSheet *sheet;
    if ([appListArr count] == 2) {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1], nil];
    }else if ([appListArr count] == 3){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2], nil];
    }else if ([appListArr count] == 4){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2],appListArr[3], nil];
    }else if ([appListArr count] == 5){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2],appListArr[3],appListArr[4], nil];
    }
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *btnTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == 0) {
            CLLocationCoordinate2D to;
            
            to.latitude = self.latitude;
            to.longitude = self.longitude;
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
            
            toLocation.name = self.position;
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }
    if ([btnTitle isEqualToString:@"google地图"])
    {
        NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?saddr=%.8f,%.8f&daddr=%.8f,%.8f&directionsmode=transit",self.curLocation.latitude,self.curLocation.longitude,self.latitude,self.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    else if ([btnTitle isEqualToString:@"高德地图"])
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=%@&poiid=BGVIS&lat=%.8f&lon=%.8f&dev=1&style=2",self.position,self.latitude,self.longitude]];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    else if ([btnTitle isEqualToString:@"百度地图"])
    {
//        double bdNowLat,bdNowLon;
//        bd_encrypt(self.curLocation.latitude, self.curLocation.longitude, &bdNowLat, &bdNowLon);
        NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%.8f,%.8f&destination=%.8f,%.8f&&mode=driving",self.curLocation.latitude,self.curLocation.longitude,self.latitude,self.longitude];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

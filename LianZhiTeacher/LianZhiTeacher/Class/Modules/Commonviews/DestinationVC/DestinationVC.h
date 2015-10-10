//
//  DestinationVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/10/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import <MapKit/MapKit.h>
#import "RegionAnnotationView.h"

@interface DestinationVC : TNBaseViewController
{
    MKMapView*   _mapView;
}
@property (nonatomic, copy)NSString *position;
@property (nonatomic, assign)CGFloat longitude;
@property (nonatomic, assign)CGFloat latitude;
@end

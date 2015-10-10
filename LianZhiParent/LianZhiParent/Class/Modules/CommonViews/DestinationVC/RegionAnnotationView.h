//
//  RegionAnnotationView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/10/10.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <MapKit/MapKit.h>
@interface BasicMapAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end


@protocol doAcSheetDelegate <NSObject>
-(void)naviClick;
@end

@interface RegionAnnotationView : MKAnnotationView
{
    UIView*         _regionDetailView;
    UIImageView*    _bgImageView;
}
@property(nonatomic,strong) UIView *regionDetailView;
@property(nonatomic,strong) UIImageView *bgImgView;
@property(nonatomic,strong) BasicMapAnnotation *regionAnnotaytion;
@end

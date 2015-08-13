//
//  PoiInfoView.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/28.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoiInfoView : UIView<POISelectVCDelegate>
{
    UILabel*    _locationLabel;
}
@property (nonatomic, weak)UIViewController *parentVC;
@property (nonatomic, strong)POIItem *poiItem;
@end

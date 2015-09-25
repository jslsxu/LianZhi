//
//  PublishBaseVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/20.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "TreeHouseModel.h"
@protocol PublishTreeHouseDelegate <NSObject>
- (void)publishTreeHouseSuccess:(TreehouseItem *)item;

@end

@interface PublishBaseVC : TNBaseViewController<POISelectVCDelegate>
{
    PoiInfoView*    _poiInfoView;
}
@property (nonatomic, weak)id<PublishTreeHouseDelegate> delegate;
- (void)onBack;
@end

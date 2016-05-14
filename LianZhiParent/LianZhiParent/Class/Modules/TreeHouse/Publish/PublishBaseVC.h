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

typedef NS_ENUM(NSInteger, ForwardType){
    ForwardTypeNone = 0,
    ForwardTypeNotification,
    ForwardTypeClassZone,
};

@interface PublishBaseVC : TNBaseViewController<POISelectVCDelegate>
{
    PoiInfoView*    _poiInfoView;
}
@property (nonatomic, assign)ForwardType forward;
@property (nonatomic, copy)NSString *words;
@property (nonatomic, strong)POIItem *poiItem;
@property (nonatomic, weak)id<PublishTreeHouseDelegate> delegate;
- (void)onBack;
@end

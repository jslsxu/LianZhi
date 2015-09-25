//
//  PublishBaseVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/20.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "ClassZoneModel.h"

@protocol PublishZoneItemDelegate <NSObject>
- (void)publishZoneItemFinished:(ClassZoneItem *)zoneItem;
- (void)publishNewsPaperFinished:(NSString *)newsPaper;
@end

@interface PublishBaseVC : TNBaseViewController
{
    PoiInfoView*    _poiInfoView;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@property (nonatomic, weak)id<PublishZoneItemDelegate> delegate;
- (void)onBack;
@end

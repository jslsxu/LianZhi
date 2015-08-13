//
//  POIListModel.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNListModel.h"

@interface POIItem : TNModelItem
@property (nonatomic, strong)AMapPOI *poiInfo;
@property (nonatomic, assign)BOOL selected;
@property (nonatomic, assign)BOOL clearLocation;
@end

@interface POIListModel : TNListModel

@end

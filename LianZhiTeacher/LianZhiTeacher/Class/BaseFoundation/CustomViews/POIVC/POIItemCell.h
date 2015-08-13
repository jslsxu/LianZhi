//
//  POIItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "POIListModel.h"
@interface POIItemCell : TNTableViewCell
{
    UILabel*    _nameLabel;
    UILabel*    _detailLabel;
}
@property (nonatomic, strong)POIItem *poiItem;
@end

//
//  TNCollectionViewCell.m
//  TNFoundation
//
//  Created by jslsxu on 14/10/20.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNCollectionViewCell.h"

@implementation TNCollectionViewCell

- (void)setModelItem:(TNModelItem *)modelItem
{
    _modelItem = modelItem;
    [self onReloadData:_modelItem];
}

// 以下函数需要在继承类中重载，当cell重用的时候，需更新界面的显示
- (void)onReloadData:(TNModelItem *)modelItem
{
    // 在继承类中实现
}
@end

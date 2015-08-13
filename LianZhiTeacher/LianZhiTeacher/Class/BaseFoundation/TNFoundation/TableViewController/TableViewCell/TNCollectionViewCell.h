//
//  TNCollectionViewCell.h
//  TNFoundation
//
//  Created by jslsxu on 14/10/20.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNModelItem.h"

@interface TNCollectionViewCell : UICollectionViewCell
// 关联的数据项
@property(nonatomic, strong)TNModelItem* modelItem;


// 以下函数需要在继承类中重载，当cell重用的时候，需更新界面的显示
- (void)onReloadData:(TNModelItem *)modelItem;
@end

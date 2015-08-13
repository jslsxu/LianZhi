//
//  TNTableViewCell.h
//  TNFoundation
//
//  Created by jslsxu on 14-9-4.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNModelItem.h"

@interface TNTableViewCell : UITableViewCell

// 关联的数据项
@property(nonatomic, weak)TNModelItem* modelItem;

// 设置关联数据，此函数不用重载
- (void)setData:(TNModelItem *)modelItem;

// 以下函数需要在继承类中重载，当cell重用的时候，需更新界面的显示
- (void)onReloadData:(TNModelItem *)modelItem;

// 从modelItem计算cell的高度，每个继承类中都要实现一个static的同名函数
+ (NSNumber*)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width;
@end

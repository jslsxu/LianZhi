//
//  TNTableViewCell.m
//  TNFoundation
//
//  Created by jslsxu on 14-9-4.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"

@implementation TNTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.width = kScreenWidth;
    }
    return self;
}

// 设置关联数据
- (void)setData:(TNModelItem *)modelItem
{
    self.modelItem = modelItem;
    
    [self onReloadData:modelItem];
}

// 以下函数需要在继承类中重载，当cell重用的时候，需更新界面的显示
- (void)onReloadData:(TNModelItem *)modelItem
{
    // 在继承类中实现
}

// 从modelItem计算cell的高度，每个继承类中都要实现一个static的同名函数
+ (NSNumber*)cellHeight:(TNModelItem *)modelItem cellWidth:(NSInteger)width
{
    // 在继承类中实现
    return nil;
}


@end

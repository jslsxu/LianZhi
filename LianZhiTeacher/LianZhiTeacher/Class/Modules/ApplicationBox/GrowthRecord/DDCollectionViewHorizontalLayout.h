//
//  DDCollectionViewHorizontalLayout.h
//  LianZhiTeacher
//
//  Created by jslsxu on 17/2/7.
//  Copyright © 2017年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDCollectionViewHorizontalLayout : UICollectionViewFlowLayout
// 一行中 cell的个数
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;
@end

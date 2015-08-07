//
//  PhotoPickerItem.h
//  LianZhiParent
//
//  Created by jslsxu on 15/3/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoPickerItem : NSObject
@property (nonatomic, strong)ALAsset *asset;
@property (nonatomic, strong)PhotoItem *photoItem;
@property (nonatomic, assign)BOOL selected;
- (BOOL)isEqualTo:(PhotoPickerItem *)targetItem;
@end

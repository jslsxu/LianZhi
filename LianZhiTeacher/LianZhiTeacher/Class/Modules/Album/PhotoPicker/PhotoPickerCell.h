//
//  PhotoPickerCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/3/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNCollectionViewCell.h"
#import "PhotoPickerItem.h"
@interface PhotoPickerCell : TNCollectionViewCell
{
    UIImageView*    _imageView;
    UIView*         _coverView;
    UIImageView*    _checkMark;
}
@property (nonatomic, strong)PhotoPickerItem *item;
@end

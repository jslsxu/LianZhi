//
//  CollectionImageCell.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/1.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionImageCell : UICollectionViewCell
{
    UIImageView*    _imageView;
    UILabel*        _uploadLabel;
}
@property (nonatomic, strong)PhotoItem *item;
@end

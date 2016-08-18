//
//  MyGiftVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/11/24.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "GiftItem.h"

@interface GiftModel : TNListModel
@property (nonatomic, assign)NSInteger coinTotal;
@end

@interface GiftCell : TNCollectionViewCell
{
    UIView*         _bgView;
    UIImageView*    _imageView;
    UILabel*        _titleLabel;
    UILabel*        _coinLabel;
}
@end

@interface MyGiftVC : TNBaseCollectionViewController
@property (nonatomic, copy)void (^completion)(GiftItem *giftItem);
@end

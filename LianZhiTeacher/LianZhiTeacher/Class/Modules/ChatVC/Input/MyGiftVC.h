//
//  MyGiftVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/11/24.
//  Copyright © 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"

@interface GiftItem : TNModelItem
@property (nonatomic, copy)NSString *giftID;
@property (nonatomic, copy)NSString *giftName;
@property (nonatomic, assign)NSInteger coin;
@property (nonatomic, strong)PhotoItem *photoItem;
@end

@interface GiftModel : TNListModel
@property (nonatomic, assign)NSInteger coinTotal;
@end

@interface GiftCell : TNCollectionViewCell
{
    UIImageView*    _imageView;
    UILabel*        _titleLabel;
}
@end

@interface MyGiftVC : TNBaseCollectionViewController
@property (nonatomic, copy)void (^completion)(NSString *giftID);
@end

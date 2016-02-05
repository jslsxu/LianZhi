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
@property (nonatomic, assign)NSInteger ctype;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, assign)CGFloat width;
@property (nonatomic, assign)CGFloat height;
@property (nonatomic, assign)NSInteger num;
@end

@interface GiftModel : TNListModel
@property (nonatomic, assign)NSInteger coinTotal;
@end

@interface GiftCell : TNCollectionViewCell
{
    UIImageView*    _imageView;
    UILabel*        _titleLabel;
    UILabel*        _coinLabel;
}
@end

@interface MyGiftVC : TNBaseCollectionViewController
@property (nonatomic, copy)void (^completion)(NSString *giftID);
@end

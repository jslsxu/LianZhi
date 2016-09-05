//
//  ApplicationBoxVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "LZTabBarButton.h"
#import "ZYBannerView.h"
@interface ApplicationBoxHeaderView : UICollectionReusableView<ZYBannerViewDataSource, ZYBannerViewDelegate>
{
    ZYBannerView*   _bannerView;
}
@property (nonatomic, strong)NSArray *bannerArray;
- (void)updateWithHeight:(CGFloat)height;
@end

@interface BannerItem : TNModelItem
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *url;

@end

@interface ApplicationItem : TNModelItem
@property (nonatomic, copy)NSString *icon;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *appId;
@property (nonatomic, copy)NSString *badge;
@end

@interface ApplicationModel : TNListModel
@property (nonatomic, strong)NSArray *banner;
@end

@interface ApplicationItemCell : TNCollectionViewCell
{
    UIImageView*    _appImageView;
    UILabel*        _nameLabel;
    NumIndicator*         _indicator;
}
@property (nonatomic, copy)NSString *badge;
+ (CGFloat)cellHeight;
@end

@interface ApplicationBoxVC : TNBaseCollectionViewController
@end

//
//  ClassAppVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/1/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseCollectionViewController.h"
#import "ClassAppModel.h"
#import "RequestVacationVC.h"
#import "ZYBannerView.h"
@interface ApplicationBoxHeaderView : UICollectionReusableView<ZYBannerViewDataSource, ZYBannerViewDelegate>
{
    ZYBannerView*  _bannerView;
}
@property (nonatomic, strong)NSArray *bannerArray;
- (void)updateWithHeight:(CGFloat)height;
@end

@interface ClassAppVC : TNBaseCollectionViewController
@end

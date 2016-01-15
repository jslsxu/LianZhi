//
//  ApplicationBoxVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/8/12.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "LZTabBarButton.h"
@interface ApplicationItem : TNModelItem
@property (nonatomic, copy)NSString *icon;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *appId;
@property (nonatomic, copy)NSString *badge;
@end

@interface ApplicationModel : TNListModel

@end

@interface ApplicationItemCell : TNCollectionViewCell
{
    UIImageView*    _appImageView;
    UILabel*        _nameLabel;
    NumIndicator*         _indicator;
}
@property (nonatomic, copy)NSString *badge;
@end

@interface ApplicationBoxVC : TNBaseCollectionViewController
@end

//
//  ClassZoneVC.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/17.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "ClassZoneClassSwitchView.h"
#import "ClassAppVC.h"
#import "ClassZoneItemCell.h"

@protocol ClassZoneHeaderDelegate <NSObject>
@optional
- (void)classZoneAppClicked;
- (void)classZoneAlbumClicked;

@end
@interface ClassZoneHeaderView : UIView
{
    UIImageView*            _imageView;
    UIImageView*            _newpaperImageView;
    UILabel*                _contentLabel;
    UIButton*               _appButton;
    UIButton*               _albumButton;
    UIImageView*            _brashImage;
    UIView*                 _bottomView;
}
@property (nonatomic, copy)NSString *newsPaper;
@property (nonatomic, weak)id<ClassZoneHeaderDelegate> delegate;

@end

@interface ClassZoneVC : TNBaseTableViewController<ClassZoneSwitchDelegate, ClassZoneHeaderDelegate>
{
    ClassZoneClassSwitchView*       _switchView;
    ClassZoneHeaderView*            _headerView;
}
@end

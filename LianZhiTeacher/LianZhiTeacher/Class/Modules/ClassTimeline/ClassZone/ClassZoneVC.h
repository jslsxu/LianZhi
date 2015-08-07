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
#import "PublishArticleVC.h"
#import "PublishAudioVC.h"
#import "PublishPhotoVC.h"
#import "PublishNewspaperVC.h"
#import "ClassZoneManager.h"

extern NSString *const kPublishPhotoItemFinishedNotification;
extern NSString *const kPublishPhotoItemKey;

@protocol ClassZoneHeaderDelegate <NSObject>
- (void)classZoneAppClicked;
- (void)classZoneAlbumClicked;
- (void)classNewspaperClicked;
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

@interface ClassZoneVC : TNBaseTableViewController<ClassZoneSwitchDelegate, ClassZoneHeaderDelegate, PublishZoneItemDelegate>
{
    ClassZoneClassSwitchView*       _switchView;
    ClassZoneHeaderView*            _headerView;
    UIButton*                       _publishButton;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@end

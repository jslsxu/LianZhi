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
#import "ReplyBox.h"
#import "StatusManager.h"
#import "TreeHouseHeaderView.h"
#import "LZTabBarButton.h"
@protocol ClassZoneHeaderDelegate <NSObject>
@optional
- (void)classZoneAppClicked;
- (void)classZoneAlbumClicked;
- (void)classNewCommentClicked;
@end
@interface ClassZoneHeaderView : UIView
{
    UIImageView*            _imageView;
    UIImageView*            _newpaperImageView;
    UILabel*                _contentLabel;
//    LZTabBarButton*         _appButton;
//    UIButton*               _albumButton;
    UIImageView*            _brashImage;
    UIView*                 _bottomView;
    NewMessageIndicator*    _msgIndicator;
}
@property (nonatomic, readonly)LZTabBarButton *appButton;
@property (nonatomic, copy)NSString *newsPaper;
@property (nonatomic, weak)id<ClassZoneHeaderDelegate> delegate;
@property (nonatomic, strong)TimelineCommentItem *commentItem;

@end

@interface ClassZoneVC : TNBaseTableViewController<ClassZoneSwitchDelegate, ClassZoneHeaderDelegate, ReplyBoxDelegate>
{
//    ClassZoneClassSwitchView*       _switchView;
    ClassZoneHeaderView*            _headerView;
    ReplyBox*                       _replyBox;
}
@property (nonatomic, strong)ClassInfo *classInfo;
@end

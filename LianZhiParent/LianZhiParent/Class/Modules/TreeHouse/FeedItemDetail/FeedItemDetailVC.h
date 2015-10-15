//
//  FeedItemDetailVC.h
//  LianZhiTeacher
//
//  Created by jslsxu on 15/9/29.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "ClassZoneModel.h"
#import "PraiseListView.h"
#import "NewMessageModel.h"
@interface FeedItemDetailHeaderView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
{
    AvatarView* _avatar;
    UILabel*    _nameLabel;
    UILabel*    _timeLabel;
    UILabel*    _addressLabel;
    UIButton*   _deleteButon;
    UILabel*    _contentLabel;
    MessageVoiceButton* _voiceButton;
    UILabel*    _spanLabel;
    UICollectionView*   _collectionView;
}
@property (nonatomic, strong)ClassZoneItem *zoneItem;
@end

@interface FeedItemDetailVC : TNBaseViewController
{
    FeedItemDetailHeaderView*   _headerView;
    UIImageView*                _arrowImage;
    PraiseListView*             _praiseView;
    UITableView*                _tableView;
    UIView*                     _toolBar;
    NSMutableArray*             _buttonItems;
    ReplyBox*                   _replyBox;
}

@property (nonatomic, copy)NSString *classId;
@property (nonatomic, strong)ClassZoneItem *zoneItem;
@property (nonatomic, strong)NewMessageItem *messageItem;
@end

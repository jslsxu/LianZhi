//
//  TreeHouseItemDetailVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/10/2.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseViewController.h"
#import "CollectionImageCell.h"
#import "DetailCommentCell.h"
#import "PraiseListView.h"
#import "NewMessageModel.h"
@interface TreeHouseItemDetailHeaderView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
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
    UILabel*   _tagLabel;
    UIButton*   _tagButton;
}
@property (nonatomic, strong)TreehouseItem *treeHouseItem;
@property (nonatomic, copy)void (^deleteCallBack)();
@property (nonatomic, copy)void (^modifyCallBack)();
@end

@interface TreeHouseItemDetailVC : TNBaseViewController
{
    TreeHouseItemDetailHeaderView*   _headerView;
    UIImageView*                _arrowImage;
    PraiseListView*             _praiseView;
    UITableView*                _tableView;
    UIToolbar*                  _toolBar;
    NSMutableArray*             _buttonItems;
    ReplyBox*                   _replyBox;
}

@property (nonatomic, strong)TreehouseItem *treeHouseItem;
@property (nonatomic, strong)NewMessageItem *messageItem;
@property (nonatomic, copy)void (^deleteCallBack)();
@property (nonatomic, copy)void (^modifyCallBack)();
@end


//
//  SurroundingVC.h
//  LianZhiParent
//
//  Created by jslsxu on 15/5/27.
//  Copyright (c) 2015年 jslsxu. All rights reserved.
//

#import "TNBaseTableViewController.h"
#import "ClassZoneItemCell.h"
@class SurroundingCell;
@protocol SurroundingCellDelegate <NSObject>
@optional
- (void)onActionClicked:(SurroundingCell *)cell;
- (void)onResponseClickedAtTarget:(ResponseItem *)responseItem cell:(SurroundingCell *)cell;
- (void)onShowDetail:(TreehouseItem *)zoneItem;
@end
@interface SurroundingCell : TNTableViewCell<UICollectionViewDataSource, UICollectionViewDelegate, ResponseDelegate>
{
    AvatarView*         _avatar;
    UILabel*            _nameLabel;
    UILabel*            _timeLabel;
    UIButton*           _shareToTreeHouseButton;
    UILabel*            _contentLabel;
    UICollectionView*   _collectionView;
    MessageVoiceButton* _voiceButton;
    UILabel*            _spanLabel;
    UIButton*           _addressButton;
    UIButton*           _actionButton;
    ResponseView*       _responseView;
    UIView*             _sepLine;
}
@property (nonatomic, readonly)UIButton *actionButton;
@property (nonatomic, weak)id<SurroundingCellDelegate> delegate;
@end

@interface SurroundingListModel : TNListModel
@property (nonatomic, assign)BOOL hasMore;
@property (nonatomic, copy)NSString *minID;
@end

@interface SurroundingVC : TNBaseTableViewController<ReplyBoxDelegate, SurroundingCellDelegate>
{
    ReplyBox*                       _replyBox;
}
@end

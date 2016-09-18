//
//  TreeHouseCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/21.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "TreeHouseModel.h"
#import "MessageVoiceButton.h"
#import "ResponseView.h"
#import "ActionView.h"
extern NSString *const kTreeHouseItemDeleteNotification;
extern NSString *const kTreeHouseItemTagDeleteNotification;
extern NSString *const kTreeHouseItemTagSelectNotification;
extern NSString *const kTreeHouseItemKey;

@class TreeHouseCell;
@protocol TreeHouseCellDelegate <NSObject>
- (void)onShowDetail:(TreehouseItem *)treeItem;
- (void)onActionClicked:(TreeHouseCell *)cell;
- (void)onResponseClickedAtTarget:(ResponseItem *)responseItem cell:(TreeHouseCell *)cell;
- (void)onTreeHouseItemDelete:(TreehouseItem *)item;
@end

@interface TreeHouseCell : TNTableViewCell<UICollectionViewDataSource, UICollectionViewDelegate, ResponseDelegate>
{
    UILabel*            _authorLabel;
    UILabel*            _dateLabel;
    UIButton*           _addressButton;
    UILabel*            _timeLabel;
    UILabel*            _tagLabel;
    UIButton*           _tagButton;
    UIButton*           _actionButton;
    UIButton*           _trashButton;
    UIImageView*        _icon;
    UIView*             _bgView;
    UILabel*            _infoLabel;
    UICollectionViewFlowLayout* _layout;
    UICollectionView*   _collectionView;//照片
    MessageVoiceButton* _voiceButton;
    UILabel*            _spanLabel;
    ActionView*         _actionView;
    ResponseView*       _responseView;
}
@property (nonatomic, readonly)UIButton *actionButton;
@property (nonatomic, weak)id<TreeHouseCellDelegate> delegate;
@end

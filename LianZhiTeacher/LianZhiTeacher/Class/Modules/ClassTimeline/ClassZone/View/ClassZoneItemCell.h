//
//  ClassZoneItemCell.h
//  LianZhiParent
//
//  Created by jslsxu on 14/12/23.
//  Copyright (c) 2014年 jslsxu. All rights reserved.
//

#import "TNTableViewCell.h"
#import "ClassZoneModel.h"
#import "MessageVoiceButton.h"
#import "ResponseView.h"

@class ClassZoneItemCell;
@protocol ClassZoneItemCellDelegate <NSObject>
@optional
- (void)onActionClicked:(ClassZoneItemCell *)cell;
- (void)onShowDetail:(ClassZoneItem *)zoneItem;
- (void)onResponseClickedAtTarget:(ResponseItem *)responseItem cell:(ClassZoneItemCell *)cell;
- (void)onClassZoneItemDelete:(ClassZoneItem *)zoneItem;
@end


@interface ClassZoneItemCell : TNTableViewCell<UICollectionViewDataSource, UICollectionViewDelegate, ResponseDelegate, PhotoBrowserDelegate>
{
    AvatarView*         _avatar;
    UILabel*            _nameLabel;
    UILabel*            _timeLabel;
    UIButton*           _deleteButton;
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
@property (nonatomic, weak)id<ClassZoneItemCellDelegate> delegate;
@end


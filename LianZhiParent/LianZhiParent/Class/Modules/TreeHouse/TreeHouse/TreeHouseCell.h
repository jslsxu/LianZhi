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
extern NSString *const kTreeHouseItemDeleteNotification;
extern NSString *const kTreeHouseItemTagDeleteNotification;
extern NSString *const kTreeHouseItemTagSelectNotification;
extern NSString *const kTreeHouseItemKey;

@interface TreeHouseCell : TNTableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UILabel*            _authorLabel;
    UILabel*            _dateLabel;
    UILabel*            _addressLabel;
    UIButton*           _trashButton;
    UIImageView*        _icon;
    UIView*             _bgView;
    UILabel*            _infoLabel;
    UICollectionViewFlowLayout* _layout;
    UICollectionView*   _collectionView;//照片
    MessageVoiceButton* _voiceButton;
    UIView*             _sepLine;
    UILabel*            _timeLabel;
    UILabel*            _tagLabel;
    UIButton*           _tagButton;
}
@end

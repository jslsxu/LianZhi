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

@interface TreeHouseCell : TNTableViewCell<UICollectionViewDataSource, UICollectionViewDelegate, PhotoBrowserDelegate>
{
    UILabel*            _dateLabel;
    UIImageView*        _icon;
    UIImageView*        _bgImageView;
    UILabel*            _infoLabel;
    UICollectionViewFlowLayout* _layout;
    UICollectionView*   _collectionView;//照片
    MessageVoiceButton* _voiceButton;
    UIView*             _sepLine;
    UILabel*            _timeLabel;
    UILabel*            _authorLabel;
    UIButton*           _trashButton;
    UILabel*            _tagLabel;
    UIButton*           _tagButton;
}
@end

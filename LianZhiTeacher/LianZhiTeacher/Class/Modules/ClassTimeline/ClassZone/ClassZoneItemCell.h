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

extern NSString *const kClassZoneItemDeleteNotification;
extern NSString *const kClassZoneItemDeleteKey;

@interface ClassZoneItemCell : TNTableViewCell<UICollectionViewDataSource, UICollectionViewDelegate, PhotoBrowserDelegate>
{
    UIImageView*        _bgImageView;
    AvatarView*         _avatar;
    UILabel*            _nameLabel;
    UILabel*            _contentLabel;
    UICollectionView*   _collectionView;
    MessageVoiceButton* _voiceButton;
    UIView*             _sepLine;
    UIButton*           _deleteButton;
    UILabel*            _timeLabel;
}
@end
